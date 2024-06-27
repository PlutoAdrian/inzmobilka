import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Break.dart';
import 'package:pluto_apk/User/generator.dart';
import 'package:pluto_apk/Worker/workhome.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/database.dart';
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
        // Jeśli dokument istnieje, zwróć wartość pola 'nazwa_pola'
        return documentSnapshot.get('type') as String;
      } else {
        return ""; // Jeśli dokument nie istnieje, zwróć pusty string
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return ""; // Jeśli wystąpił błąd, zwróć pusty string
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
        return UserHome();
      case '2':
        return WorkHome();
      case '3':
        return Home();
      default:
        return Break();
    }
  }
  Future<String> getType(documentId) async {
    return await FirestoreService.getDocumentValue(documentId);
  }
}
