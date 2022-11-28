import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';


FirebaseAuth _auth = FirebaseAuth.instance;

class CartService {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "users";


  void addToCart(
      {String productName, double price, List images, String size, int quantity , String productID, List sizes , String details, bool availability}) {

    var id = Uuid();
    String productID2= id.v1();

    _fireStore.collection(ref).doc(_auth.currentUser.uid.toString()).collection('cart').doc(productID+productID2).set({
        'name': productName,
        'id': productID+productID2,
        'price': price,
        'images': images,
        'size': size,
        'quantity': quantity,
        'sizes' : sizes,
        'details' : details,
        'available' : availability,
        });

  }
}
