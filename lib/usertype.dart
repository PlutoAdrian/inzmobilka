import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Break.dart';
import 'package:pluto_apk/Worker/workhome.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/User/userhome.dart';

import 'home.dart';

class UserType extends StatefulWidget {
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('type') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    getType(globalUID).then((String result){
      setState(() {
        globalType = result;
      });
    });
    switch (globalType){
      case '1':
        return const UserHome();
      case '2':
        return const WorkHome();
      case '3':
        return const Home();
      default:
        return const Break();
    }
  }
  Future<String> getType(documentId) async {
    return await FirestoreService.getDocumentValue(documentId);
  }
}
