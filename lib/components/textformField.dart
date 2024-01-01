import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController myController;
  final String? Function(String?)? validator;
  const CustomTextForm({super.key, required this.hintText, required this.myController,required this.validator});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(top: 10,right: 20,left: 20),
                  child: TextFormField(
                    validator: validator,
                    controller: myController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                    hintText: hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 185, 182, 182)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  ));
  }
}