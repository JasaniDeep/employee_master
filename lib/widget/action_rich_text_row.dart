import 'package:flutter/material.dart';
import 'package:employee_master/config/app_colors.dart';
import 'package:employee_master/config/text_style.dart';

commonRichText(
    {String? text,
    String? actionText,
    Function()? onTap,
    TextStyle? actionTextStyle,
    TextStyle? textStyle,
    MainAxisAlignment? alignment,
    MainAxisAlignment? mainAxisAlignment,
    double? fontSize,
    TextAlign? textAlign,
    Color? textSpanColor,
    int? maxLines,
    Color? textColor}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
    children: [
      InkWell(
        onTap: onTap,
        child: RichText(
          maxLines: maxLines,
          textAlign: textAlign ?? TextAlign.center,
          text: TextSpan(
            text: '$text',
            style: textStyle ??
                AppTextStyle.regular600.copyWith(
                    color: textColor ?? AppColors.blackColor,
                    fontSize: fontSize ?? 14,
                    fontFamily: "Poppins"),
            children: [
              TextSpan(
                text: '$actionText',
                style: actionTextStyle ??
                    AppTextStyle.regular600.copyWith(
                        overflow: TextOverflow.clip,
                        color: textSpanColor ?? AppColors.primary,
                        fontSize: fontSize ?? 14,
                        fontFamily: "Poppins"),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
