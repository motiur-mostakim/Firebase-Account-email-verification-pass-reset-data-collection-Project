import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final  void Function()? onPressed;
  final String title;
  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
                     padding: const EdgeInsets.only(top: 30,),
                      child: MaterialButton(
                        height: 50,
                        minWidth: 400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.blue,
                        onPressed: onPressed,
                        child:  Text(title,style: TextStyle(fontSize: 17,color: Colors.black),),
                        ),
                    );
  }
}