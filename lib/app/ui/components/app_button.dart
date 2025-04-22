import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:skill_serve/app/constants/app_colors.dart';
import 'package:skill_serve/app/utils/num_ext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

///App Button
class AppButton extends StatelessWidget {
  ///Constructor
  const AppButton({
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.buttonColor,
    this.padding,
    this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w800,
    this.border,
    this.buttonSize,
    this.margin,
    super.key,
    this.leading,
    this.trailing,
    this.borderRadius,
  });

  ///Button on press
  final Callback onPressed;

  ///Button text
  final String buttonText;

  ///Button color
  final Color? buttonColor;

  ///Button text color
  final Color? textColor;

  ///Button padding
  final EdgeInsetsGeometry? padding;

  ///Button margin
  final EdgeInsetsGeometry? margin;

  ///Font size
  final double? fontSize;

  ///Font weight
  final FontWeight? fontWeight;

  ///Border side of button
  final BorderSide? border;

  ///Size of button
  final Size? buttonSize;

  /// Set [true] to show [CircularProgressIndicator], [false] to hide it
  final bool isLoading;

  ///If [hasLeadingWidget] is true then this should assign to any widget
  final Widget? leading;

  /// A widget after the label
  final Widget? trailing;

  /// Button Border radius
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin ?? const EdgeInsets.all(0),
        child: ElevatedButton(
          onPressed: isLoading ? () {} : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              side: border ?? BorderSide.none,
            ),
            backgroundColor: buttonColor ?? AppColors.k806dff,
            foregroundColor: textColor,
            minimumSize: buttonSize ?? const Size(double.infinity, 46),
            padding: padding,
          ),
          child: isLoading
              ? Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 3,
                  ),
                )
              : FittedBox(
                  child: Row(
                    children: <Widget>[
                      leading ?? const SizedBox.shrink(),
                      if (leading != null) 8.horizontalSpace,
                      Text(
                        buttonText,
                        style: GoogleFonts.ubuntu(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: AppColors.kFFFFFF,
                        ),
                      ),
                      if (trailing != null) 8.horizontalSpace,
                      trailing ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
        ),
      );
}
