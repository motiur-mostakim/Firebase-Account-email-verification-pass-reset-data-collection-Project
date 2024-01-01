import 'package:firebase_authentication/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

 GlobalKey<FormState> formState = GlobalKey<FormState>();
 TextEditingController name = TextEditingController();

  CollectionReference categories= FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;
  
  EditCategory()async{
    if(formState.currentState!.validate()){
    try{
      bool isLoading =true;
      setState(() {
        
      });

     // set update and add দুইটারই কাজ করে। 
     //  await categories.doc("12345").set({"name": name.text, "id": FirebaseAuth.instance.currentUser!.Uid});
     // এই কোড দিলে 12345 নামে নতুন ডকুমেন্ট তৈরি হবে এবং আপডেট এর কাজ ও করবে এক কাজে দুই কাজ

      await categories.doc(widget.docid).update({
        "name": name.text
      });

    }catch(e){
      bool isLoading = false;
      setState(() {
        
      });
      print("Error $e");
    }
    }
  }
  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
        centerTitle: true,
      ),
      body: Form(
        key: formState,
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
         Container(
          padding: EdgeInsets.symmetric(vertical: 30,horizontal: 35),
           child: CustomTextFormAdd(
            hintText: "Enter Name", 
            myController: name, validator: (val){
              if(val == ""){
                return "Can't To be Empty";
              }
            }),
         ),
         MaterialButton(onPressed: (){
          EditCategory() ;
          Navigator.of(context).pushReplacementNamed("home");
         },child: Text("Save"),color: Colors.pink,)
        ],
      )),
    );
  }
}