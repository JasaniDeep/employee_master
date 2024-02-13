import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_master/config/app_colors.dart';
import 'package:employee_master/config/text_style.dart';
import 'package:employee_master/controller/home_controller.dart';
import 'package:employee_master/view/add_edit_screen/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employee');
  final employeeController = Get.find<EmployeeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        title: const Text("Employee Master"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: employeeCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text("No Data Available"),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  itemBuilder: (context, index) {
                    var employee = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        employeeController.convertSnapshotToMap(employee);
                    employeeController.selectedEmployeeId.value = data["id"];
                    log("0=-00=-0=-0=-0=0=-0=-=00=- ${data}");
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 10)
                          ]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  imageUrl: "${data["photo"]}",
                                  placeholder: (context, url) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => AddEditScreen(
                                        isEdit: true,
                                        selectedEmployeeData: data));
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue)),
                              IconButton(
                                  onPressed: () {
                                    employeeController
                                        .deleteDocument(data["id"]);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonTextShowData(
                                    title: "Name", subTitle: employee['name']),
                                commonTextShowData(
                                    title: "Designation",
                                    subTitle: employee['designation']),
                                commonTextShowData(
                                    title: "Address",
                                    subTitle: employee['address']),
                                commonTextShowData(
                                    title: "Phone",
                                    subTitle: employee['phone']),
                                commonTextShowData(
                                    title: "Department",
                                    subTitle: employee['department']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) /*ListTile(
                      leading: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        imageUrl: "${data["photo"]}",
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      title: Text(employee['name']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.to(() => AddEditScreen(
                                      isEdit: true,
                                      selectedEmployeeData: data));
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue)),
                            IconButton(
                                onPressed: () {
                                  employeeController.deleteDocument(data["id"]);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    )*/
                        ;
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  commonTextShowData({String? title, String? subTitle}) {
    return Row(
      children: [
        Text(
          "${title!} : ",
          style: AppTextStyle.regular600.copyWith(fontSize: 18),
        ),
        Text(
          "${subTitle!}",
          style: AppTextStyle.regular500.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
