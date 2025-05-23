import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_serve/app/utils/num_ext.dart';

import '../../constants/app_colors.dart';

/// AppTextField
class AppTextField extends StatelessWidget {
  /// AppTextField
  const AppTextField({
    required this.name,
    this.focusNode,
    this.cursorColor,
    this.contentPadding,
    this.readOnly = false,
    this.isRequired = false,
    this.obscureText = false,
    this.maxLength,
    this.controller,
    this.hintText,
    this.label,
    this.initialValue,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.keyboardType,
    this.suffix,
    this.validator,
    this.onChanged,
    this.errorMessage,
    this.suffixText,
    this.prefix,
    this.inputFormatters,
    this.autoFillHints,
    this.textAlign,
    this.onTap,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization,
    this.prefixText,
    this.fillColor,
    this.border,
    this.constraints,
    this.errorText,
    super.key,
  });

  /// controller
  final TextEditingController? controller;

  /// hintText
  final String? hintText;

  /// label
  final String? label;

  /// initialValue
  final String? initialValue;

  /// hintStyle
  final TextStyle? hintStyle;

  /// labelStyle
  final TextStyle? labelStyle;

  /// textStyle
  final TextStyle? textStyle;

  /// keyboardType
  final TextInputType? keyboardType;

  /// suffix
  final Widget? suffix;

  /// obscureText
  final bool obscureText;

  /// validator
  final String? Function(String? value)? validator;

  /// onChanged
  final void Function(String? value)? onChanged;

  /// name
  final String name;

  /// readOnly
  final bool readOnly;

  /// isRequired
  final bool isRequired;

  /// maxLength
  final int? maxLength;

  /// errorMessage
  final String? errorMessage;

  /// suffixText
  final String? suffixText;

  /// prefix
  final Widget? prefix;

  /// prefixText
  final String? prefixText;

  /// inputFormatters
  final List<TextInputFormatter>? inputFormatters;

  /// autoFillHints
  final List<String>? autoFillHints;

  /// contentPadding
  final EdgeInsets? contentPadding;

  /// textAlign
  final TextAlign? textAlign;

  /// onTap
  final Function(String)? onTap;

  /// maxLines
  final int? maxLines;

  /// textInputAction
  final TextInputAction? textInputAction;

  /// textCapitalization
  final TextCapitalization? textCapitalization;

  /// fillColor
  final Color? fillColor;

  /// focusNode
  final FocusNode? focusNode;

  /// cursorColor
  final Color? cursorColor;

  /// constraints
  final InputBorder? border;

  /// errorText
  final BoxConstraints? constraints;

  /// errorText
  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (label != null) ...<Widget>[
            RichText(
              text: TextSpan(
                text: label,
                style: labelStyle ??
                    GoogleFonts.poppins(
                      color: AppColors.kFFFFFF,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                children: <InlineSpan>[
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.poppins(
                        color: AppColors.kFF0000,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ),
            5.verticalSpace
          ],
          _buildTextField(),
        ],
      );

  TextSelectionTheme _buildTextField() {
    final Color cursorColor = this.cursorColor ?? AppColors.k806dff;
    final Color selectionColor = this.cursorColor?.withValues(alpha: 0.3) ??
        AppColors.k806dff.withValues(alpha: 0.3);

    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionHandleColor: cursorColor,
        selectionColor: selectionColor,
        cursorColor: cursorColor,
      ),
      child: FormBuilderTextField(
        name: name,
        focusNode: focusNode,
        style: textStyle ?? GoogleFonts.poppins(color: AppColors.k000000),
        initialValue: initialValue?.toString(),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: () {
          onTap?.call('');
        },
        cursorColor: cursorColor,
        decoration: _buildInputDecoration(),
        textAlign: textAlign ?? TextAlign.start,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        autofillHints: autoFillHints,
        maxLines: maxLines,
        textInputAction: textInputAction,
      ),
    );
  }

  InputDecoration _buildInputDecoration() => InputDecoration(
        isDense: true,
        constraints: constraints,
        fillColor: fillColor ?? AppColors.kFFFFFF,
        filled: true,
        contentPadding: contentPadding ?? const EdgeInsets.all(12),
        prefixIcon: prefix,
        prefixText: prefixText,
        suffixIcon: suffix,
        suffixText: suffixText,
        suffixStyle: textStyle,
        hintText: hintText,
        errorText: errorText,
        hintStyle: hintStyle ??
            GoogleFonts.poppins(
              color: AppColors.ka1a5b7,
              fontSize: 16,
            ),
        errorMaxLines: 5,
        errorStyle: GoogleFonts.poppins(
          color: AppColors.kFF0000,
          fontSize: 11,
        ),
        border: border ?? _buildOutlineInputBorder(),
        disabledBorder: border ?? _buildOutlineInputBorder(),
        enabledBorder: border ?? _buildOutlineInputBorder(),
        errorBorder: border ?? _buildOutlineInputBorder(),
        focusedErrorBorder: border ?? _buildOutlineInputBorder(),
        focusedBorder: border ?? _buildOutlineInputBorder(),
      );

  OutlineInputBorder _buildOutlineInputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      );
}
