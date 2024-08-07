import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log_exercise/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/constants/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.LIGHT_BLACK,
    ),
  );
}
