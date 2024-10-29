import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/homecontroller.dart';

class FirebaseDropdownMenuItem extends StatefulWidget {
  const FirebaseDropdownMenuItem({super.key});

  @override
  State<FirebaseDropdownMenuItem> createState() =>
      _FirebaseDropdownMenuItemState();
}

class _FirebaseDropdownMenuItemState extends State<FirebaseDropdownMenuItem> {
  @override
  Widget build(BuildContext context) {
    HomeController ctrl = Get.put(HomeController());
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("companies").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Some error occured ${snapshot.error}"),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Some error occured ${snapshot.error}"),
            );
          } else {
            List<DropdownMenuItem> companiesname = [];
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final selectcompany = snapshot.data?.docs.reversed.toList();
            if (selectcompany != null) {
              for (var company in selectcompany) {
                companiesname.add(
                  DropdownMenuItem(
                    value: company['companyname'],
                    child: Text(
                      company['companyname'],
                    ),
                  ),
                );
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  hint: const Text(
                    "اختر اسم الشركه",
                    style: TextStyle(fontSize: 18),
                  ),
                  items: companiesname,
                  value: ctrl.selectedValue,
                  onChanged: (value) {
                    setState(() {
                      ctrl.selectedValue = value;
                      log(value);
                    });
                  },
                ),
              ),
            );
          }
        });
  }
}