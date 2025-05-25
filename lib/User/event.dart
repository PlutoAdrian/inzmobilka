import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_apk/User/eventchild.dart';

class Event extends StatefulWidget {
  final String id;
  const Event({super.key, required this.id});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String title = "Ładowanie...";
  String desc = "Ładowanie...";
  String date = "Ładowanie...";

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nazwa",
              style: TextStyle(fontSize: 10),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Data",
              style: TextStyle(fontSize: 10),
            ),

            Text(
              date,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Opis",
              style: TextStyle(fontSize: 10),
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                desc,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EventChild(id: widget.id)));
                });},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Dodaj dziecko"),
              ),
            ),
          ],
        ),
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
        desc = data['description'] ?? '';
        date = dateFormatter.format(data['date'].toDate()).toString() ?? '';
      });
    }
  }
}
