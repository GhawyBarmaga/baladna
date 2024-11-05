// ignore_for_file: unused_local_variable, must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/maincontroller.dart';

import 'like_button.dart';
import 'review_user_screen.dart';

class CardProducts extends StatefulWidget {
  final int index;
  List<dynamic> likes;
  final String proid;
  CardProducts(
      {super.key,
      required this.index,
      required this.likes,
      required this.proid});

  @override
  State<CardProducts> createState() => _CardProductsState();
}

class _CardProductsState extends State<CardProducts>
    with AutomaticKeepAliveClientMixin {
  bool isliked = true;
  int countlike = 0;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    isliked = widget.likes.contains(FirebaseAuth.instance.currentUser?.uid);
    countlike = widget.likes.length;
    super.initState();
  }

//===================================likes void==========================
  void togglelike() {
    setState(() {
      isliked = !isliked;
    });
    DocumentReference reflikes =
        FirebaseFirestore.instance.collection("products").doc(widget.proid);

    if (isliked) {
      countlike++;
      reflikes.update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });

      FirebaseFirestore.instance.collection("products").doc(widget.proid).get();
    } else {
      countlike--;
      reflikes.update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
      });
    }
  }

//===============================================================================================
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //======================== canera zoom===============================
    void handleDoubleTap() {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails!.localPosition;
        // For a 3x zoom
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
        // For a 2x zoom
        // ..translate(-position.dx, -position.dy)
        // ..scale(2.0);
      }
    }

    return SafeArea(
        child: GetBuilder<MainController>(
      builder: (MainController ctrl) => Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Card(
                child: Container(
                  width: Get.width,
                  height: Get.height * 0.5,
                  decoration: BoxDecoration(
                      color: HexColor('F5F5F5'),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3))
                      ]),
                  child: Column(
                    children: [
                      //=============================================camera zoom=========
                      const SizedBox(height: 15.0),
                      GestureDetector(
                        onDoubleTapDown: (details) =>
                            _doubleTapDetails = details,
                        onDoubleTap: handleDoubleTap,
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          boundaryMargin: const EdgeInsets.all(
                              80.0), // Margin around the content
                          minScale: 1.0,
                          maxScale: 2.2,

                          child: Image.network(
                            ctrl.pro[widget.index]["proimg"] ??
                                Image.asset("assets/animations/noimage.jpg"),
                            width: 200.0, // Width of the initial image
                            height: 100.0, // Height of the initial image
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                      ///==============================================================
                      Text(
                        ctrl.pro[widget.index]["company"] ?? "=======",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ctrl.pro[widget.index]["productname"] ?? "=======",
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        ctrl.pro[widget.index]["productprice"] ?? "==========",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ctrl.pro[widget.index]["productdesc"] ??
                            "=================="),
                      ),
                      Text(ctrl.pro[widget.index]["addresscompany"]),
                      Text(
                        ctrl.pro[widget.index]["phoncompany"] ??
                            "=================",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      Expanded(
                          child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Like_Button(
                              ontab: togglelike,
                              isliked: isliked,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("products")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return Text("$countlike  اعجبنى");
                              }),
                          //==================Add Reveiw====================
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                onPressed: () {
                                  Get.to(() =>
                                      UsersReveiewScreen(proid: widget.proid));
                                  log(widget.proid);
                                },
                                child: const Text(
                                  "Add Review",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          //===================================================
                          // const Text("اتصال"),
                          // IconButton(
                          //   onPressed: () {
                          //     FlutterPhoneDirectCaller.callNumber(
                          //         ctrl.pro[widget.index]["phoncompany"]);
                          //   },
                          //   icon: const Icon(
                          //     Icons.phone,
                          //     color: Colors.blue,
                          //   ),
                          // ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
