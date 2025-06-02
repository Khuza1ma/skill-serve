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
  ModalState modalState = ModalState.primary,
  AlignmentGeometry? alignment,
  final bool showButtons = true,
}) {
  Get.dialog(
    AlertDialog(
      alignment: alignment ?? Alignment.topCenter,
      backgroundColor: AppColors.k262837,
      surfaceTintColor: AppColors.k262837,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.kFFFFFF,
              fontSize: 20,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              size: 20,
              color: AppColors.kc6c6c8.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Divider(
            thickness: 1,
          ),
          const SizedBox(height: 10),
          child ??
              Text(
                content ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.kFFFFFF,
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
                buttonSize: const Size(80, 40),
                buttonColor: AppColors.k262837,
                border: BorderSide(color: getModalStateColor(modalState)),
                borderRadius: BorderRadius.circular(5),
              ),
              AppButton(
                onPressed: () {
                  //Get.back();
                  onSubmit.call();
                },
                buttonText: buttonTitle ?? 'Submit',
                buttonSize: const Size(140, 40),
                buttonColor: getModalStateColor(modalState),
                border: BorderSide(
                  color: getModalStateColor(modalState),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ]
          : [],
    ),
  );
}

enum ModalState { primary, secondary, success, danger, warning, info }

Color getModalStateColor(ModalState? snackBarState) {
  switch (snackBarState) {
    case ModalState.primary:
      return AppColors.k806dff;
    case ModalState.secondary:
      return AppColors.k6C757D;
    case ModalState.success:
      return AppColors.k1CBB8C;
    case ModalState.danger:
      return AppColors.kDC3545;
    case ModalState.warning:
      return AppColors.kFCB92C;
    case ModalState.info:
      return AppColors.k17A2B8;
    default:
      return Colors.white;
  }
}
