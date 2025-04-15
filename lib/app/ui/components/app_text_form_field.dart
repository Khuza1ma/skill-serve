import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../constants/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? border;
  final double? borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final BoxConstraints? constraints;
  final bool? isFilled;
  final bool? obscureText;
  final bool showBorder;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? validator;
  final String? initialValue;
  final String name;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final int maxLines;

  const AppTextFormField({
    super.key,
    this.controller,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.focusedErrorBorder,
    this.border,
    this.borderRadius,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.style,
    this.hintTextStyle,
    this.labelTextStyle,
    this.constraints,
    this.isFilled,
    this.obscureText,
    this.fillColor,
    this.showBorder = false,
    this.textInputAction,
    this.keyboardType,
    this.contentPadding,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.validator,
    this.initialValue,
    this.inputFormatters,
    this.onSubmit,
    this.onChange,
    this.maxLines = 1,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: (value) => validator?.call(value),
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType ?? TextInputType.text,
      onSubmitted: onSubmit,
      onChanged: onChange,
      style: style ??
          TextStyle(
            color: AppColors.k3B7DDD,
            fontSize: 16,
          ),
      textInputAction: textInputAction ?? TextInputAction.next,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        contentPadding: contentPadding ?? EdgeInsets.zero,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        label: Text(labelText ?? ''),
        labelStyle: labelTextStyle ??
            TextStyle(
              color: AppColors.k7C7E80,
              fontSize: 16,
            ),
        constraints: constraints ??
            const BoxConstraints(
              minWidth: 10,
              maxHeight: 35,
            ),
        hintText: hintText ?? '',
        hintStyle: hintTextStyle ??
            TextStyle(
              color: AppColors.k7C7E80,
              fontSize: 16,
            ),
        prefixIconConstraints:
            prefixIconConstraints ?? const BoxConstraints(minWidth: 10),
        suffixIconConstraints:
            suffixIconConstraints ?? const BoxConstraints(minWidth: 10),
        prefixIcon: prefixIcon ?? const SizedBox.shrink(),
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
        filled: isFilled ?? false,
        fillColor: fillColor ?? AppColors.kF3F6FA,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
        disabledBorder: disabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
        focusedErrorBorder: focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: showBorder
                  ? BorderSide(
                      color: AppColors.kFFFFFF,
                    )
                  : BorderSide.none,
            ),
      ),
    );
  }
}
