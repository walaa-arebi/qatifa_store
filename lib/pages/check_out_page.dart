import 'dart:ui';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qatifa_store/components/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qatifa_store/db/order.dart';

final _fireStore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;



class CheckOutPage extends StatefulWidget {

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  bool _connection = true;

  void connectivity() async {

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          _connection = true;
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        _connection = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    connectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_connection ? Scaffold(
      appBar: BaseAppBar(
        imageSize: 60.0,
        iconsVisibilty: false,
        pageName: 'الشراء',
        appBar: AppBar(),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("أنت غير متصل بالانترنت ", style: TextStyle(fontSize: 18.0),
            textDirection: TextDirection.rtl,),
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (BuildContext context) => CheckOutPage()
                ));
              }
          ),
        ],
      )
      ),) :
    CheckOut();
  }
}
class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  TextEditingController PhoneNumController = TextEditingController();
  TextEditingController secondPhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  OrderService orderService = OrderService();
  bool isLoading = false;

    @override
  Widget build(BuildContext context) {
         return Scaffold(
               appBar: BaseAppBar(
                 imageSize: 60.0,
                 iconsVisibilty: false,
                 pageName: 'الشراء',
                 appBar: AppBar(),
               ),
               body: Form(
                 key: _formKey,
                 child: Padding(
                   padding: EdgeInsets.all(15.0),
                   child: isLoading? Center(child: CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                   ),) :
                   ListView(
                       //crossAxisAlignment: CrossAxisAlignment.stretch,
                       children:[
                         TextField(
                           controller: PhoneNumController ,
                           keyboardType: TextInputType.phone,
                           textDirection: TextDirection.rtl,
                           decoration: InputDecoration(hintText: "ادخل رقم هاتف المستلم 09x-xxx xx xx",
                           hintTextDirection: TextDirection.rtl,
                           focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.black,width: 2.0), //<-- SEE HERE
                           ),
                           ),
                         ),
                         SizedBox(height: 10.0,),
                         TextField(
                           controller: secondPhoneController ,
                           keyboardType: TextInputType.phone,
                           textDirection: TextDirection.rtl,
                           decoration: InputDecoration(hintText: "رقم هاتف احتياطي",
                               hintTextDirection: TextDirection.rtl,
                               focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Colors.black,width: 2.0), //<-- SEE HERE
                             ),
                           ),
                         ),
                         SizedBox(height: 10.0,),
                         TextField(
                           controller: addressController ,
                           textDirection: TextDirection.rtl,
                           decoration: InputDecoration(hintText: "عنوان الاستلام",
                               hintTextDirection: TextDirection.rtl,
                               focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Colors.black,width: 2.0), //<-- SEE HERE
                             ),),
                         ),
                         SizedBox(height: 10.0,),
                         TextField(
                           controller: noteController ,
                           textDirection: TextDirection.rtl,
                           decoration: InputDecoration(hintText: "ملاحظات",
                             hintTextDirection: TextDirection.rtl,
                             focusedBorder: UnderlineInputBorder(
                               borderSide: BorderSide(color: Colors.black,width: 2.0), //<-- SEE HERE
                             ),),
                         ),

                         SizedBox(height: 50.0,),

                     MaterialButton(
                       onPressed: validateAndUpload,
                       child: Container(
                           height:40.0,
                           width:(MediaQuery.of(context).size.width/2.25).roundToDouble(),//=160.0
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10.0),
                             color: Color(0xfffdede3),
                           ),
                           child: Center(child: Text("تأكيد الطلب"))
                       ),
                     ),

                       ]
                   ),
                 ),
               ),
             );

  }

  Map <String , dynamic> cart;
  Map <String , dynamic> cartOrder;
  validateAndUpload()async{
    if (_formKey.currentState.validate()){
      if( PhoneNumController.text.length==10 && PhoneNumController.text.startsWith("09")  && addressController.text !=""){
        setState(() {
          isLoading=true;
        });

        var snapshot = await _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('cart').get();
        var snapshotData = snapshot.docs;
        for (var i =0; i<snapshotData.length;i++){
           cart = snapshotData.map((doc) => doc.data()).elementAt(i);

        }
        cartOrder =  Map.fromIterable(cart.keys.where((k) => k == 'name' || k =='price' || k =='quantity' || k =='size'|| k =='images'), key: (k) => k, value: (v) => cart[v]);


        orderService.addOrder(
          phoneNumber: PhoneNumController.text,
          secondPhone: secondPhoneController.text,
          address: addressController.text,
          note: noteController.text,
          cart: cartOrder,

        );


        _formKey.currentState.reset();
        setState(() {
          isLoading=false;
        });

        Navigator.pop(context);
         Fluttertoast.showToast(msg: "تم تسجيل طلبك سنقوم بمراسلتك لتأكيد الطلب , شكرا لثقتكم بنا ");
      }else {Fluttertoast.showToast(msg: "نرجو منك إدخال رقم الهاتف والعنوان بشكل صحيح");
      }
    }
  }
}




