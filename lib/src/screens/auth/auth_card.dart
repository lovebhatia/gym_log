import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isGoogleSigningIn = false;
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
      text: kDebugMode ? DEFAULT_SERVER_TEST : DEFAULT_SERVER_PROD1);

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
    late Map<String, LoginActions> res;
    if (_authMode == AuthMode.Login) {
      res = await Provider.of<AuthProvider>(context, listen: false).login(
          _authData['username']!,
          _authData['password']!,
          _authData['serverUrl']!);
      // Check for "Bad User Credentials" in the response
      if (res.containsKey("error") && res["error"] == "Bad User Credentials") {
        _showErrorToast(context, "Incorrect username and password.");
        return;
      }

    } else {
      res = await Provider.of(context, listen: false).register(
        username: _authData['username']!,
        password: _authData['password']!,
        email: _authData['email']!,
        serverUrl: _authData['serverUrl']!,
      );
    }


  } on CustomHttpException catch (error) {
    print("---"+error.toString());
    // Show a specific toast message if "Bad User Credentials" is caught
    if (error.message == "Bad User Credentials") {
      _showErrorToast(context, "Incorrect username or password.");
    } else {
      print('in catch error');
      _showErrorToast(context, "Incorrect username or password.");
    }
  } catch (error) {
    print('in catch');
    if(error == 'Bad User Credentials') {
      _showErrorToast(context, "Incorrect username or password.");
    }
    _showErrorToast(context, "An unexpected error occurred. Please try again.");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

void _showErrorToast(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

  void _switchAuthMode() {
    if (!_canRegister) {
      launchURL(DEFAULT_SERVER_PROD1, context);
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

  Future<void> _googleSignInHandler() async {
  try {
    setState(() {
      _isGoogleSigningIn = true;
    });

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.googleLogin(googleUser);
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google Sign-In failed: $error')),
    );
  } finally {
    setState(() {
      _isGoogleSigningIn = false;
    });
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
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                key: const Key('inputUsername'),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  errorMaxLines: 2,
                  prefixIcon: Icon(Icons.account_circle),
                ),
                autofillHints: const [AutofillHints.username],
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Invalid username';
                  }
                  if (!RegExp(r'^[\w.@+-]+$').hasMatch(value)) {
                    return 'Only valid characters are allowed';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s\b|\b\s')),
                ],
                onSaved: (value) {
                  _authData['username'] = value!;
                },
              ),
              SizedBox(height: 10.0),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  key: const Key('inputEmail'),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail),
                  ),
                  autofillHints: const [AutofillHints.email],
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isNotEmpty && !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
              SizedBox(height: 10.0),
              StatefulBuilder(builder: (context, updateState) {
                return TextFormField(
                  key: const Key('inputPassword'),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
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
                      return 'Password too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                );
              }),
              SizedBox(height: 10.0),
              if (_authMode == AuthMode.Signup)
                StatefulBuilder(builder: (context, updateState) {
                  return TextFormField(
                    key: const Key('inputPassword2'),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
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
                    obscureText: confirmIsObscure,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords don\'t match';
                      }
                      return null;
                    },
                  );
                }),
              
              SizedBox(height: 10.0),
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
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Register',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
  onPressed: _isGoogleSigningIn ? null : () async {
    setState(() {
      _isGoogleSigningIn = true;
    });

    try {
      await _googleSignInHandler();
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleSigningIn = false;
        });
      }
    }
  },
  icon: _isGoogleSigningIn
      ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
      : const Icon(Icons.login),
  label: _isGoogleSigningIn
      ? const Text('Signing in...')
      : const Text('Sign in with Google'),
),

              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  _switchAuthMode();
                },
                child: Text(
                  _authMode != AuthMode.Signup
                      ? 'Don\'t have an account? Register'
                      : 'Already have an account? Login',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
