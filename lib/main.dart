import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import 'app/data/config/initialize_app.dart';
import 'app/middleware/auth_middleware.dart';
import 'app/data/local/user_provider.dart';
import 'app/constants/app_colors.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await initializeCoreApp();
  EasyLoading.instance.indicatorWidget = Lottie.asset(
    'assets/lottie/loader.json',
    repeat: true,
    width: 100,
    fit: BoxFit.contain,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      title: 'Skill Serve',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.k1f1d2c,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.kFFFFFF,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: AppColors.kFFFFFF),
        canvasColor: AppColors.k1f1d2c,
        colorSchemeSeed: AppColors.k806dff,
      ),
      initialRoute: UserProvider.initialRoute,
      getPages: AppPages.routes.map(
        (e) {
          return e.name == (Routes.LOGIN)
              ? e
              : e.copy(
                  middlewares: [
                    RouteMiddleWare(),
                  ],
                );
        },
      ).toList(),
      defaultTransition: Transition.fadeIn,
      builder: EasyLoading.init(),
    );
  }
}
