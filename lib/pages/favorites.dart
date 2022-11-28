import 'dart:ui';
import 'dart:io';
import 'package:qatifa_store/components/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qatifa_store/pages/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class Favorites extends StatefulWidget {

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

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
    return!_connection? Scaffold(
      appBar: BaseAppBar(
        imageSize: 60.0,
        iconsVisibilty: false,
        pageName: 'المُفضّلة',
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
                    context, MaterialPageRoute(builder: (BuildContext context) => Favorites()
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
        stream: _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('favorites').snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Scaffold(
              appBar: BaseAppBar(
                imageSize: 60.0,
                iconsVisibilty: false,
                pageName: 'المُفضّلة',
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
          final products = snapshot.data.docs;

          List<Single_favorites_Product> favoriteProducts=[];
          for (var product in products){
            final favorites_prod_name = product.data()['name'];
            final favorites_prod_pictures = product.data()["images"];
            final favorites_prod_price = product.data()["price"];
            final favorites_prod_details = product.data()["details"];
            final favorites_prod_id = product.data()["id"];
            final favorites_prod_sizes = product.data()["sizes"];
            final favorites_prod_available = product.data()['available'];

            final singleFavoritesProduct= Single_favorites_Product(
              favorite_prod_name: favorites_prod_name,
              favorite_prod_pictures:favorites_prod_pictures,
              favorite_prod_price:favorites_prod_price,
              favorite_prod_details: favorites_prod_details,
              favorite_prod_id: favorites_prod_id,
              favorite_prod_sizes: favorites_prod_sizes,
              favorite_prod_available : favorites_prod_available
            );
            favoriteProducts.add(singleFavoritesProduct);

          }
          return Scaffold(
            appBar: BaseAppBar(
              imageSize: 60.0,
              iconsVisibilty: false,
              pageName: 'المُفضّلة',
              appBar: AppBar(),
            ),
            backgroundColor: Colors.grey[100],
            body:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                    children: favoriteProducts,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

class Single_favorites_Product extends StatelessWidget {
  final favorite_prod_name;
  final favorite_prod_pictures;
  final favorite_prod_price;
  final favorite_prod_details;
  final favorite_prod_sizes;
  final favorite_prod_id;
  final favorite_prod_available;

  Single_favorites_Product({
    this.favorite_prod_name,
    this.favorite_prod_pictures,
    this.favorite_prod_price,
    this.favorite_prod_details,
    this.favorite_prod_sizes,
    this.favorite_prod_id,
    this.favorite_prod_available
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
                    prod_detail_name: favorite_prod_name,
                    prod_detail_pictures: favorite_prod_pictures,
                    prod_detail_price: favorite_prod_price,
                    prod_detail_details: favorite_prod_details,
                    prod_detail_sizes: favorite_prod_sizes,
                    prod_detail_id: favorite_prod_id,
                    prod_detail_available: favorite_prod_available,
                  )));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:10.0 ,horizontal:15.0 ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  child: Hero(
                    tag: favorite_prod_name,
                    child:Image.network(favorite_prod_pictures[0],
                      width: 150.0,
                      height: 150.0,
                    ),
                  ),
                ),
                SizedBox(width: 30.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height:10.0),
                      Text(favorite_prod_name,
                        style: TextStyle(fontSize: 18.0),
                        textDirection: TextDirection.rtl,),
                      SizedBox(height:5.0),
                      Text("$favorite_prod_price د.ل",
                          style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18.0),
                          textDirection: TextDirection.rtl),
                      SizedBox(height:30.0),
                      MaterialButton(onPressed: (){
                        _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('favorites').doc(favorite_prod_id)
                            .delete();
                      },
                        minWidth: 120.0,
                        child: Text("حذف من المُفضّلة",style: TextStyle(fontSize:14.0,),),
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

