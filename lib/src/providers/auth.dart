import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log_exercise/src/exceptions/httpException.dart';
import 'package:gym_log_exercise/src/constants/consts.dart';
import 'package:gym_log_exercise/src/providers/make_uri.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:android_metadata/android_metadata.dart';
import 'package:version/version.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginActions { update, proceed }

class AuthProvider with ChangeNotifier {
  String? token;
  String? serverUrl;
  String? serverVersion;
  String? userId;
  PackageInfo? applicationVersion;
  Map<String, String> metadata = {};

  static const MIN_APP_VERSION_URL = 'min-app-version';
  static const SERVER_VERSION_URL = 'version';
  static const REGISTRATION_URL = 'register';
  static const LOGIN_URL = 'auth/login';
  late http.Client client;

  AuthProvider([http.Client? client, bool? checkMetadata]) {
    this.client = client ?? http.Client();
    if (checkMetadata ?? true) {
      try {
        if (Platform.isAndroid) {
          AndroidMetadata.metaDataAsMap.then((value) => metadata = value!);
        } else if (Platform.isLinux || Platform.isMacOS) {
          metadata = {
            MANIFEST_KEY_CHECK_UPDATE:
                Platform.environment[MANIFEST_KEY_CHECK_UPDATE] ?? '',
            MANIFEST_KEY_API: Platform.environment[MANIFEST_KEY_API] ?? ''
          };
        }
      } on PlatformException {
        throw Exception(
            'An error occurred reading the metadata from AndroidManifest');
      } catch (error) {}
    }
  }
  bool dataInit = false;

  bool get isAuth {
    return token != null;
  }

  Future<void> setServerVersion() async {
    final response = await client.get(makeUri(serverUrl!, SERVER_VERSION_URL));
    final responseData = json.decode(response.body);
    serverVersion = responseData;
  }

  Future<void> initData(String serverUrl) async {
    this.serverUrl = serverUrl;
    await setApplicationVersion();
    //await setServerVersion();
  }

  /// (flutter) Application version
  Future<void> setApplicationVersion() async {
    applicationVersion = await PackageInfo.fromPlatform();
  }

  Future<bool> applicationUpdateRequired(
      [String? version, Map<String, String>? metadata]) async {
    metadata ??= this.metadata;
    if (!metadata.containsKey(MANIFEST_KEY_CHECK_UPDATE) ||
        metadata[MANIFEST_KEY_CHECK_UPDATE] == 'false') {
      return false;
    }

    final applicationCurrentVersion = version ?? applicationVersion!.version;
    final response = await client.get(makeUri(serverUrl!, MIN_APP_VERSION_URL));
    final currentVersion = Version.parse(applicationCurrentVersion);
    final requiredVersion = Version.parse(jsonDecode(response.body));
    return requiredVersion > currentVersion;
  }

  //Register a new user
  Future<Map<String, LoginActions>> register(
      {required String username,
      required String password,
      required String email,
      required String serverurl}) async {
    try {
      final Map<String, String> data = {
        'username': username,
        'password': password
      };
      if (email != '') {
        data['email'] = email;
      }
      final response = await client.post(
        makeUri(serverurl, REGISTRATION_URL),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader:
              'Token ${metadata[MANIFEST_KEY_API]}',
          HttpHeaders.userAgentHeader: getAppNameHeader(),
        },
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw CustomHttpException(responseData);
      }

      //if update is required dont login user
      if (await applicationUpdateRequired()) {
        return {'action': LoginActions.update};
      }

      return login(username, password, serverurl);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, LoginActions>> login(
      String username, String password, String serverUrl) async {
    await logout(shouldNotify: false);
    try {
      final response = await client.post(
        makeUri(DEFAULT_SERVER_PROD1, LOGIN_URL),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.userAgentHeader: getAppNameHeader(),
        },
        body: json.encode({'username': username, 'password': password}),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw CustomHttpException(responseData);
      }

      await initData(serverUrl);

      // If update is required don't log in user
      if (await applicationUpdateRequired()) {
        return {'action': LoginActions.update};
      }

      //Log user in
      token = responseData['accessToken'];
      notifyListeners();

      //store login data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'serverUrl': this.serverUrl,
        'userId': responseData['userId']
      });
      final serverData = json.encode({
        'serverUrl': this.serverUrl,
      });

      prefs.setString('userData', userData);
      prefs.setString('lastServer', serverData);
      return {'action': LoginActions.proceed};
    } catch (error) {
      rethrow;
    }
  }

  Future<void> googleLogin(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Handle successful sign-in
      String? token = await userCredential.user!.getIdToken();
      String userId = userCredential.user!.uid;
      print(userId + "--" + token!);
      User? user = userCredential.user;

if (user != null) {
  String uid = user.uid;
  String email = user.email ?? 'No email';
  String displayName = user.displayName ?? 'No display name';
  String photoURL = user.photoURL ?? 'No photo URL';
  
  print('UID: $uid');
  print('Email: $email');
  print('Display Name: $displayName');
  print('Photo URL: $photoURL');
}
      // Notify listeners about authentication state change
      notifyListeners();

      // Store login data in shared preferences (if needed)
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  //Loads the latest server url from which the user succesfully logged in
  Future<String> getServerUrlFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('lastServer')) {
      return DEFAULT_SERVER_PROD;
    }
    final userData = json.decode(prefs.getString('lastServer')!);
    return userData['serverUrl'] as String;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      log('auto login failed');
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!);
    token = extractedUserData['token'];
    serverUrl = extractedUserData['serverUrl'];

    log('autoLogin Successful');
    setApplicationVersion();
    //setServerVersion();
    notifyListeners();
    return true;
  }

  Future<void> logout({bool shouldNotify = true}) async {
    log('logging out');
    token = null;
    serverUrl = null;
    dataInit = false;

    if (shouldNotify) {
      notifyListeners();
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  /// Returns the application name and version
  ///
  /// This is used in the headers when talking to the API
  String getAppNameHeader() {
    String out = '';
    if (applicationVersion != null) {
      out = '/${applicationVersion!.version} '
          '(${applicationVersion!.packageName}; '
          'build: ${applicationVersion!.buildNumber})';
    }
    return '$out';
  }
}
