import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceUtil {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');
}
