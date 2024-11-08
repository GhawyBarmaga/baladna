// ignore_for_file: unrelated_type_equality_checks, unnecessary_overrides

import 'dart:developer';

import 'package:baladna_go/views/screens/home_%20admin.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    log(FirebaseAuth.instance.currentUser.toString());
  }

  @override
  void dispose() {
    useradmin.dispose();
    passwordAdmin.dispose();

    super.dispose();
  }

  TextEditingController useradmin = TextEditingController();
  TextEditingController passwordAdmin = TextEditingController();

  // final keyform = GlobalKey<FormState>();
  bool isloading = false;

  //================================Login admin===================
  void loginadmin() async {
    try {
      if (useradmin.text == "admin" && passwordAdmin.text == "admin123") {
        Get.to(() => const HomeAdmin());
        useradmin.clear();
        passwordAdmin.clear();
      } else {
        Get.snackbar("😉", " هذه الصفحه خاصة بأدمن التطبيق   ",
            colorText: Colors.red);
      }
      //     QuerySnapshot q = await FirebaseFirestore.instance
      //         .collection("adminusers")
      //         .where("name", isEqualTo: useradmin.text)
      //         .where("password", isEqualTo: passwordAdmin.text)
      //         .get();
      //     if (q.docs.isNotEmpty) {
      //       Get.to(() => const HomeAdmin());
      //       useradmin.clear();
      //       passwordAdmin.clear();
      //       update();
      //     } else {
      //       Get.snackbar("😉", "اطلع بره لو سمحت ", colorText: Colors.red);
      //     }
      //   } on FirebaseAuthException catch (e) {
      //     Get.snackbar("faild", e.toString(), colorText: Colors.red);
    } catch (e) {
      log(e.toString());
    }
    // }
  }
}
