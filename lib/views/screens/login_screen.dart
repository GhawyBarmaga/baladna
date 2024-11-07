// ignore_for_file: unused_element

import 'package:baladna_go/views/screens/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/components.dart';
import '../widgets/forgot_pass.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ischecked = false;
  final localstorage = GetStorage();
  bool issecure = true;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> fkey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    email.text = localstorage.read("email") ?? "";
    password.text = localstorage.read("password") ?? "";
    ischecked = false;
    isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> loginUser({
      final String? email,
      final String? password,
    }) async {
      try {
        if (email!.isNotEmpty || password!.isNotEmpty) {
          if (ischecked == true) {
            localstorage.write("email", email.trim());
            localstorage.write("password", password?.trim());
          }
          isloading = true;
          setState(() {});
          // logging in user with email and password
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password!,
          );

          Get.offAll(() => const HomeScreen());
          setState(() {});
          isloading = false;
        } else {
          Get.snackbar("😊", "حاول مره اخرى",
              backgroundColor: Colors.white, colorText: Colors.red);
          setState(() {});
          isloading = false;
        }
      } catch (err) {
        Get.snackbar("😒", err.toString(),
            backgroundColor: Colors.white, colorText: Colors.red);
        setState(() {});
        isloading = false;
      }
    }

//==========================================================================================
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_2.png'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Form with username, email, and password fields
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.white,
                    ),
                    Card(
                      color: Colors.white.withOpacity(0.50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: fkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Username field
                              const SizedBox(
                                height: 40,
                              ),
                              CustomForm(
                                validator: (p0) =>
                                    p0!.isEmpty ? "Required Field" : null,
                                text: " Your Email",
                                type: TextInputType.emailAddress,
                                name: email,
                                sufxicon: const Icon(Icons.email),
                              ),
                              const SizedBox(height: 16),
                              CustomPass(
                                  validator: (p0) =>
                                      p0!.isEmpty ? "Required Field" : null,
                                  text: "  Your Password",
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
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => const ForgotPass());
                                      },
                                      child: const Text(
                                        " Forgot Password ?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                ],
                              ),
                              //const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Remember Me",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Checkbox(
                                      activeColor: HexColor("8a2be2"),
                                      checkColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.black),
                                      value: ischecked,
                                      onChanged: (value) {
                                        ischecked = !ischecked;
                                        setState(() {});
                                      }),
                                ],
                              ),

                              // Password field

                              const SizedBox(height: 24),

                              // Register button
                              ElevatedButton(
                                onPressed: () {
                                  if (fkey.currentState!.validate()) {
                                    loginUser(
                                      email: email.text,
                                      password: password.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                child: isloading
                                    ? const CircularProgressIndicator(
                                        color: Colors.amber,
                                      )
                                    : const Text(
                                        ' Login',
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
                                    "You don't have an account? ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => const RegisterScreen());
                                      },
                                      child: const Text("Register",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
