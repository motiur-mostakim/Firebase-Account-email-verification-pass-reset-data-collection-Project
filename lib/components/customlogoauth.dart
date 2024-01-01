import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 120,
                  width: 120,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const CircleAvatar(
                    // maxRadius: 200,
                    // minRadius: 200,
                    backgroundImage: AssetImage("assets/logo/mostakim.jpg",),)
                  );
  }
}