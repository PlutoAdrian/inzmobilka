import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/event.dart';
import 'package:pluto_apk/User/navbar.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../services/database.dart';

class ChildEvent extends StatefulWidget {
  final String id;
  final String name;
  const ChildEvent({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  State<ChildEvent> createState() => _ChildEventState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('children').doc(documentId).get();
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
}

class _ChildEventState extends State<ChildEvent> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
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
                onTap: (){_showDocumentValue(context, document.id, data['date'],data['title']);},
                title: Text(data['title']),
                subtitle: Text(dateFormatter.format(data['date'].toDate()).toString()),

              );
            }).toList(),
          );
        },
      ),
    );
  }
  void _showDocumentValue(BuildContext context, String documentId, Timestamp date, String title) async {
    String value = widget.name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Czy dodać $value"),
          content: Text("Do $title"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddEventDate(widget.id, value, globalUID!, date.toDate(), documentId);
                Navigator.of(context).pop();
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
