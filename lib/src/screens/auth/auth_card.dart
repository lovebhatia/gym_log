import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log_exercise/src/exceptions/httpException.dart';
import 'package:gym_log_exercise/src/constants/consts.dart';
import 'package:gym_log_exercise/src/providers/auth.dart';
import 'package:gym_log_exercise/src/providers/launch_url.dart';
import 'package:gym_log_exercise/src/constants/app_colors.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthCardState();
  }
}

class _AuthCardState extends State<AuthCard> {
  bool isObscure = true;
  bool confirmIsObscure = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _canRegister = true;
  AuthMode _authMode = AuthMode.Login;
  bool _hideCustomServer = true;
  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
    'serverUrl': '',
  };

  var _isLoading = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _serverUrlController = TextEditingController(
      text: kDebugMode ? DEFAULT_SERVER_TEST : DEFAULT_SERVER_PROD);

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().getServerUrlFromPrefs().then((value) {
      _serverUrlController.text = value;
    });

    // Check if the API key is set
    //
    // If not, the user will not be able to register via the app
    try {
      final metadata =
          Provider.of<AuthProvider>(context, listen: false).metadata;
      if (metadata.containsKey(MANIFEST_KEY_API) &&
          metadata[MANIFEST_KEY_API] == '') {
        _canRegister = false;
      }
    } on PlatformException {
      _canRegister = false;
    }
    _preFillTextFields();
  }

  void _preFillTextFields() {
    if (kDebugMode && _authMode == AuthMode.Login) {
      setState(() {
        _usernameController.text = TESTSERVER_USER_NAME;
        _passwordController.text = TESTSERVER_PASSWORD;
      });
    }
  }

  void _resetTextFields() {
    _usernameController.clear();
    _passwordController.clear();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      //Login Existing users
      late Map<String, LoginActions> res;
      if (_authMode == AuthMode.Login) {
        res = await Provider.of<AuthProvider>(context, listen: false).login(
            _authData['username']!,
            _authData['password']!,
            _authData['serverUrl']!);

        // Register new user
      } else {
        res = await Provider.of(context, listen: false).register(
          username: _authData['username']!,
          password: _authData['password']!,
          email: _authData['email']!,
          serverUrl: _authData['serverUrl']!,
        );
      }

      setState(() {
        _isLoading = false;
      });
    } on CustomHttpException catch (error) {
      if (mounted) {}
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      if (mounted) {}
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (!_canRegister) {
      launchURL(DEFAULT_SERVER_PROD, context);
      return;
    }

    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _resetTextFields();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _preFillTextFields();
    }
  }

  void _googleSignInHandler() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        //final credential = GoogleA
        final AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        await authProvider.googleLogin(googleUser);
      }
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8.0,
      child: Container(
        width: deviceSize.width * 0.9,
        padding: EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 0.025 * deviceSize.height),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const Key('inputUsername'),
                    decoration: const InputDecoration(
                        labelText: 'username',
                        errorMaxLines: 2,
                        prefixIcon: Icon(Icons.account_circle)),
                    autofillHints: const [AutofillHints.username],
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'invalidUsername';
                      }
                      if (!RegExp(r'^[\w.@+-]+$').hasMatch(value)) {
                        return 'usernameValidChars';
                      }

                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s\b|\b\s'))
                    ],
                    onSaved: (value) {
                      _authData['username'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      key: const Key('inputEmail'),
                      decoration: const InputDecoration(
                        labelText: 'email',
                        prefixIcon: Icon(Icons.mail),
                      ),
                      autofillHints: const [AutofillHints.email],
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,

                      // Email is not required
                      validator: (value) {
                        if (value!.isNotEmpty && !value.contains('@')) {
                          return 'invalidEmail';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                  StatefulBuilder(builder: (context, updateState) {
                    return TextFormField(
                      key: const Key('inputPassword'),
                      decoration: InputDecoration(
                        labelText: 'password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            isObscure = !isObscure;
                            updateState(() {});
                          },
                        ),
                      ),
                      autofillHints: const [AutofillHints.password],
                      obscureText: isObscure,
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'passwordTooShort';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    );
                  }),
                  if (_authMode == AuthMode.Signup)
                    StatefulBuilder(builder: (context, updateState) {
                      return TextFormField(
                        key: const Key('inputPassword2'),
                        decoration: InputDecoration(
                          labelText: 'confirmPassword',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(confirmIsObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              confirmIsObscure = !confirmIsObscure;
                              updateState(() {});
                            },
                          ),
                        ),
                        controller: _password2Controller,
                        enabled: _authMode == AuthMode.Signup,
                        obscureText: confirmIsObscure,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'passwordsDontMatch';
                                }
                                return null;
                              }
                            : null,
                      );
                    }),
                  // Off-stage widgets are kept in the tree, otherwise the server URL
                  // would not be saved to _authData
                  Offstage(
                    offstage: _hideCustomServer,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            key: const Key('inputServer'),
                            decoration: const InputDecoration(
                                // labelText: AppLocalizations.of(context)!
                                //     .customServerUrl,
                                // helperText: AppLocalizations.of(context)!
                                //    .customServerHint,
                                helperMaxLines: 4),
                            controller: _serverUrlController,
                            validator: (value) {
                              if (Uri.tryParse(value!) == null) {
                                'invalidUrl';
                              }

                              if (value.isEmpty || !value.contains('http')) {
                                'invalidUrl';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // Remove any trailing slash
                              if (value!.lastIndexOf('/') ==
                                  (value.length - 1)) {
                                value =
                                    value.substring(0, value.lastIndexOf('/'));
                              }
                              _authData['serverUrl'] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.undo),
                              onPressed: () {
                                _serverUrlController.text = kDebugMode
                                    ? DEFAULT_SERVER_TEST
                                    : DEFAULT_SERVER_PROD;
                              },
                            ),
                            const Text('reset')
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_isLoading) {
                        return _submit(context);
                      }
                    },
                    child: Container(
                      key: const Key('actionButton'),
                      width: double.infinity,
                      height: 0.065 * deviceSize.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        //  color: proPrimaryColor,
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Register',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.025 * deviceSize.height),
                  ElevatedButton(
                    onPressed: _googleSignInHandler,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.login),
                        SizedBox(width: 10),
                        Text('Sign in with Google'),
                      ],
                    ),
                  ),
                  Builder(
                    key: const Key('toggleActionButton'),
                    builder: (context) {
                      final String text =
                          _authMode != AuthMode.Signup ? 'Register' : 'Login';

                      return GestureDetector(
                        onTap: () {
                          _switchAuthMode();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.substring(0, text.lastIndexOf('?') + 1),
                              ),
                              Text(
                                text.substring(
                                    text.lastIndexOf('?') + 1, text.length),
                                style: const TextStyle(
                                  //color: wgerPrimaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
