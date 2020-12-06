
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:flutter/cupertino.dart';

class crudMeth{

  Future<void> addData(BlogData) async{
    FirebaseFirestore.instance.collection("blogs").add(BlogData).catchError((e){
      print(e);
    });
  }
 getData() async{
    return await FirebaseFirestore.instance.collection("blogs").snapshots();
}

}