import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/reviews_controller.dart';
import 'components.dart';

class UsersReveiewScreen extends StatelessWidget {
  final String proid;
  const UsersReveiewScreen({super.key, required this.proid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('efeee5'),
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Reviews"),
        ),
        backgroundColor: HexColor('efeee5'),
        body: GetBuilder<Reviewcontroller>(
            builder: (Reviewcontroller ctrl) => Container(
                  margin: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Add Review",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10.0,
                        ),
                        RatingBar.builder(
                          initialRating: 3.0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            ctrl.productrating = rating;
                            log(ctrl.productrating.toString());
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Form(
                            key: ctrl.formkey,
                            child: CustomForm(
                                validator: (p0) =>
                                    p0!.isEmpty ? "يجب كتابة التعليق" : "",
                                maxlentgh: 50,
                                text: "التعليق",
                                type: TextInputType.text,
                                name: ctrl.reviewfeedback),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () {
                              ctrl.addreview(proid);
                              // if (ctrl.formkey.currentState!.validate()) {
                              //   EasyLoading.show(status: "please wait...");
                              //   ctrl.addreview(proid);
                              // }
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        // //==============================List of reviews===============================
                        SizedBox(
                          height: Get.height / 1.8,
                          child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("products")
                                  .doc(proid)
                                  .collection("reviews")
                                  .get(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (ConnectionState.waiting ==
                                    snapshot.connectionState) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    "لا يوجد تعليقات",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ));
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    // physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        snapshot.data!.docs.take(15).length,
                                    itemBuilder: (context, index) => Card(
                                          elevation: 5.0,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: 25.0,
                                                child: Text(snapshot
                                                        .data!
                                                        .docs[index]['username']
                                                            [0]
                                                        .toString()
                                                        .toUpperCase()
                                                        .isNotEmpty
                                                    ? snapshot
                                                        .data!
                                                        .docs[index]['username']
                                                            [0]
                                                        .toString()
                                                        .toUpperCase()
                                                    : 'No Name')),
                                            title: Text(snapshot.data!
                                                    .docs[index]['username']
                                                    .toString()
                                                    .isNotEmpty
                                                ? "${snapshot.data!.docs[index]['username']}"
                                                : 'No Name'),
                                            subtitle: Text(snapshot.data!
                                                    .docs[index]['feedback']
                                                    .toString()
                                                    .isNotEmpty
                                                ? "${snapshot.data!.docs[index]['feedback']}"
                                                : 'No feedback'),
                                            trailing: Text(
                                              snapshot
                                                  .data!.docs[index]['rating']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ));
                              }),
                        )
                      ],
                    ),
                  ),
                )));
  }
}
