import 'package:firebase_authentication/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication/note/view.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String value;
  final String categorydocid;
  const EditNote({super.key, required this.notedocid, required this.categorydocid, required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

 GlobalKey<FormState> formState = GlobalKey<FormState>();
 TextEditingController note = TextEditingController();



  bool isLoading = false;
  
  editNote()async{
      CollectionReference collectionnote=
       FirebaseFirestore.instance.collection('categories').doc(widget.categorydocid).collection("note");
    if(formState.currentState!.validate()){
    try{
      bool isLoading =true;
      setState(() {
        
      }); 
      await collectionnote.doc(widget.notedocid).update({"note": note.text});
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>NoteView(categoryid: widget.categorydocid)));

    }catch(e){
      bool isLoading = false;
      setState(() {
        
      });
      print("Error $e");
    }
    }
  }
  @override
  void initState(){
    note.text = widget.value;
    super.initState();
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
        title: Text("Edit Note"),
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
          editNote() ;
          
         },child: Text("Save"),color: Colors.pink,)
        ],
      )),
    );
  }
}