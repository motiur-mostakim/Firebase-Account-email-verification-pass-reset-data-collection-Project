import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/auth/login.dart';
import 'package:firebase_authentication/auth/signup.dart';
import 'package:firebase_authentication/categories/add.dart';
import 'package:firebase_authentication/firebase_options.dart';
import 'package:firebase_authentication/home.dart';
import 'package:firebase_authentication/home_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
   FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('==========================User is currently signed out!');
    } else {
      print('==========================User is signed in!');
    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            fontSize: 17,color: Colors.pink[500],fontWeight: FontWeight.w500
          ),
          iconTheme: IconThemeData(color: Colors.pink[500])
        )
      ),
      debugShowCheckedModeBanner: false,
      home: 
      FirebaseAuth.instance.currentUser == null ? Login() : HomePage(),
      routes: {
      "signup": (context)=> SignUp(),
      "login": (context)=> Login(),
      "home": (context)=> Home(),
      "homepage": (context)=> HomePage(),
      "addcategory": (context) => AddCategory(),
      },
    );
  }
}