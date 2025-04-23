import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        // final User? user = await UserService.login(
        //   username: formKey.currentState?.value['username'],
        //   password: formKey.currentState?.value['password'],
        // );
        // if (user != null) {
        //   appSnackbar(
        //     message: 'Login successful',
        //     snackBarState: SnackBarState.SUCCESS,
        //   );
        //   await Get.offAllNamed(Routes.HOME);
        // } else {
        //   Get.focusScope?.unfocus();
        //   appSnackbar(
        //     message: 'Login failed', snackBarState: SnackBarState.DANGER,
        //   );
        // }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
