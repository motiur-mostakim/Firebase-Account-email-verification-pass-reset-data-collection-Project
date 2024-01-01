import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

 GlobalKey<FormState> formState = GlobalKey<FormState>();
 TextEditingController name = TextEditingController();

  CollectionReference categories= FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;
  
  addCategory()async{
    if(formState.currentState!.validate()){
    try{
      bool isLoading =true;
      setState(() {
        
      });
      DocumentReference response = 
      await categories.add({"name": name.text, "id" : FirebaseAuth.instance.currentUser!.uid});
      Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);

    }catch(e){
      bool isLoading = false;
      setState(() {
        
      });
      print("Error $e");
    }
    }
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
          addCategory() ;
          
         },child: Text("Add"),color: Colors.pink,)
        ],
      )),
    );
  }
}