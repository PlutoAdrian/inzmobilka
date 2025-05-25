import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/event.dart';
import 'package:pluto_apk/User/navbar.dart';
import 'package:intl/intl.dart';

class Eventlist extends StatefulWidget {
  const Eventlist({super.key});

  @override
  State<Eventlist> createState() => _EventlistState();
}



class _EventlistState extends State<Eventlist> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wystąpił błąd: ${snapshot.error}");
          }
          if (snapshot.data == null){
            return const Text("Wystąpił błąd: Null check operator used on a null value");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Event(id: document.id)));
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
