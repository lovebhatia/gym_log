import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log_exercise/src/app.dart';

import 'src/resources/app_colors.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.LIGHT_BLACK,
    ),
  );
}
