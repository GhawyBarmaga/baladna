// ignore_for_file: void_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Reviewcontroller extends GetxController {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController reviewfeedback = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser?.uid;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String username = "";
  double productrating = 3.0;
  @override
  void onInit() {
    currentuser;
    getusername();

    super.onInit();
  }

  @override
  void dispose() {
    reviewfeedback.dispose();
    super.dispose();
  }

  Future<String> getusername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Stream<QuerySnapshot> userDoc = FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: currentuser)
          .snapshots();

      userDoc.forEach((e) {
        return username = e.docs[0]['name'];
      });
    }
    update();
    return "no one";
  }

  //=====================Add Review==========================

  addreview(proid) async {
    try {
      if (reviewfeedback.text.isEmpty) {
        Get.snackbar("تحذير", "الرجاء اضافة تعليق", colorText: Colors.red);
        EasyLoading.dismiss();
        return;
      }
      await FirebaseFirestore.instance
          .collection("products")
          .doc(proid)
          .collection("reviews")
          .add({
        "feedback": reviewfeedback.text.trim(),
        "rating": productrating.toString(),
        "username": username,
        "createdat": formatter.format(now),
      });
      EasyLoading.dismiss();
      reviewfeedback.clear();
      productrating = 3.0;
      update();
    } catch (e) {
      Get.snackbar("faild", e.toString(),
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }

//=================================validate rating=============================
  // void validaterating() {
  //   if (reviewfeedback.text.isEmpty) {
  //     Get.snackbar("تحذير", "الرجاء اضافة تعليق", colorText: Colors.red);
  //     EasyLoading.dismiss();

  //   }
  //   update();
  //   if (productrating == 0.0) {
  //     Get.snackbar("تحذير", "الرجاء اختيار التقييم", colorText: Colors.red);
  //     EasyLoading.dismiss();
  //     update();
  //     return;
  //   }
  // }
}
