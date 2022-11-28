import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth _auth = FirebaseAuth.instance;

class FavoritesService {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "users";


  void addToFavorite(
      {String productName, double price, List images , String productID, List sizes , String details, bool availability}) {
      _fireStore.collection(ref).doc(_auth.currentUser.uid.toString()).collection('favorites').doc(productID).set({
       'name': productName,
       'id': productID,
       'price': price,
       'images': images,
       'sizes' : sizes,
       'details' : details,
       'available': availability,
     });


  }
}
