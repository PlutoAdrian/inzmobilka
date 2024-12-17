import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/generator.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/database.dart';

class EventChild extends StatefulWidget {
  final String id;
  const EventChild({Key? key, required this.id}) : super(key: key);

  @override
  State<EventChild> createState() => _EventChildState();
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

class _EventChildState extends State<EventChild> {
  String title = '';
  Timestamp? date;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
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
  Future<void> fetchEventData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.id)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        title = data['title'] ?? '';
        date = data['date'];
      });
    }
  }

  void _showDocumentValue(BuildContext context, String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Czy dodać $value"),
          content: Text("Do $title"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddEventDate(documentId, value, globalUID!, date!.toDate(), widget.id);
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
