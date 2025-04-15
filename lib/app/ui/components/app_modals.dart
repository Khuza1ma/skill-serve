import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import 'app_button.dart';

void showCustomModal({
  required String title,
  String? content,
  required Function onSubmit,
  Function? onCancel,
  Widget? child,
  String? buttonTitle,
  ModalState modalState = ModalState.PRIMARY,
  AlignmentGeometry? alignment,
  final bool showButtons = true,
}) {
  Get.dialog(
    AlertDialog(
      alignment: alignment ?? Alignment.topCenter,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.k000000,
              fontSize: 20,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          child ??
              Text(
                content ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.k000000,
                ),
              ),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
        ],
      ),
      actions: showButtons
          ? [
              AppButton(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel.call();
                  } else {
                    Get.back();
                  }
                },
                buttonText: 'Close',
                buttonTextStyle: TextStyle(
                  color: AppColors.kFFFFFF,
                  fontSize: 14,
                ),
                buttonSize: const Size(80, 40),
                backgroundColor: AppColors.k5C636A,
                borderColor: AppColors.k5C636A,
                borderRadius: 5,
              ),
              AppButton(
                onPressed: () {
                  //Get.back();
                  onSubmit.call();
                },
                buttonText: buttonTitle ?? 'Submit',
                buttonTextStyle: TextStyle(
                  color: AppColors.kFFFFFF,
                  fontSize: 14,
                ),
                buttonSize: const Size(140, 40),
                backgroundColor: getModalStateColor(modalState),
                borderColor: getModalStateColor(modalState),
                borderRadius: 5,
              ),
            ]
          : [],
    ),
  );
}

enum ModalState { PRIMARY, SECONDARY, SUCCESS, DANGER, WARNING, INFO }

Color getModalStateColor(ModalState? snackBarState) {
  switch (snackBarState) {
    case ModalState.PRIMARY:
      return AppColors.k3B7DDD;
    case ModalState.SECONDARY:
      return AppColors.k6C757D;
    case ModalState.SUCCESS:
      return AppColors.k1CBB8C;
    case ModalState.DANGER:
      return AppColors.kDC3545;
    case ModalState.WARNING:
      return AppColors.kFCB92C;
    case ModalState.INFO:
      return AppColors.k17A2B8;
    default:
      return Colors.white;
  }
}
