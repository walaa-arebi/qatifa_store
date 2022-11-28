import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = 'users';

  createUser(String uid, Map<String , dynamic> value) {
    _fireStore.collection(ref).doc(uid).set(value);
  }
}
