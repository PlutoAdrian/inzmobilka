import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/generator.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/database.dart';

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('children').doc(documentId).get();
      if (documentSnapshot.exists) {
        // Jeśli dokument istnieje, zwróć wartość pola 'nazwa_pola'
        return documentSnapshot.get('name') as String;
      } else {
        return ""; // Jeśli dokument nie istnieje, zwróć pusty string
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return ""; // Jeśli wystąpił błąd, zwróć pusty string
    }
  }
}

class _ShowListState extends State<ShowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('children').where('parent', isEqualTo: globalUID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wystąpił błąd: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  onTap: () {
                    _showDocumentValue(context, document.id);
                  },
                );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showDocumentValue(BuildContext context, String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wygenerować kod QR?"),
          content: Text("Dla $value"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddSesion(documentId, value, globalUID!);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Generator(code: documentId)));
              },
              child: Text("Tak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Nie"),
            ),
          ],
        );
      },
    );
  }
}
