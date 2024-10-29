// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/homecontroller.dart';
import 'add_products.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController ctrl) => Scaffold(
        backgroundColor: HexColor('efeee5'),
        appBar: AppBar(
          backgroundColor: HexColor('efeee5'),
          title: const Text(
            "قائمة الاعلانات",
            style: TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
            icon: const Icon(Icons.logout),
            color: Colors.red,
          ),
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Get.to(() => EditProduct(
                            //     oldproname: snapshot.data?.docs[index]
                            //         ['productname'],
                            //     oldphone: snapshot.data?.docs[index]
                            //         ['phoncompany'],
                            //     oldDesc: snapshot.data?.docs[index]
                            //         ['productdesc'],
                            //     oldprice: snapshot.data?.docs[index]
                            //         ['productprice'],
                            //     oldadress: snapshot.data?.docs[index]
                            //         ['addresscompany'],
                            //     proid: snapshot.data?.docs[index]['proid']));
                          },
                          child: ListTile(
                            leading: Image.network(
                              "${snapshot.data?.docs[index]['proimg']}",
                              width: 40,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                                "${snapshot.data?.docs[index]['productname']}"),
                            subtitle: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${snapshot.data?.docs[index]['company']} - ",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "${snapshot.data?.docs[index]['date_creation']}",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ])),
                            // trailing: IconButton(
                            //     onPressed: () {
                            //       ctrl.deleteproduct(
                            //           snapshot.data?.docs[index]['proid'],
                            //           snapshot.data?.docs[index]['proimg']);
                            //     },
                            //     icon: const Icon(Icons.delete)),
                          ),
                        );
                      },
                    ),
                  );
                }),
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Get.to(() => const HomeScreen());
                    },
                    child: const Text("صفحة الاعلانات"))
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          onPressed: () {
            Get.to(() => const AddProduct());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
