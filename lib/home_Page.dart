
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: ()async{
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
          }, icon: Icon(Icons.exit_to_app)),
        ],
        title: const Text("Firebase Install"),
        centerTitle: true,
      ),
     body: ListView(
      children: [
        FirebaseAuth.instance.currentUser!.emailVerified ? 
        Center(
          child: Container(
            alignment: Alignment.center,child: Text("Welcome",
            style: TextStyle(fontSize: 30,color: Colors.pink,fontWeight: FontWeight.w500),)),
        )
           : Padding(
             padding: const EdgeInsets.only(top: 300,left: 30, right: 30),
             child: MaterialButton(
                     height: 40,
                     color: Colors.pink,
                     shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
                     ),
                     onPressed: (){
                       AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Werning',
                          desc: 'Please go to your Gmail Account ? Click this link and verified your account successful ?',
                          btnOkOnPress: (){
                            FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          btnCancelOnPress: (){}
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
                     
                   },child: Text("Please Verified Email"),),
           )
      ],
     )
    );
  }
}