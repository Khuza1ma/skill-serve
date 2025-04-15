import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Size? buttonSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? borderWidth;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefixIcon;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final Widget? child;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    this.buttonSize,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.isDisabled = false,
    this.buttonText,
    this.buttonTextStyle,
    this.borderColor,
    this.borderWidth,
    this.prefixIcon,
    this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : () => onPressed?.call(),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDisabled ? Colors.grey : backgroundColor ?? Colors.blue,
        fixedSize: buttonSize ?? const Size(120, 40),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: BorderSide(
            color: isDisabled ? Colors.transparent : borderColor ?? Colors.blue,
            width: borderWidth ?? 1,
          ),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
          : child ??
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) prefixIcon ?? const SizedBox.shrink(),
                  if (prefixIcon != null) const SizedBox(width: 6),
                  Text(
                    buttonText ?? 'App Button',
                    style: buttonTextStyle ??
                        TextStyle(
                          color: isDisabled ? Colors.grey : Colors.white,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
    );
  }
}
