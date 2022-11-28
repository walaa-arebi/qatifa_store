import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({@required this.title,@required this.onPressed,@required this.color,@required this.width});
  final Color color;
  final Function onPressed;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 1.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          child: Text(title,
            style:TextStyle(color: Colors.black87,fontSize: 18.0,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}