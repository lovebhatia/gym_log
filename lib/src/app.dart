import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/providers/auth.dart';
import 'package:gym_log_exercise/src/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_colors.dart';
import 'screens/auth/auth_screen.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => ScreenUtilInit(
          designSize: const Size(360, 640), // Specify your design size
          builder: (BuildContext context, Widget? _) => MaterialApp(
            title: 'healthify',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: AppColors.LIGHT_BLACK),
            ),
            debugShowCheckedModeBanner: false,
            home: //HomeScreen(),

                auth.isAuth
                    ? const HomeScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) => AuthScreen(),
                      ),
            routes: {HomeScreen.routeName: (ctx) => const HomeScreen()},
          ),
        ),
      ),
    );
  }
}
