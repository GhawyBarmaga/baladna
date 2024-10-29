// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class Like_Button extends StatelessWidget {
  bool isliked;
  void Function()? ontab;
  Like_Button({super.key, required this.ontab, required this.isliked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Icon(
        isliked ? Icons.favorite : Icons.favorite_border,
        color: isliked ? Colors.red : Colors.grey,
      ),
    );
  }
}