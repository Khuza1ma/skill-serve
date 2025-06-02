import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';

import '../../../data/models/user_entity.dart';
import '../../../data/remote/services/user_service.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/app_snackbar.dart';

class LoginController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Password visibility
  final RxBool hidePassword = true.obs;

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        final User? user = await UserService.login(
          username: formKey.currentState?.value['username'],
          password: formKey.currentState?.value['password'],
        );
        if (user != null) {
          logWTF(user);
          appSnackbar(
            message: 'Login successful',
            snackBarState: SnackBarState.success,
          );
          await Get.offAllNamed(Routes.HOME);
        } else {
          Get.focusScope?.unfocus();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    try {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        if (formKey.currentState?.value['signup_password'] ==
            formKey.currentState?.value['confirm_password']) {
          final bool isRegistered = await UserService.signUp(
            username: formKey.currentState?.value['signup_username'],
            password: formKey.currentState?.value['signup_password'],
            email: formKey.currentState?.value['signup_email'],
          );
          if (isRegistered) {
            appSnackbar(
              message: 'Registration successful',
              snackBarState: SnackBarState.success,
            );
            await Get.offAllNamed(Routes.HOME);
          }
        } else {
          appSnackbar(
            message: 'Password and confirm password do not match',
            snackBarState: SnackBarState.danger,
          );
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
