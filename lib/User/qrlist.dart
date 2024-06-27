import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import 'generator.dart';

class QRList extends StatefulWidget {
  const QRList({super.key});

  @override
  State<QRList> createState() => _QRListState();
}
class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('sessions').doc(documentId).get();
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

  static Future<void> deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('sessions').doc(documentId).delete();
      print("Dokument został pomyślnie usunięty.");
    } catch (e) {
      print("Wystąpił błąd podczas usuwania dokumentu: $e");
    }
  }
}
class _QRListState extends State<QRList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active QR'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sessions').where('parent', isEqualTo: globalUID).snapshots(),
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDelete(context, document.id);
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Generator(code: data['qr'])));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showDelete(BuildContext context, String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Do you want to delete?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteDocument(context, documentId);
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _showDocumentValue(BuildContext context, String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wartość dokumentu"),
          content: Text(value),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Zamknij"),
            ),
          ],
        );
      },
    );
  }

  void _deleteDocument(BuildContext context, String documentId) async {
    await FirestoreService.deleteDocument(documentId);
  }
}
