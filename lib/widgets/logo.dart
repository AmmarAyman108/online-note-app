import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5000),
          image: const DecorationImage(
            image: AssetImage('assets/images/logo.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
