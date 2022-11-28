import 'dart:ui';
import 'dart:io';

import 'package:qatifa_store/components/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:qatifa_store/pages/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatifa_store/db/favorites_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


final _fireStore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
FavoritesService favoritesService = FavoritesService();



class ProductsPage extends StatefulWidget {

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

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
    super.initState();
    ProductsStream().favoritesStream();
    connectivity();
  }

  @override
  Widget build(BuildContext context) {
    return !_connection? Scaffold(
      appBar: BaseAppBar(
        imageSize: 70.0,
        iconsVisibilty: true,
        pageName: '',
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
                      context, MaterialPageRoute(builder: (BuildContext context) => ProductsPage()
                  ));}
            ),
          ],
        )
    ),):
      ProductsStream();
  }
}

class ProductsStream extends StatelessWidget {

    List favorites=[];

  void favoritesStream() async{
    await for(var snapshot in _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('favorites').snapshots()){
       favorites.clear();
      for(var favorite in snapshot.docs){
        favorites.add(favorite.data());
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map <String,dynamic>>>(
      stream: _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('favorites').snapshots(),
        builder: (context,snapshot){
        return StreamBuilder<QuerySnapshot<Map <String,dynamic>>>(
            stream: _fireStore.collection('products').snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Scaffold(
                  appBar: BaseAppBar(
                    imageSize: 70.0,
                    iconsVisibilty: true,
                    pageName: '',
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

              favoritesStream();

              final products = snapshot.data.docs;
              List<Single_prod> products_list=[];
              for (var product in products){
                final prod_name = product.data()['name'];
                final prod_pictures = product.data()["images"];
                final prod_price = product.data()["price"];
                final prod_details = product.data()["details"];
                final prod_id = product.data()["id"];
                final prod_sizes = product.data()["sizes"];
                final prod_availability =product.data()['available'];

                bool liked =false;
                for (int i=0 ; i<favorites.length; i++){
                  if(prod_id==favorites[i]['id']){
                    liked = true;
                  }
                }

                final singleProduct= Single_prod(
                  prod_name: prod_name,
                  prod_pictures: prod_pictures,
                  prod_price: prod_price,
                  prod_details: prod_details,
                  prod_id: prod_id,
                  prod_sizes: prod_sizes,
                  prod_liked : liked,
                  prod_available : prod_availability,
                );
                products_list.add(singleProduct);

              }
              return Scaffold(
                  appBar: BaseAppBar(
                    imageSize: 70.0,
                    iconsVisibilty: true,
                    pageName: '',
                    appBar: AppBar(),
                  ),
                  backgroundColor: Colors.grey[100],
                  body:GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width >500.0?
                    3:2,
                    children: products_list,
                  )

              );
            }
        );
        }
    );

  }
}

class Single_prod extends StatefulWidget {
  final prod_name;
  final prod_pictures;
  final prod_price;
  final prod_details;
  final prod_sizes;
  final prod_id;
  bool prod_liked;
  final prod_available;

  Single_prod({this.prod_name, this.prod_pictures, this.prod_price, this.prod_details,this.prod_sizes, this.prod_id, this.prod_liked,this.prod_available});

  @override
  _Single_prodState createState() => _Single_prodState();
}

class _Single_prodState extends State<Single_prod> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: widget.prod_name,
        child: Material(
          child: InkWell(
            onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      prod_detail_name: widget.prod_name,
                      prod_detail_pictures: widget.prod_pictures,
                      prod_detail_price: widget.prod_price,
                      prod_detail_details:widget.prod_details ,
                      prod_detail_sizes: widget.prod_sizes,
                      prod_detail_id: widget.prod_id,
                      prod_detail_available:widget.prod_available,
                    )));},
            child: GridTile(
              footer: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    children: [
                      !widget.prod_liked?
                      IconButton(
                          icon: Icon(Icons.favorite_border, color: Colors.grey[800]),
                          onPressed: () {
                            favoritesService.addToFavorite(
                              productName: widget.prod_name,
                              price: widget.prod_price,
                              images: widget.prod_pictures,
                              productID: widget.prod_id,
                              sizes: widget.prod_sizes,
                              details : widget.prod_details,
                              availability : widget.prod_available,
                            );
                          }):
                      IconButton(
                          icon: Icon(Icons.favorite, color: Colors.grey[800]),
                          onPressed: () {
                            _fireStore.collection('users').doc(_auth.currentUser.uid.toString()).collection('favorites').doc(widget.prod_id)
                                .delete();
                          }),
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.prod_name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.rtl),
                              Text("${widget.prod_price} د.ل",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                  textDirection: TextDirection.rtl)
                            ]),
                      ),
                    ],
                  )),
              child:
              Image.network( widget.prod_pictures[0],
                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                  return Center(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("أنت غير متصل بالانترنت ",style:TextStyle(fontSize: 14.0),textDirection: TextDirection.rtl,),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.black),
                        onPressed: (){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> ProductsPage()),ModalRoute.withName("/pages/products_page"));},

                      ),
                    ],
                  )
                  );
                },
              ),

            ),
          ),
        ),
      ),
    );
  }
}
