import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/categories/edit.dart';
import 'package:firebase_authentication/note/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    // bool isLoading = true;

   final _userStream = FirebaseFirestore.instance.collection("categories").
   where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: (){
        Navigator.of(context).pushNamed("addcategory");
      },
      child: Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: ()async{
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
            }, 
            icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: StreamBuilder(
         stream: _userStream,
         builder: (context,snapshot){
           
              // bool isLoading = false;          
           if(snapshot.hasError){
            return Text("Connection error");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
            
          }
          var docs = snapshot.data!.docs;
          return 
          // isLoading == true ? Center(child: CircularProgressIndicator()) : 
          GridView.builder(
        itemCount: docs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        mainAxisExtent: 165),
         itemBuilder: (context, i){
           return InkWell(
            onDoubleTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteView(categoryid: docs[i].id)));
            },
            onLongPress: (){
              AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Error',
                          titleTextStyle: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700),
                          desc: 'Do you want delete this file',
                          descTextStyle: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),
                          btnOkText: "Edit Your Data",
                          btnOkOnPress: ()async{
                           Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>EditCategory(docid: docs[i].id, oldname: docs[i]["name"])),);
                            // Navigator.of(context).pushReplacementNamed("home");
                          },
                          btnCancelText: "Delete your Data",
                          btnCancelOnPress: ()async{
                            await FirebaseFirestore.instance.collection("categories").doc(docs[i].id).delete();
                           Navigator.of(context).pushReplacementNamed("home");
                          }
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
            },
             child: Card(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset("assets/logo/file manager3.jpeg",height: 120,),
                    Text("${docs[i]["name"]}",
                    style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w700),)
                  ],
                ),
              ),
                     ),
           );
         }
              
      );
         }  
    ));
  }
}

