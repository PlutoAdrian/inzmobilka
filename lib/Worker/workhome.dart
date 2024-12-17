import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/workbar.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:intl/intl.dart';

import 'eventlist.dart';

class WorkHome extends StatefulWidget {
  const WorkHome({super.key});

  @override
  State<WorkHome> createState() => _WorkHomeState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('events').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('title') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
}

class _WorkHomeState extends State<WorkHome> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  final AuthService _auth = AuthService();
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: WorkBar(),
      appBar: AppBar(
        title: Text("Worker"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wystąpił błąd: ${snapshot.error}");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EventList(id: document.id)));
                });},
                title: Text(data['title']),
                subtitle: Text(dateFormatter.format(data['date'].toDate()).toString()),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
