import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qatifa_store/components/rounded_button.dart';

import 'package:qatifa_store/pages/otp_page.dart';
import 'package:page_transition/page_transition.dart';

import 'package:qatifa_store/pages/products_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final phoneController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;


  String verificationId;
  bool showLoading = false;


  getMobileFormWidget(context) {
    return ListView(

       // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: (MediaQuery.of(context).size.height/9.24).roundToDouble(),//=80
          backgroundColor: Colors.white,
          child: Image(
            image: AssetImage("images/logo1.png"),
            width: (MediaQuery.of(context).size.width/2.117).roundToDouble(),//=170.0,
            height: (MediaQuery.of(context).size.height/4.667).roundToDouble(),//=170.0,
          ),
        ),
        SizedBox(height: (MediaQuery.of(context).size.height/14.786).roundToDouble()),//=50.0
        Center(
          child: Container(
            height:(MediaQuery.of(context).size.height/18.48).roundToDouble(),//=40
            width: (MediaQuery.of(context).size.height/18.48).roundToDouble(),//=40
            child: Visibility(
              visible: showLoading,
                child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
             ),
            ),
          ),
        ),
        SizedBox(height: (MediaQuery.of(context).size.height/14.786).roundToDouble()),//=50.0
        
        Container(
          height:(MediaQuery.of(context).size.height/1.7).roundToDouble(), //=349
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            color: Color(0xfffdede3),),
          padding: EdgeInsets.all(30.0),

          child: Column(
            children: [
              TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "رقم الهاتف : 2189xxxxxxxx+",
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.brown[400], width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  )),
              SizedBox(
                  height: (MediaQuery.of(context).size.height/24.64).roundToDouble() ,//=30
              ),
              RoundedButton(
                width: (MediaQuery.of(context).size.width/1.8).roundToDouble() , //=200
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });
                  await _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                        // signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          showLoading = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("حدث خطأ ما ، يُرجى التأكد من اتصالك بالانترنت وإعادة المحاولة")));
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          showLoading = false;
                          Navigator.push(context, PageTransition(duration: Duration(milliseconds:500),type: PageTransitionType.rightToLeft, child: OtpPage(verificationId, phoneController.text)));

                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {});
                },
                title: "إرسال",
                color: Colors.white,
              )

            ],
          ),
        )
      ],
    );
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0.0),
          child: getMobileFormWidget(context)
        ));
  }
}
