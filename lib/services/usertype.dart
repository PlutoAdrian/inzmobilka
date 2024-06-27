import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserType extends StatelessWidget {
  final String documentId;

  UserType({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Jeżeli dokument istnieje, to pobierz jego dane
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // Tutaj możesz wykonać akcję na pobranych danych
          // np. wyświetlić je w interfejsie użytkownika
          return Text("Wartość pobrana: ${data['type']}");
        }

        return Text("Ładowanie...");
      },
    );
  }
}
