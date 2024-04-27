import 'package:flutter/material.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class EndText extends StatelessWidget {
  EndText({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        text(
          title: title,
          color: kPrimaryColor,
          fontSize: 16,
        ),
      ],
    );
  }
}
