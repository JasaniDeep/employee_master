import 'package:employee_master/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingDialog() {
  Future.delayed(
    Duration.zero,
    () {
      Get.dialog(
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child:
                    const CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
          barrierDismissible: false);
    },
  );
}

void hideLoadingDialog({
  bool isTrue = false,
}) {
  Get.back(
    closeOverlays: isTrue,
  );
}
