import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';

void appSnackbar({
  required String message,
  required SnackBarState snackBarState,
  String? title,
  double? maxWidth,
  SnackPosition? snackBarPosition,
  EdgeInsets? margin,
  double? borderRadius,
  Color? backgroundColor,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
        snackPosition: snackBarPosition ?? SnackPosition.TOP,
        backgroundColor: getSnackBarColor(snackBarState),
        titleText: title == null ? null : Text(title),
        maxWidth: maxWidth,
        margin: margin ?? EdgeInsets.zero,
        borderRadius: borderRadius ?? 0,
        mainButton: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
          color: Colors.white,
        ),
      ),
    );
  });
}

enum SnackBarState { PRIMARY, SECONDARY, SUCCESS, DANGER, WARNING, INFO }

Color getSnackBarColor(SnackBarState? snackBarState) {
  switch (snackBarState) {
    case SnackBarState.PRIMARY:
      return AppColors.k3B7DDD;
    case SnackBarState.SECONDARY:
      return AppColors.k6C757D;
    case SnackBarState.SUCCESS:
      return AppColors.k1CBB8C;
    case SnackBarState.DANGER:
      return AppColors.kDC3545;
    case SnackBarState.WARNING:
      return AppColors.kFCB92C;
    case SnackBarState.INFO:
      return AppColors.k17A2B8;
    default:
      return Colors.white;
  }
}
