import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/components/custombuttonauth.dart';
import 'package:firebase_authentication/components/customlogoauth.dart';
import 'package:firebase_authentication/components/textformField.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CustomLogoAuth(),
                    const Padding(
                      padding: EdgeInsets.only(top: 30,right: 355),
                      child: Text("SignUp",style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.w600
                    ),),),
                    
                     const Padding(
                      padding: EdgeInsets.only(top: 8,right: 185),
                      child: Text("SignUp To Continue Usign The App",style: TextStyle(
                      fontSize: 17,color: Colors.grey
                    ),),),
                    const Padding(
                      padding: EdgeInsets.only(top: 30,right: 340),
                      child: Text("Username",style: TextStyle(
                      fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black
                    ),),),
                     CustomTextForm(
                      hintText: "Enter Your Username",myController: username,validator: (val){
                          if(val == ""){
                            return "Can't To be Empty";
                          }
                        }
                    ),
            
                     const Padding(
                      padding: EdgeInsets.only(top: 30,right: 380),
                      child: Text("Email",style: TextStyle(
                      fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black
                    ),),),
            
                    CustomTextForm(
                      hintText: "Enter Your Email",myController: email,validator: (val){
                          if(val == ""){
                            return "Can't To be Empty";
                          }
                        }
                    ),
            
                     const Padding(
                      padding: EdgeInsets.only(top: 20,right: 347),
                      child: Text("Password",style: TextStyle(
                      fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black
                    ),),),
            
                    
                    CustomTextForm(
                      hintText: "Enter Your Password",myController: password,validator: (val){
                          if(val == ""){
                            return "Can't To be Empty";
                          }
                        }
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 320),
                      child: TextButton(
                      onPressed: (){},
                      child: const Text("Forgot Password ?",style: TextStyle(
                        fontSize: 17,
                      ))
                      )),
                      CustomButtonAuth(title: "SignUp",onPressed: ()async{
                        if(formState.currentState!.validate()){
                          try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      // FirebaseAuth.instance.currentUser!.sendEmailVerification();
                       Navigator.of(context).pushReplacementNamed("login");
            
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        titleTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),
                        desc: 'The password provided is too weak.',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        titleTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
                        desc: 'The account already exists for that email.',
                        descTextStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black),
                        ).show();
                      }
                    } catch (e) {
                      print(e);
                    }
                        }
                      },),
                      // SizedBox(width: 10,),
                      Padding(padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have An Account?",style: TextStyle(fontSize: 16,color: Colors.black),),
                          SizedBox(width: 3,),
                          TextButton(onPressed: (){
                            Navigator.of(context).pushNamed("login");
                          }, child: Text("Login",style: TextStyle(fontSize: 17),))
                        ]
                      ),)
                      
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}