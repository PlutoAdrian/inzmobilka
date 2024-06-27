import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  //collection refrence
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String type) async {
    return await userCollection.doc(uid).set({
      "type": type,
    });
  }

  Future AddAChild(String name, String parent) async {
    return await FirebaseFirestore.instance.collection('children').add({"name" : name, "parent" : parent});
  }

  Future AddSesion(String qr, String name, String parent) async {
    return await FirebaseFirestore.instance.collection('sessions').add({"qr" : qr, "name": name, "parent": parent});
  }


}