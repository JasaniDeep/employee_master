import 'package:flutter/material.dart';
import 'package:employee_master/config/app_colors.dart';
import 'package:employee_master/config/text_style.dart';

commonButton({
  String? title,
  IconData? icon,
  Function()? onTap,
  bool isExpand = false,
  double? buttonWidth,
  double? borderWidth,
  double? borderRadius,
  double? textSize,
  Color? backColor,
  Color? textColor,
  TextStyle? textStyle,
  Color? borderColor,
  // double? borderRadius,
  double? height,
  double? frontImageHeight,
  bool isFront = false,
  bool isShadow = false,
  Widget? iconWidget,
  EdgeInsets? buttonPadding,
  EdgeInsetsGeometry? margin,
  String? frontImage,
  Color? frontImageColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin,
      width: buttonWidth,
      padding: buttonPadding ??
          const EdgeInsets.only(top: 14, bottom: 14, right: 16, left: 16),
      decoration: BoxDecoration(
          color: backColor ?? AppColors.primary,
          // borderRadius:BorderRadius.circular( borderRadius ?? 8),
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          boxShadow: <BoxShadow>[
            if (isShadow == true)
              BoxShadow(
                  color: AppColors.primary,
                  blurRadius: 15.0,
                  spreadRadius: -4,
                  offset: Offset(0.0, 6))
          ],
          border: (borderColor != null)
              ? Border.all(color: borderColor, width: borderWidth ?? 1)
              : null),
      child: Row(
        mainAxisSize: isExpand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && isFront)
            Image.asset(
              frontImage!,
              color: frontImageColor,
              height: frontImageHeight,
            ),
          if (icon != null && isFront)
            const SizedBox(
              width: 8,
            ),
          Flexible(
            child: Text(
              "$title",
              style: textStyle ??
                  AppTextStyle.regular600.copyWith(
                      fontSize: textSize ?? 18,
                      color: textColor ?? AppColors.whiteColor,
                      letterSpacing: 0.75),
            ),
          ),
          // if (icon != null && !isFront)
          //   const SizedBox(
          //     width: 8,
          //   ),
          // iconWidget ??
          //     (icon != null && !isFront
          //         ? Icon(
          //       icon,
          //       color: textColor ?? AppColors.whiteColor,
          //       size: 16,
          //     )
          //         : const SizedBox())
        ],
      ),
    ),
  );
}
