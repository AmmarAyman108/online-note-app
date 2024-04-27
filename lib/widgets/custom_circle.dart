import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCircle extends StatelessWidget {
  CustomCircle({super.key, required this.image, this.onTap});
  String image;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: .5),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(50000),
          ),
        ),
      ),
    );
  }
}
