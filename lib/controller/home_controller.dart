import 'dart:developer';
import 'dart:io';
import 'package:employee_master/widget/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeController extends GetxController {
  final CollectionReference employeeCollection = FirebaseFirestore.instance.collection('employee');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString selectedEmployeeId = "".obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  // File? image;
  Rx<File?> image = Rx<File?>(null);



  Future<void> addData(String imageLink) async {
    if (formKey.currentState!.validate()) {

      String documentId = DateTime.now().microsecondsSinceEpoch.toString();

      await employeeCollection.doc(documentId).set({
        "photo":imageLink,
        'name': nameController.text,
        'designation': designationController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'department': departmentController.text,
        'id': documentId,
      });
      Get.back();
      clearForm();
    }
  }
  Future<void> editData({String? userID,String downloadURL = "",bool showLoader = false})async {
    final data =  downloadURL.isEmpty ?
          {
      'name': nameController.text,
      'designation': designationController.text,
      'address': addressController.text,
      'phone': phoneController.text,
      'department': departmentController.text,
      'id': selectedEmployeeId.value,
    }
        : {
      "photo":downloadURL,
      'name': nameController.text,
      'designation': designationController.text,
      'address': addressController.text,
      'phone': phoneController.text,
      'department': departmentController.text,
      'id': selectedEmployeeId.value,
    };
    try {
      employeeCollection.doc(selectedEmployeeId.value).update(data);
      Get.back();
      clearForm();
    } catch (e) {
      if(showLoader == true)  hideLoadingDialog();
      log('---------------------111$e');
    }
  }

  Future<void> deleteDocument( String documentId) async {
    try {
   showLoadingDialog();
      DocumentReference documentReference = employeeCollection.doc(documentId);
      await documentReference.delete();
      print('Document deleted successfully');
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      print('Error deleting document: $e');
    }
  }

  void clearForm() {
    // if(formKey!= null) {
    //   formKey.currentState!.reset();
    // }
    nameController.clear();
    designationController.clear();
    addressController.clear();
    phoneController.clear();
    departmentController.clear();
    image.value = null;
    update();
  }


  Future<void> uploadImageToFirebase(image,isEdit) async {
    showLoadingDialog();

    final storage = FirebaseStorage.instance;

    final storageRef = storage.ref().child('images/${DateTime.now()}.png');

    await storageRef.putFile(File(image!.path));

    final String downloadURL = await storageRef.getDownloadURL();

    print("Image uploaded to: $downloadURL");
    if(downloadURL != null ){
      if(isEdit){
        editData(downloadURL: downloadURL,showLoader: true);
      }else{
        addData(downloadURL);
      }
    }else{
      print("Error");
    }

    hideLoadingDialog();
  }


  Future<void> updateImageInFirebase(String existingImageUrl) async {

    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return; // User canceled the image picking
    final existingStorageRef = storage.refFromURL(existingImageUrl);
    await existingStorageRef.delete();
    final newStorageRef = storage.ref().child('images/${DateTime.now()}.png');
    await newStorageRef.putFile(File(pickedFile.path));
    final String updatedDownloadURL = await newStorageRef.getDownloadURL();
    print("Image updated to: $updatedDownloadURL");
  }



  Map<String, dynamic> convertSnapshotToMap(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      // Handle the case where the document doesn't exist
      return {};
    }
  }
}