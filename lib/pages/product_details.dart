import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:qatifa_store/db/cart_service.dart';

import 'package:qatifa_store/components/base_app_bar.dart';

import 'package:qatifa_store/components/add_to_cart_button.dart';

import 'package:carousel_pro/carousel_pro.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class ProductDetails extends StatefulWidget {
  final prod_detail_name;
  final prod_detail_pictures;
  final prod_detail_price;
  final prod_detail_details;
  final prod_detail_sizes;
  final prod_detail_id;
  final prod_detail_available;

  ProductDetails(
      {this.prod_detail_name,
      this.prod_detail_pictures,
      this.prod_detail_price,
      this.prod_detail_details,
      this.prod_detail_sizes,
      this.prod_detail_id,
      this.prod_detail_available
      });


  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

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
    super.initState();
    connectivity();
    widget.prod_detail_sizes[0];
  }

  CartService cartService = CartService();


  String selectedSize ;
  List<String> getDropDownItems(){
    List<String> dropDownItems =[];
    for (String size in widget.prod_detail_sizes){
     String newItem =size;
      dropDownItems.add(newItem);
    }
    dropDownItems.sort();
    return dropDownItems;
  }

  int _quantity = 1;
  void _incrementQuantity() {
    setState(() {
      if (_quantity<10)
        _quantity++;
    });
  }
  void _decrementQuantity() {
    setState(() {
      if (_quantity>1)
        _quantity--;
    });
  }

  List _images=[];

  List getImages(){
    _images.clear();
    for(int i=0 ; i<widget.prod_detail_pictures.length ; i++){
      _images.add(NetworkImage(widget.prod_detail_pictures[i]));
    }
    return _images;
  }


  @override
  Widget build(BuildContext context) {
    return !_connection? Scaffold(
      appBar: BaseAppBar(
        imageSize: 60.0,
        iconsVisibilty: false,
        pageName: 'تفاصيل المُنتج',
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
                  context, MaterialPageRoute(builder: (BuildContext context) => ProductDetails(
                prod_detail_name: widget.prod_detail_name,
                prod_detail_details:widget.prod_detail_details ,
                prod_detail_id:widget.prod_detail_id ,
                prod_detail_price: widget.prod_detail_price,
                prod_detail_pictures: widget.prod_detail_pictures,
                prod_detail_sizes: widget.prod_detail_sizes,
                prod_detail_available: widget.prod_detail_available,
              )
              ));}
          ),
        ],
      )
      ),):
      Scaffold(
        appBar: BaseAppBar(
          imageSize: 60.0,
          iconsVisibilty: false,
          pageName: 'تفاصيل المُنتج',
          appBar: AppBar(),
        ),
      body: ListView(
          children: [
        Container(
          child: Hero(
            tag: widget.prod_detail_name,
              child:
              SizedBox(
                  height: (MediaQuery.of(context).size.width).roundToDouble(),
                  width: (MediaQuery.of(context).size.width).roundToDouble(),
                  child: Carousel(
                    images: getImages(),
                    autoplay: false,
                    dotSize: widget.prod_detail_pictures.length ==1? 0.0 :  (MediaQuery.of(context).size.width/60).roundToDouble(),
                    indicatorBgPadding: widget.prod_detail_pictures.length ==1? 0.0 :  (MediaQuery.of(context).size.width/36).roundToDouble(),
                    dotBgColor: Colors.grey[700].withOpacity(0.3),

                  )
              ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(
              left:  (MediaQuery.of(context).size.width/36).roundToDouble(),
              right:  (MediaQuery.of(context).size.width/36).roundToDouble(),
              top:  (MediaQuery.of(context).size.height/73.933).roundToDouble(),
              bottom: (MediaQuery.of(context).size.height/49.288).roundToDouble(),
          ),
          child:  widget.prod_detail_available?
          Center(
            child: Text(
              widget.prod_detail_details,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16.0),
            ),
          ):
              Center(
                child: Text(
                     "هذا المنتج غير متوفر ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 16.0,color: Colors.red[800]),
                ),
              )
        ),

            SizedBox(
              height: (MediaQuery.of(context).size.height/73.933).roundToDouble(), // =10
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // **********    Select size ***********
             Container(
              // padding: EdgeInsets.all(8.0),
              height:40.0,
              width:(MediaQuery.of(context).size.width/2.667).roundToDouble(),//=135
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xfffdede3),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomDropdownButton2(
                  hint: 'Select Item',
                  dropdownItems: getDropDownItems(),
                  value: selectedSize,
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value;
                    });
                  },
                ),
                  // DropdownButton<String>(
                  // value: selectedSize,
                  // items: getDropDownItems(),
                  // onChanged: (value) {
                  // setState((){
                  // selectedSize=value;
                  // });
                  // },
                  // ),

                  Text("المقاس"),
                  ]),
              ),
            // **********    Select quantity ***********
            Container(
              // padding: EdgeInsets.all(8.0),
                  height:40.0,
              width:(MediaQuery.of(context).size.width/2.667).roundToDouble(),//=135.0
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xfffdede3),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height:(MediaQuery.of(context).size.height/32.14).roundToDouble(),//=23
                        width:(MediaQuery.of(context).size.width/15.65).roundToDouble(), //=23
                        child: FittedBox(
                            child: RawMaterialButton(
                              onPressed: _decrementQuantity,
                              focusColor: Colors.white,
                              elevation: 0.0,
                              fillColor: Colors.black.withOpacity(0.7),
                              child: Icon(Icons.remove ,
                                size: (MediaQuery.of(context).size.width/5.14).roundToDouble(), // =70
                                color: Colors.white,),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            )
                        )),
                    Text("$_quantity"),
                    Container(
                        height:(MediaQuery.of(context).size.height/32.14).roundToDouble(),//=23
                        width:(MediaQuery.of(context).size.width/15.65).roundToDouble(), //=23
                        child: FittedBox(
                            child: RawMaterialButton(
                              onPressed: _incrementQuantity,
                              focusColor: Colors.white,
                              elevation: 0.0,
                              fillColor: Colors.black.withOpacity(0.7),
                              child: Icon(Icons.add ,
                              size: (MediaQuery.of(context).size.width/5.14).roundToDouble(), // =70
                              color: Colors.white,),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            )
                        )),
                    Text("الكمية"),
                  ]),
            )


          ],
        ),
        SizedBox(
          height: (MediaQuery.of(context).size.height/24.64).roundToDouble(), // =30
        ),

        Visibility(
          visible: widget.prod_detail_available,
          child: Center(

            child: AddToCartButton(
              onTap: selectedSize!=null?
                  () {
              cartService.addToCart(
                productName: widget.prod_detail_name,
                price: widget.prod_detail_price,
                images: widget.prod_detail_pictures,
                quantity: _quantity,
                size : selectedSize,
                productID: widget.prod_detail_id,
                sizes: widget.prod_detail_sizes,
                details : widget.prod_detail_details,
                availability : widget.prod_detail_available
              );
              Fluttertoast.showToast(msg: "تمت إضافة المنتج للسلة بنجاح، يمكنك إتمام عملية الشراء من السلة");
              }: () {
                Fluttertoast.showToast(msg: "نرجو منك إضافة المقاس");
              }
            ),
          ),
        ),





      ]),
    );
  }
}










