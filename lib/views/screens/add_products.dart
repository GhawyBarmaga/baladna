// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/homecontroller.dart';
import '../widgets/components.dart';
import '../widgets/dropdown_menue.dart';
import 'home_screen.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GetBuilder<HomeController>(
      builder: (HomeController controller) => Scaffold(
          backgroundColor: HexColor('efeee5'),
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Get.offAll(const HomeScreen()),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
            ),
            backgroundColor: HexColor('efeee5'),
            title: const Text(
              "اضافة اعلان جديد",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            centerTitle: true,
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Form(
                  key: controller.formkey,
                  child: Column(
                    children: [
                      CustomForm(
                        validator: (p0) => p0!.isEmpty ? "ادخل اسم المنتج" : null,
                        text: "اكتب اسم المنتج",
                        type: TextInputType.name,
                        name: controller.productname,
                      ),
                      const SizedBox(height: 10.0),
                      CustomForm(
                        validator: (p0) => p0!.isEmpty ? "ادخل اسم الشركه" : null,
                          text: "العنوان",
                          type: TextInputType.streetAddress,
                          name: controller.addresscompany),
                      const SizedBox(height: 10.0),
                      CustomForm(
                          validator: (p0) => p0!.isEmpty
                              ? "ادخل رقم التليفون"
                              : null,
                          formating: [LengthLimitingTextInputFormatter(11)],
                          text: "رقم التليفون",
                          type: TextInputType.phone,
                          name: controller.phoncompany),
                      const SizedBox(height: 10.0),
                      CustomForm(
                          validator: (p0) => p0!.isEmpty ? "ادخل وصف المنتج" : null,
                          text: "وصف المنتج",
                          type: TextInputType.name,
                          name: controller.productdesc,
                          maxLines: 3,
                          maxlentgh: 150),
                      const SizedBox(height: 10.0),
                      CustomForm(
                        validator: (p0) => p0!.isEmpty ? "ادخل السعر" : null,
                          text: "السعر ",
                          type: TextInputType.number,
                          name: controller.productprice),
                      const SizedBox(height: 10.0),
                      //======مكان تحميل الصوره
                      controller.imageSelected == null
                          ? const Text("يجب اختيار صوره اولا")
                          : Image.file(controller.imageSelected!,
                              height: h * 0.3, width: w * 0.3),
                      IconButton(
                          onPressed: () {
                            controller.pickedImage();
                          },
                          icon: const Icon(
                            Icons.upload,
                            size: 30,
                          )),
                      const Text("تحميل صورة المنتج"),
                      SizedBox(
                        height: h * 0.05,
                      ),
                      //==================================================
                      const SizedBox(height: 10.0),
                      IconButton(
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              actions: [
                                TextField(
                                 
                                  controller: controller.companyname,
                                  decoration: InputDecoration(
                                      hintText: "اسم الشركه",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white),
                                        onPressed: () {
                                          controller.addCompanies();
                                          Get.back();
                                        },
                                        child: const Text(
                                          "اضافة الشركه",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.cancel))
                                  ],
                                ),
                              ],
                            ));
                          },
                          icon: const Icon(Icons.add, size: 30)),
                      const Text("اضف شركه"),
                      const SizedBox(height: 10.0),
                  
                      const FirebaseDropdownMenuItem(),
                  
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            if( controller.formkey.currentState!.validate()) {
                               controller.addproduct();
                            }
                           
                          },
                          child: const Text(
                            "اضافة الاعلان",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
