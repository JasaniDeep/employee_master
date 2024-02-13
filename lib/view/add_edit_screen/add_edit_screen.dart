import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_master/config/app_colors.dart';
import 'package:employee_master/config/text_style.dart';
import 'package:employee_master/controller/home_controller.dart';
import 'package:employee_master/widget/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEditScreen extends StatefulWidget {
  bool isEdit;
  Map<String, dynamic> selectedEmployeeData;
  AddEditScreen(
      {super.key, this.isEdit = false, this.selectedEmployeeData = const {}});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final employeeController = Get.put(EmployeeController());
  bool firstTimeImage = false;
  @override
  void initState() {
    super.initState();
    getEditFormData();
  }

  getEditFormData() {
    if (widget.isEdit == true) {
      employeeController.nameController.text =
          widget.selectedEmployeeData["name"];
      employeeController.designationController.text =
          widget.selectedEmployeeData["designation"];
      employeeController.addressController.text =
          widget.selectedEmployeeData["address"];
      employeeController.phoneController.text =
          widget.selectedEmployeeData["phone"];
      employeeController.departmentController.text =
          widget.selectedEmployeeData["department"];
      setState(() {});
    } else {
      employeeController.clearForm();
      image = null;
    }
    setState(() {});
  }

  File? image;

  Future<void> pickImageFile() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        title: const Text("Employee Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: employeeController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image != null
                    ? Image.file(
                        image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : widget.isEdit == true &&
                            widget.selectedEmployeeData["photo"] != null &&
                            widget.selectedEmployeeData["photo"]
                                .toString()
                                .isNotEmpty
                        ? CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl: "${widget.selectedEmployeeData["photo"]}",
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            color: AppColors.greyDarkColor,
                            child: const Center(
                              child: Icon(Icons.image),
                            ),
                          ),
                const SizedBox(height: 10),
                // CachedNetworkImage(imageUrl: ),
                ElevatedButton(
                  onPressed: () => pickImageFile(),
                  child: const Text('Pick Image'),
                ),
                TextFormField(
                  controller: employeeController.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: employeeController.designationController,
                  decoration: const InputDecoration(labelText: 'Designation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a designation';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: employeeController.addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: employeeController.phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: employeeController.departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (widget.isEdit == false && image == null) {
                      print("Select Image");
                      showSnackbar(message: 'Select Image');
                    } else if (employeeController.nameController.text.isEmpty) {
                      showSnackbar(message: 'Select Name');
                    } else if (employeeController
                        .designationController.text.isEmpty) {
                      showSnackbar(message: 'Select Designation');
                    } else if (employeeController
                        .addressController.text.isEmpty) {
                      showSnackbar(message: 'Select Address');
                    } else if (employeeController
                        .phoneController.text.isEmpty) {
                      showSnackbar(message: 'Select Phone');
                    } else if (employeeController
                        .departmentController.text.isEmpty) {
                      showSnackbar(message: 'Select Department');
                    } else {
                      widget.isEdit == true && image == null
                          ? employeeController.editData(
                              downloadURL: "", showLoader: false)
                          : widget.isEdit == true && image != null
                              ? employeeController.uploadImageToFirebase(
                                  image,
                                  true,
                                )
                              : employeeController.uploadImageToFirebase(
                                  image, false);
                    }
                  },
                  child: Text(
                      widget.isEdit == true ? 'Edit Employee' : 'Add Employee'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
