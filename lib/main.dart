import 'package:employee_master/config/app_colors.dart';
import 'package:employee_master/controller/home_controller.dart';
import 'package:employee_master/view/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(EmployeeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Employee App",
      theme: ThemeData(
        fontFamily: "Poppins",
        scaffoldBackgroundColor: AppColors.whiteColor,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
