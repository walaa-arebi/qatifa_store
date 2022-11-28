import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
DateTime now = DateTime.now();

class OrderService {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref= "Orders";

  void addOrder({String phoneNumber, String secondPhone,String address,String note, Map cart }){
    var id = Uuid();
    String orderID= id.v1();
    _fireStore.collection(ref).doc(orderID).set({
      'phone Number' : phoneNumber,
      'id' : orderID,
      'second phone number' : secondPhone,
      'Address' : address,
      "Notes": note,
      'ordered products' : cart,
      'time': now

    });

    }
}