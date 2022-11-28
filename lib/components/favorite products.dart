import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qatifa_store/pages/product_details.dart';

class Favorite_Products extends StatefulWidget {

  @override
  _Favorite_ProductsState createState() => _Favorite_ProductsState();
}

class _Favorite_ProductsState extends State<Favorite_Products> {
  //================list of maps for json==================


  var favorite_products = [
    {"name": "فستان مُنقّط", "picture": "images/products/1.jpg", "price": 100,"details":"هذا الفستان من أكثر القطع مبيعا لديينا في قطيفة ، يتميز بقماش خفيف وبارد مناسب للأجواء الصيفية الحارة ، طول الفستان ثلاثة أرباع.",'sizes':['38','40','42','44'],},
    {"name": "فستان بيج", "picture": "images/products/5.jpg", "price": 150,"details":"هذا الفستان من أكثر القطع مبيعا لديينا في قطيفة ، يتميز بقماش خفيف وبارد مناسب للأجواء الصيفية الحارة ، طول الفستان ثلاثة أرباع.",'sizes':['42','44','46','48'],},
    ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: favorite_products.length,
        itemBuilder: (context,index){
          return Single_Favorite_Product(
            favorite_prod_name: favorite_products[index]["name"],
            favorite_prod_picture: favorite_products[index]["picture"],
            favorite_prod_price: favorite_products[index]["price"],
            favorite_prod_details:favorite_products[index]["details"],
            favorite_prod_sizes:favorite_products[index]["sizes"],

          );
        }
    );
  }
}
class Single_Favorite_Product extends StatelessWidget {
  final favorite_prod_name;
  final favorite_prod_picture;
  final favorite_prod_price;
  final favorite_prod_details;
  final favorite_prod_sizes;


  Single_Favorite_Product({
    this.favorite_prod_name,
    this.favorite_prod_picture,
    this.favorite_prod_price,
    this.favorite_prod_details,
    this.favorite_prod_sizes,

  });
  bool isChecked=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: InkWell(
        onTap:  () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetails(
              prod_detail_name: favorite_prod_name,
              prod_detail_pictures: favorite_prod_picture,
              prod_detail_price: favorite_prod_price,
              prod_detail_details:favorite_prod_details ,
              prod_detail_sizes: favorite_prod_sizes,
            ))),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:25 ,horizontal:15.0 ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Hero(
                    tag: favorite_prod_name,
                    child: Image.asset(favorite_prod_picture,
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
                      Text(favorite_prod_name,
                        style: TextStyle(fontSize: 18.0),
                        textDirection: TextDirection.rtl,),
                      Text("$favorite_prod_price د.ل",
                          style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18.0),
                          textDirection: TextDirection.rtl),
                      MaterialButton(onPressed: (){},
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

