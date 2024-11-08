// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController productname = TextEditingController();
  TextEditingController productdesc = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController productprice = TextEditingController();
  TextEditingController addresscompany = TextEditingController();
  TextEditingController phoncompany = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? selectedValue;
  File? imageSelected;
  @override
  // ignore: unnecessary_overrides
  void onInit() {
    getproducts();
    super.onInit();
  }

  @override
  void dispose() {
    productname.dispose();
    productdesc.dispose();
    companyname.dispose();
    productprice.dispose();
    addresscompany.dispose();
    phoncompany.dispose();

    super.dispose();
  }

//=============================== Add products=======================
  void addproduct() async {
    //=========================convert currency to egypt==========
    final number = double.parse(productprice.text);
    final curency = NumberFormat.currency(locale: 'ar_EG', symbol: 'ج.م.');
    final formattedCurrency = curency.format(number);
//==================================================================================
    final uuid = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref().child("proimg").child(uuid);
    await ref.putFile(imageSelected!);
    final imageurl = await ref.getDownloadURL();
    try {
      if (selectedValue == null) {
        Get.snackbar("Error", "ادخل اسم الشركة",
            backgroundColor: Colors.deepPurple, colorText: Colors.white);
        return;
      } else {
        await FirebaseFirestore.instance.collection("products").doc(uuid).set({
          "proid": uuid,
          "productname": productname.text,
          "addresscompany": addresscompany.text,
          "phoncompany": phoncompany.text,
          "productdesc": productdesc.text,
          "proimg": imageurl,
          "productprice": formattedCurrency,
          "company": selectedValue,
          "date_creation": formatter.format(now),
          "likes": []
        });

        Get.snackbar("Success", "تم الحفظ بنجاح",
            backgroundColor: Colors.deepPurple, colorText: Colors.white);
        clearcontent();
        update();
      }
    } on FirebaseException catch (e) {
      Get.snackbar("faild", e.toString(), colorText: Colors.red);
    }
  }

//==========================================picked image=============================================
  void pickedImage() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc', 'png']);

    final result = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result == null) {
      print("No file selected");
    } else {
      imageSelected = File(result.path);
      update();
    }
  }

//==========================================================================================
  void clearcontent() {
    productname.clear();
    productdesc.clear();
    productprice.clear();
    addresscompany.clear();
    phoncompany.clear();
    imageSelected = null;
    selectedValue;
  }

  //============اضافة الشركات==================
  void addCompanies() async {
    final uuid = const Uuid().v4();
    try {
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(uuid)
          .set({"compid": uuid, "companyname": companyname.text});

      // Get.snackbar("Success", "تم الحفظ بنجاح",
      //     backgroundColor: Colors.deepPurple, colorText: Colors.white);

      update();
    } on FirebaseException catch (e) {
      Get.snackbar("faild", e.toString(), colorText: Colors.red);
    }
  }

//=================fetch products========================
  void getproducts() async {
    try {
      QuerySnapshot q =
          await FirebaseFirestore.instance.collection("products").get();

      await Future.delayed(const Duration(seconds: 1));
      data.addAll(q.docs);
      update();
      isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  //=========deletproducts======
  void deleteproduct(id, url) async {
    try {
      await FirebaseFirestore.instance.collection("products").doc(id).delete();
      await FirebaseStorage.instance.refFromURL(url).delete();
      update();
    } on FirebaseException catch (e) {
      print(e.toString());
      Get.snackbar("faild", e.toString(), colorText: Colors.red);
    }
  }
}
