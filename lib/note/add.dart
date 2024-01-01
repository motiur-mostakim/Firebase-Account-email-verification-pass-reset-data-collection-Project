import 'package:firebase_authentication/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication/note/view.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

 GlobalKey<FormState> formState = GlobalKey<FormState>();
 TextEditingController note = TextEditingController();



  bool isLoading = false;
  
  addNote()async{
      CollectionReference collectionnote=
       FirebaseFirestore.instance.collection('categories').doc(widget.docid).collection("note");
    if(formState.currentState!.validate()){
    try{
      bool isLoading =true;
      setState(() {
        
      });
      DocumentReference response = 
      await collectionnote.add({"note": note.text});
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>NoteView(categoryid: widget.docid)));

    }catch(e){
      bool isLoading = false;
      setState(() {
        
      });
      print("Error $e");
    }
    }
  }
  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        centerTitle: true,
      ),
      body: Form(
        key: formState,
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
         Container(
          padding: EdgeInsets.symmetric(vertical: 30,horizontal: 35),
           child: CustomTextFormAdd(
            hintText: "Enter Your Note", 
            myController: note, validator: (val){
              if(val == ""){
                return "Can't To be Empty";
              }
            }),
         ),
         MaterialButton(onPressed: (){
          addNote() ;
          
         },child: Text("Add"),color: Colors.pink,)
        ],
      )),
    );
  }
}