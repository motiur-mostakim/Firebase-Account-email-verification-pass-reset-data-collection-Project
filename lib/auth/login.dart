import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/components/custombuttonauth.dart';
import 'package:firebase_authentication/components/customlogoauth.dart';
import 'package:firebase_authentication/components/textformField.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if(googleUser == null){
    return;
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CustomLogoAuth(),
                    const Padding(
                      padding: EdgeInsets.only(top: 30,right: 370),
                      child: Text("Login",style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.w600
                    ),),),
                    
                     const Padding(
                      padding: EdgeInsets.only(top: 8,right: 185),
                      child: Text("Login To Continue Usign The App",style: TextStyle(
                      fontSize: 17,color: Colors.grey
                    ),),),
            
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
                      },
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
                      onPressed: ()async{
                         if (email.text == ""){
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: false,
                          title: 'Error',
                          desc: 'Please Enter Your Email, then click Forgot Password',
                          btnOkOnPress: (){},
                          //btnCancelOnPress: (){}
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
                          return;
                         }

                        try{
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Error',
                          desc: 'Please go to your Gmail Account and click this link and set' 
                          'your new password,then login your Account',
                          btnOkOnPress: (){},
                          btnCancelOnPress: (){}
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
                        }catch(e){
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Error',
                          desc: 'when you will be null password you are not login your Account?',
                          btnOkOnPress: (){},
                          btnCancelOnPress: (){}
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
                        }
                        
                      },
                      child: const Text("Forgot Password ?",style: TextStyle(
                        fontSize: 17,
                      ))
                      )),
                      CustomButtonAuth(title: "Login",onPressed: ()async{
                        if (formState.currentState!.validate()){
                          try {
                             isLoading = true;
                            setState(() {
                              
                            });
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                        );
                         isLoading = false;
                            setState(() {
                              
                            });
                        if(credential.user!.emailVerified){
                          Navigator.of(context).pushReplacementNamed("home");
                        }else{
                          // FirebaseAuth.instance.currentUser!.sendEmailVerification();
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Error',
                          desc: 'Please Verified Your Email ?',
                          btnOkOnPress: (){
                            Navigator.of(context).pushReplacementNamed("homepage");
                          },
                          btnCancelOnPress: (){}
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
                        }
      
                      } on FirebaseAuthException catch (e) {
                        isLoading = false;
                            setState(() {
                              
                            });
                       AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: 'Error',
                          desc: 'No user found for that email.',
                          btnOkOnPress: (){},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                          ).show();
                        
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                           AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: 'Error',
                          desc: 'No user found for that email.',
                          btnOkOnPress: (){},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                          ).show();
                          
                          
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: 'Error',
                          desc: 'Wrong password provided for that user.',
                          btnOkOnPress: (){},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                          ).show();
                          
                        }else{
                          print("Not Valid");
                        }
                      }
                        }
                      },),
                      // SizedBox(width: 10,),
                      Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 30,left: 50,right: 50),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 300,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.pink,
                          onPressed: (){
                            signInWithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/logo/google.png",width: 25,),
                              const SizedBox(width: 15,),
                              const Text("Login With Google",style: TextStyle(fontSize: 17,color: Colors.black),)
                            ],
                          )
                          ),
                      ),
                      Padding(padding: EdgeInsets.only(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont't Have An Account?",style: TextStyle(fontSize: 16,color: Colors.black),),
                          SizedBox(width: 3,),
                          TextButton(onPressed: (){
                            Navigator.of(context).pushReplacementNamed("signup");
                          }, child: Text("Register",style: TextStyle(fontSize: 17),))
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