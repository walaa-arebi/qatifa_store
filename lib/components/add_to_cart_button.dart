import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final Function onTap;
  AddToCartButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Container(
         height:40.0,
          width:(MediaQuery.of(context).size.width/2.25).roundToDouble(),//=160.0
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xfffdede3),
          ),
          child: Center(child: Text("إضافة لسلة المشتريات"))
      ),
    );
  }
}

