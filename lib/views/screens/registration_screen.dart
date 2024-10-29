// ignore_for_file: unused_element

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/components.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool issecure = true;
  bool isloading = false;
  TextEditingController emailaddress = TextEditingController();

  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    emailaddress.text = "";
    password.text = "";
    username.text = "";
    isloading = false;
    super.initState();
  }

  @override
  void dispose() {
    emailaddress.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //============================validate email=================================
    bool validateEmail(String email) {
      const pattern = r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com)$';
      final regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    //============================Register user==================================
    Future<void> signupUser({
      required String email,
      required String password,
      required String name,
    }) async {
      try {
        if (validateEmail(email) == false) {
          Get.snackbar("😒", " @gmail البريد الالكترونى غير صحيح",
              backgroundColor: Colors.white, colorText: Colors.red);
          // isloading = false;

          return;
        }
        if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
          isloading = true;
          setState(() {});
          // register user in auth with email and password
          UserCredential cred =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          //==== add user to your  firestore database=================

          await FirebaseFirestore.instance
              .collection("users")
              .doc(cred.user!.uid)
              .set({
            'name': name,
            'uid': cred.user!.uid,
            'email': email,
          });

          isloading = false;
          setState(() {});
          // Get.snackbar("👍", "تم التسجيل بنجاح",
          //     backgroundColor: Colors.white, colorText: Colors.red);

          Get.offAll(() => const LoginScreen());
        } else {
          Get.snackbar("😒", "تأكد من ملىء جميع الخانات",
              backgroundColor: Colors.white, colorText: Colors.red);
        }
      } catch (err) {
        if (err.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          Get.snackbar("😒", "الايميل مستخدم من قبل",
              backgroundColor: Colors.white, colorText: Colors.red);
          isloading = false;
          setState(() {});
        } else {
          Get.snackbar("😒", err.toString(),
              backgroundColor: Colors.amber, colorText: Colors.red);
          isloading = false;
          setState(() {});
        }
      }
    }

    //===================================================================================
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/registration.png'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Form with username, email, and password fields
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.85),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Username field
                        CustomForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          text: " Your Name",
                          type: TextInputType.name,
                          name: username,
                          sufxicon: const Icon(Icons.person),
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        CustomForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          text: " Your Email",
                          type: TextInputType.emailAddress,
                          name: emailaddress,
                          sufxicon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 16),
                        CustomPass(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            text: " Your Password",
                            type: TextInputType.visiblePassword,
                            issecure: issecure,
                            name: password,
                            sufxicon: InkWell(
                              onTap: () {
                                issecure = !issecure;
                                setState(() {});
                              },
                              child: Icon(issecure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),

                        // Password field

                        const SizedBox(height: 24),

                        // Register button
                        ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              signupUser(
                                  email: emailaddress.text,
                                  password: password.text,
                                  name: username.text);
                            } else {
                              log(formkey.currentState!.validate().toString());
                            }

                            // Registration logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: isloading
                              ? const CircularProgressIndicator(
                                  color: Colors.amber)
                              : const Text(
                                  ' Register',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            const Center(
                                child: Text(
                              "  You have already an account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                            TextButton(
                                onPressed: () {
                                  Get.to(() => const LoginScreen());
                                },
                                child: const Text("Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
