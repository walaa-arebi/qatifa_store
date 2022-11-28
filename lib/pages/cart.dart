import 'dart:ui';
import 'dart:io';
import 'package:qatifa_store/components/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qatifa_store/pages/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'check_out_page.dart';

final _fireStore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class Cart extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool _connection = true;

  void connectivity()async{
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
    return !_connection? Scaffold(
      appBar: BaseAppBar(
        imageSize: 60.0,
        iconsVisibilty: false,
        pageName: 'سلة المشتريات',
        appBar: AppBar(),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("أنت غير متصل بالانترنت ",style:TextStyle(fontSize: 18.0),textDirection: TextDirection.rtl,),
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: (){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => Cart()
                ));}
          ),
        ],
      )
      ),):
      ProductsStream();
  }
}

class ProductsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map <String,dynamic>>>(
        stream: _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('cart').snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Scaffold(
                appBar: BaseAppBar(
                  imageSize: 60.0,
                  iconsVisibilty: false,
                  pageName: 'سلة المشتريات',
                  appBar: AppBar(),
                ),
                body: Center(
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                    ),
                  ),
                ),
              );

            }
          num total = 0.0;
          final products = snapshot.data.docs;
          List<Single_Cart_Product> cartProducts=[];
          for (var product in products){
            final cart_prod_name = product.data()['name'];
            final cart_prod_pictures = product.data()["images"];
            final cart_prod_price = product.data()["price"];
            final cart_prod_size = product.data()["size"];
            final cart_prod_details = product.data()["details"];
            final cart_prod_id = product.data()["id"];
            final cart_prod_qty = product.data()["quantity"];
            final cart_prod_sizes = product.data()["sizes"];
            final cart_prod_available = product.data()['available'];
            total = total + (cart_prod_price * cart_prod_qty);
            final singleCartProduct= Single_Cart_Product(
              cart_prod_name: cart_prod_name,
              cart_prod_pictures: cart_prod_pictures,
              cart_prod_price: cart_prod_price,
              cart_prod_size: cart_prod_size,
              cart_prod_details: cart_prod_details,
              cart_prod_id: cart_prod_id,
              cart_prod_qty: cart_prod_qty,
              cart_prod_sizes: cart_prod_sizes,
              cart_prod_available:cart_prod_available,
            );
            cartProducts.add(singleCartProduct);
            }
          bool emptyCart = cartProducts.isEmpty;
          return Scaffold(
            appBar: BaseAppBar(
              imageSize: 60.0,
              iconsVisibilty: false,
              pageName: 'سلة المشتريات',
              appBar: AppBar(),
            ),
            backgroundColor: Colors.grey[100],
            body:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                child: !emptyCart?
                ListView(
                padding: EdgeInsets.symmetric(
                    vertical:10.0,
                    horizontal:10.0,
                ),
                children: cartProducts,
              ):
                    Center(child: Text("سلة المشتريات فارغة",style: TextStyle(fontSize: 20.0),)),
              ),
              ],
            ),

            bottomNavigationBar: Visibility(
              visible: !emptyCart,
              child: Container(
                height: 100.0,
                child: Card(
                  elevation: 5.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    textDirection: TextDirection.rtl,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(":الإجمالي",style: TextStyle(fontSize: 18.0,color: Colors.grey[700],fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width/36).roundToDouble()//=10.0,
                          ),
                          Text("${total.toString()} د.ل",style: TextStyle(fontSize: 18.0,fontWeight:FontWeight.bold),textDirection: TextDirection.rtl,),
                        ],
                      ),
                      MaterialButton(onPressed: (){Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (BuildContext context) => CheckOutPage()
                      ));},
                        height: 50.0,
                        minWidth: (MediaQuery.of(context).size.width/2.4).roundToDouble(),//=150
                        child: Text("اشتر الآن",style: TextStyle(fontSize:18.0,),),
                        color: Colors.grey[300],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

class Single_Cart_Product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_pictures;
  final cart_prod_price;
  final cart_prod_details;
  final cart_prod_sizes;
  final cart_prod_size;
  final cart_prod_qty;
  final cart_prod_id;
  final cart_prod_available;

  Single_Cart_Product({
    this.cart_prod_name,
    this.cart_prod_pictures,
    this.cart_prod_price,
    this.cart_prod_details,
    this.cart_prod_sizes,
    this.cart_prod_size,
    this.cart_prod_qty,
    this.cart_prod_id,
    this.cart_prod_available
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: InkWell(
        onTap:
            () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProductDetails(
                    prod_detail_name: cart_prod_name,
                    prod_detail_pictures: cart_prod_pictures,
                    prod_detail_price: cart_prod_price,
                    prod_detail_details: cart_prod_details,
                    prod_detail_sizes: cart_prod_sizes,
                    prod_detail_id: cart_prod_id,
                    prod_detail_available: cart_prod_available,
                  )));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal:15.0,
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width:150.0,
                  height:150.0,
                  child: Hero(
                    tag: cart_prod_name,
                    child: Image.network(cart_prod_pictures[0],
                      width: 150.0,
                      height: 150.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width/15).roundToDouble(),//=30.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height:10.0),
                      Text(cart_prod_name,
                        style: TextStyle(fontSize: 18.0),
                        textDirection: TextDirection.rtl,),
                      SizedBox(height:5.0),
                      Text("$cart_prod_price د.ل",
                          style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18.0),
                          textDirection: TextDirection.rtl),
                      SizedBox(height:5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("الكمية : $cart_prod_qty",
                              style: TextStyle(color: Colors.black54),
                              textDirection: TextDirection.rtl),
                          SizedBox(width:5.0),
                          Text("المقاس : $cart_prod_size",
                              style: TextStyle(color: Colors.black54),
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                      SizedBox(height:10.0),
                      MaterialButton(onPressed: (){
                        _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('cart').doc(cart_prod_id)
                            .delete();
                        },
                        minWidth: 120,
                        child: Text("حذف من السلة",style: TextStyle(fontSize:14.0,),),
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

