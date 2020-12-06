import 'package:blog_app_final/services/crudMethods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String AuthorNAme, Title,Desc;

  crudMeth crudMethods= new crudMeth();
  File selectedImage;
  final picker = ImagePicker();
  bool IsLoading=false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadBlog() async{
    if(selectedImage!=null){
      setState(() {
        IsLoading=true;

      });
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child("BlogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final firebase_storage.UploadTask task= ref.putFile(selectedImage);
      var downloadUrl= await (await task).ref.getDownloadURL();
      if(downloadUrl==null){
       print("THERE IS AN ERRORRR!!!!!");
      }else {
        print("this is url $downloadUrl");
      }
      Map<String, String> BlogMAp={
        "imageURL": downloadUrl,
        "AuthorName": AuthorNAme,
        "description":Desc,
        "title":Title
      };
      crudMethods.addData(BlogMAp).then((result){
        Navigator.pop(context);
      });
    }else{

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0.0,
  title:Row(
    children: [
      Text("BLOGS",
        style: GoogleFonts.montserrat(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white

        ),),
      Text("DECK",
        style: GoogleFonts.montserrat(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: Colors.blue,

        ),
      ),
    ],
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
  ),
    actions: [
    GestureDetector(
    onTap: () {
        uploadBlog();
    },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Icons.file_upload,
        ),
      ),
    ),]
),
      body: IsLoading?Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Text('Add Your',
                    style: GoogleFonts.concertOne(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Row(
                children: [
                  Container(
                    child: TyperAnimatedTextKit(
                      text: ['BLOG'],
                      textStyle: GoogleFonts.concertOne(
                        fontSize: 60,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      speed: Duration(milliseconds: 500),
                      isRepeatingAnimation: false,
                    ),
                  ),
                  SizedBox(
                    width: 17,
                  ),
                  Text(
                    'Here',
                    style: GoogleFonts.concertOne(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: (selectedImage!=null)?Container(
                margin:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.file(selectedImage,fit: BoxFit.cover,)),
                height: 150,
                width: MediaQuery.of(context).size.width,

              ):Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Colors.white38,
                    ),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
            ),

              SizedBox(
                height: 12,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    TextField(

                      decoration: InputDecoration(

                        hintText: 'Author Name',
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                      onChanged: (val) {
                           AuthorNAme=val;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                          )),
                      onChanged: (val) {
                         Title=val;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                          )),
                      onChanged: (val) {
Desc=val;
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
