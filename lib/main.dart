import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

import 'package:qatifa_store/pages/login_page.dart';
import 'pages/products_page.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
      MaterialApp(
          home: InitializerWidget()));
}



class InitializerWidget extends StatefulWidget {


  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {

  FirebaseAuth _auth;
  User _user;
  bool isLoading=true;

  @override
  void initState() {

    super.initState();
      _auth=FirebaseAuth.instance;
      _user=_auth.currentUser;
      isLoading=false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? Scaffold(body: Center(child: CircularProgressIndicator()),)
        :
    _user==null? LoginPage(): ProductsPage()
    ;
  }
}
