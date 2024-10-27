import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/note/add.dart';
import 'package:firebase_authentication/note/edit.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  const NoteView({super.key, required this.categoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {

    // bool isLoading = true;

   final _userStream = FirebaseFirestore.instance.collection("categories").
   doc(widget.categoryid).collection("note").snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNote(docid: widget.categoryid)));
      },
      child: const Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        title: const Text("Note"),
        actions: [
          IconButton(
            onPressed: ()async{
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
            }, 
            icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: WillPopScope(child: StreamBuilder(
         stream: _userStream,
         builder: (context,snapshot){
           
              // bool isLoading = false;          
           if(snapshot.hasError){
            return const Text("Connection error");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
            
          }
          var docs = snapshot.data!.docs;
          return 
          // isLoading == true ? Center(child: CircularProgressIndicator()) : 
          GridView.builder(
        itemCount: docs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        mainAxisExtent: 165),
         itemBuilder: (context, i){
           return InkWell(
             onLongPress: (){
              AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                           showCloseIcon: true,
                          title: 'Error',
                          titleTextStyle: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700),
                          desc: 'Do you want delete this file',
                          descTextStyle: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),
                          btnOkText: "Edit Your Data",
                          btnOkOnPress: ()async{
                           Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>EditNote(
                  notedocid: docs[i].id, 
                  categorydocid: widget.categoryid, 
                  value: docs[i]["note"])),);
                            // Navigator.of(context).pushReplacementNamed("home");
                          },
                          btnCancelText: "Delete your Data",
                          btnCancelOnPress: ()async{
                            
                            await FirebaseFirestore.instance.collection("categories").
                            doc(widget.categoryid).collection("note").doc(docs[i].id).delete();
                            Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>NoteView(categoryid: widget.categoryid)));
                          }
                          // btnOkIcon: Icons.cancel,
                          // btnOkColor: Colors.red,
                          ).show();
            },
             child: Card(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Text("${docs[i]["note"]}",
                  style: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w700),),
                ),
              ),
                     ),
           );
         }
              
      );
         }  
    ), onWillPop: (){
      Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      return Future.value(false);
    }));
  }
}

