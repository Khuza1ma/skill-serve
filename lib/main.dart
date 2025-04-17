import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/constants/app_colors.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.k1f1d2c,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.kFFFFFF,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: AppColors.kFFFFFF),
        canvasColor: AppColors.k1f1d2c,
        colorSchemeSeed: AppColors.k806dff,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
