import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/showchild.dart';

class EventList extends StatefulWidget {
  final String id;
  const EventList({super.key, required this.id});

  @override
  State<EventList> createState() => _EventListState();
}



class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista dzieci"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('date').where('event', isEqualTo: widget.id).snapshots(),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowChild(id: data['id'])));
                });},
                title: Text(data['child']),

              );
            }).toList(),
          );
        },
      ),
    );
  }
}
