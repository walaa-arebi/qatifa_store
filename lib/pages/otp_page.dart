import 'package:flutter/material.dart';
import 'package:qatifa_store/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:qatifa_store/db/users.dart";
import 'package:qatifa_store/pages/products_page.dart';

import 'package:qatifa_store/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';

class OtpPage extends StatefulWidget {
  final  verificationID;
  final  phoneNumber;
  OtpPage(this.verificationID , this.phoneNumber);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {


  final otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserServices _userServices = UserServices();
  bool showLoading=false;


  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      // ******** create user on database **************

      if (authCredential?.user != null) {
        _userServices.createUser(_auth.currentUser.uid.toString(), {
          "user phone": widget.phoneNumber,
          "userId": _auth.currentUser.uid,

        });

        Navigator.of(context).pushAndRemoveUntil(
            PageTransition(duration: Duration(milliseconds:500),type: PageTransitionType.rightToLeft, child: ProductsPage()),
            ModalRoute.withName("/pages/products_page"));

         }
    } on FirebaseAuthException catch (e) {
        setState(() {
          showLoading = false;
        });
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("حدث خطأ ما ، يُرجى التأكد من اتصالك بالانترنت وإعادة المحاولة")));
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: Colors.white,
      body:Container(
        padding: EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0.0),
        child: ListView(
        children: [
          CircleAvatar(
            radius: (MediaQuery.of(context).size.height/9.24).roundToDouble(),//=80
            backgroundColor: Colors.white,
            child: Hero(
              tag: "logo",
              child: Image(
                image: AssetImage("images/logo1.png"),
                width: (MediaQuery.of(context).size.width/2.117).roundToDouble(),//=170.0,
                height: (MediaQuery.of(context).size.height/4.667).roundToDouble(),//=170.0,
              ),
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
              color: Color(0xfffdede3),
            ),
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: [
                TextField(
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    decoration: InputDecoration(
                      hintText: "أدخل الرمز الذي تلقيته",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      width: (MediaQuery.of(context).size.width/3.6).roundToDouble() , //=100
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginPage()),ModalRoute.withName("/pages/login_page"));
                      },
                      title: "رجوع",
                      color: Colors.white,
                    ),
                    SizedBox( width: (MediaQuery.of(context).size.width/18).roundToDouble()) , //=20,
                    RoundedButton(
                      width: (MediaQuery.of(context).size.width/3.6).roundToDouble() , //=100
                      onPressed: () async {
                        PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: widget.verificationID,
                            smsCode: otpController.text);
                        signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                      title: "تأكيد",
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
