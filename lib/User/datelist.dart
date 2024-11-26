import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';
import '../services/database.dart';
import 'generator.dart';

class DateList extends StatefulWidget {
  const DateList({super.key});

  @override
  State<DateList> createState() => _DateListState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('date').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('name') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
  static Future<void> deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('date').doc(documentId).delete();
      print("Dokument został pomyślnie usunięty.");
    } catch (e) {
      print("Wystąpił błąd podczas usuwania dokumentu: $e");
    }
  }
}

class _DateListState extends State<DateList> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sessions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('date').where('parent', isEqualTo: globalUID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wystąpił błąd: ${snapshot.error}");
          }
          if (snapshot.data == null){
            return Text("Wystąpił błąd: Null check operator used on a null value");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['child']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDelete(context, document.id);
                  },
                ),
                subtitle: Text(dateFormatter.format(data['date'].toDate()).toString()),
                onTap: (){_showDocumentValue(context, document.id, data['child']);},
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showDocumentValue(BuildContext context, String documentId, String child) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wygenerować kod QR?"),
          content: Text("Dla $child"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddSesion(documentId, child, globalUID!);
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

  void _deleteDocument(BuildContext context, String documentId) async {
    await FirestoreService.deleteDocument(documentId);
  }
}
