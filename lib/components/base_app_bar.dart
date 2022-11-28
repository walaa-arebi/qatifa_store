import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:qatifa_store/pages/cart.dart';
import 'package:qatifa_store/pages/products_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatifa_store/pages/favorites.dart';
import 'package:qatifa_store/pages/login_page.dart';


class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final double imageSize;
  final bool iconsVisibilty;
  final String pageName;

  final _auth = FirebaseAuth.instance;

  BaseAppBar({this.appBar,this.imageSize,this.iconsVisibilty,this.pageName});


  showAlertDialog(BuildContext context) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text("تسجيل الخروج",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text("هل ترغب حقاً في تسجيل الخروج؟",textDirection: TextDirection.rtl,),
      actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("لا", style: TextStyle(fontSize: 18.0,color: Colors.green),),
            ),
            TextButton(
              onPressed: ()async{
                await _auth.signOut();

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginPage()),ModalRoute.withName("/pages/login_page"));
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InitializerWidget()));
              } ,
              child: Text("نعم", style: TextStyle(fontSize: 18.0,color: Colors.red),),

            )

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70.0,
      backgroundColor: Color(0xfffdede3),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: ()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> ProductsPage()),ModalRoute.withName("/pages/products_page")),
            child: Hero(
              tag: 'logo',
              child: Image(
                //====================the logo at app bar============
                image: AssetImage("images/logo1.png"),
                width: imageSize,
                height: imageSize,
              ),
            ),
          ),
          Text(
            pageName,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
      actions: [
        Visibility(
          visible: iconsVisibilty,
          child: IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
        ),
        Visibility(
          visible: iconsVisibilty,
          child:  IconButton(
            icon: Icon(Icons.favorite, color: Colors.black),
            onPressed: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Favorites()));
            },
          )
        ),
        Visibility(
          visible: iconsVisibilty,
          child: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              showAlertDialog(context);
            } ,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(70.0);
}

