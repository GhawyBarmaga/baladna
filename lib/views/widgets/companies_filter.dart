import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/maincontroller.dart';

class CompaniesFilter extends StatelessWidget {
  const CompaniesFilter({
    super.key,
    required this.doc,
  });

  final DocumentSnapshot<Object?> doc;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        builder: (MainController controller) => GestureDetector(
              onTap: () {
                controller.filterProductsByCompany(doc["companyname"]);
              },
              child: Container(
                margin: EdgeInsets.only(top: Get.height * 0.01),
                padding: EdgeInsets.only(top: Get.height * 0.01),
                width: Get.width * .4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      HexColor("2B5876"),
                      HexColor("4E4376"),
                    ]),
                    borderRadius: BorderRadius.circular(13.0)),
                child: Text(
                  textAlign: TextAlign.center,
                  doc["companyname"],
                  style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ));
  }
}
