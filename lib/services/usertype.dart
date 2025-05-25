import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserType extends StatelessWidget {
  final String documentId;

  const UserType({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Wartość pobrana: ${data['type']}");
        }
        return const Text("Ładowanie...");
      },
    );
  }
}
