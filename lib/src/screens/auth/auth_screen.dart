import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_log_exercise/src/constants/app_colors.dart';
import '../../constants/app_constant.dart';
import 'auth_card.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthScreen extends StatelessWidget {
  static const routename = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.BLACK,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height:
                        25.h), // Padding top using SizedBox instead of Padding
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        height: 0.55 * deviceSize.height,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Image(
                            image:
                                NetworkImage('${AppConst.imageBaseUrl}beg.jpg'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 94.0),
                            child: const Text(
                              'Gym fit',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 0.025 * deviceSize.height),
                          const AuthCard(), // No need for Flexible here
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
