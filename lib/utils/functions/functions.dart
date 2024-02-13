import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {

  static void setAvailability({
    String? name,
    String? photo,
    String? designation,
    String? address,
    String? phone,
    String? department,
  }) {
    log("""
  name  :: $name
  photo  :: $photo
  designation  :: $designation
  address  :: $address
  phone  :: $phone
  department  :: $department
    """);
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    log("data save to firebase function called");
    final firestore = FirebaseFirestore.instance;
    final data = {
      "name": num,
      "photo": photo,
      "designation": designation,
      "address": address,
      "phone": phone,
      "department": department,
      "created_at": id
    };
    try {
      firestore.collection('employee').doc(id).set(data);
    } catch (e) {
      log('setAvailability ERROR :---------------------: $e');
    }
  }

  static void updateAvailability(
      {
        String? name,
        String? photo,
        String? designation,
        String? address,
        String? phone,
        String? department,
        String? id
      }) {
    log("data save to firebase function called");
    final firestore = FirebaseFirestore.instance;
    final data = {
      "name": num,
      "photo": photo,
      "designation": designation,
      "address": address,
      "phone": phone,
      "department": department,
    };
    try {
      firestore.collection('Users').doc(id).update(data);
    } catch (e) {
      log('updateAvailability---------------------111$e');
    }
  }
}
