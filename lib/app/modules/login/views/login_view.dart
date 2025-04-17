import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.k1f1d2c,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.k806dff,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(10, 0),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.login,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.k262837,
              child: const Center(
                child: Text(
                  'LoginView is working',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
