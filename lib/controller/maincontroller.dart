// ignore_for_file: unnecessary_overrides, unused_field, unrelated_type_equality_checks, unused_element, await_only_futures, collection_methods_unrelated_type, void_checks, avoid_print, dead_code

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> pro = [];

  //List<Companies> compamies = [];
  TextEditingController searchtxt = TextEditingController();

  bool isLoading = true;

  @override
  void onInit() {
    fetchCompanies();
    fetchProducts();

    super.onInit();
  }

  @override
  void dispose() {
    searchtxt.dispose();

    super.dispose();
  }

//====================================companies================
  void fetchCompanies() async {
    try {
      QuerySnapshot q =
          await FirebaseFirestore.instance.collection("companies").get();

      await Future.delayed(const Duration(seconds: 1));
      data.addAll(q.docs);

      isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  //============================products=================
  void fetchProducts() async {
    try {
      pro.clear();
      QuerySnapshot q =
          await FirebaseFirestore.instance.collection("products").get();
      pro.addAll(q.docs);
      isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  //===============================filter companies==========
  filterCompanies(name) async {
    try {
      if (name != null) {
        QuerySnapshot q =
            await FirebaseFirestore.instance.collection("companies").get();

        data.clear();
        update();
        data.addAll(q.docs
            .where((element) => element['companyname'].contains(name))
            .toList());
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //==========================filter products by company========================
  Future<void> filterProductsByCompany(datacomp) async {
    try {
      if (datacomp != null) {
        pro.clear();
        update();
        QuerySnapshot q =
            await FirebaseFirestore.instance.collection("products").get();

        pro.addAll(q.docs
            .where((element) => element["company"].contains(datacomp))
            .toList());

        update();
      } else {
        log("error");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //==============================refresh indicator============
  Future<void> refreshProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    pro.clear();
    update();
    QuerySnapshot q =
        await FirebaseFirestore.instance.collection("products").get();
    pro.addAll(q.docs);

    update();
  }

  //=======================Add likes==============================
  void addLikes(prolikes) async {
    //   QuerySnapshot q = await FirebaseFirestore.instance
    //       .collection("products")
    //       .where("likes")
    //       .get();
    //   if (q.docs.contains(await FirebaseAuth.instance.currentUser?.uid)) {
    //     await FirebaseFirestore.instance
    //         .collection("products")
    //         .doc(productid)
    //         .update({
    //       "likes":
    //           FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
    //     });
    //     update();
    //   } else {
    //     await FirebaseFirestore.instance
    //         .collection("products")
    //         .doc(productid)
    //         .update({
    //       "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
    //     });
    //     update();
    //   }
    // }

    if (prolikes['likes'].contains(FirebaseAuth.instance.currentUser?.uid)) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(prolikes["proid"])
          .update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
      });

      update();
    } else {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(prolikes["proid"])
          .update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });

      update();
    }
  }

  //==========================search text Of company=========

  searchCompany(txtsearch) async {
    if (txtsearch != null) {
      try {
        pro.clear();
        update();
        QuerySnapshot q =
            await FirebaseFirestore.instance.collection("products").get();

        pro.addAll(q.docs
            .where((element) => element["company"].contains(txtsearch))
            .toList());

        update();
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
