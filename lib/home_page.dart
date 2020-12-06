import 'package:blog_app_final/create_blog.dart';
import 'package:blog_app_final/services/crudMethods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/crudMethods.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream blogSnapshot;
  crudMeth crudMethods= new crudMeth();
  Widget BlogsList(){
    return Container(
      child: blogSnapshot!=null?SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(

          children: [
            StreamBuilder(
                stream: blogSnapshot,

                builder: (context, snapshot){
                  return ListView.builder   (
                    
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context,index){
                        return BlogsTile(
                          AuthorName: snapshot.data.docs[index].data()['AuthorName'],
                          title:snapshot.data.docs[index].data()['title'] ,
                          descr: snapshot.data.docs[index].data()['description'],
                          imageUrl: snapshot.data.docs[index].data()['imageURL'],
                        );
                      }

                  );

                })

          ],
        ),
      ):Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
  }
  @override
  void initState() {
    

    super.initState();
    crudMethods.getData().then((result){
      setState(() {
        blogSnapshot=result;
      });


    });
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

      ),
      body: BlogsList(),
      floatingActionButton: Container(
padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(onPressed:(){

                   Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBlog()));
            }, label:Text(
              "Add Blog",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
            ) ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
 String imageUrl,AuthorName,title,descr;
 BlogsTile({this.imageUrl,this.AuthorName,this.title,this.descr});

  @override
  Widget build(BuildContext context) {
      return Stack(
        children: [

          Container(child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: CachedNetworkImage(
                imageUrl: imageUrl,height: 150,width: MediaQuery.of(context).size.width,fit:BoxFit.cover,)

          ),

          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

          ),
          Container(
            margin:
            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.3),
                borderRadius: BorderRadius.circular(17),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin:
            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(

                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,

                ),),
                SizedBox(height: 4,),
                Text(descr,style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,

                ),),
                SizedBox(height: 4,),
                Text(AuthorName,style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,

                ),),

              ],
            ),
          )
        ],
      );
    }
}
