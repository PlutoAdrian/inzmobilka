import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  final String id;
  const Event({Key? key, required this.id}) : super(key: key);

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nazwa",
              style: TextStyle(fontSize: 10),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Data",
              style: TextStyle(fontSize: 10),
            ),

            Text(
              date,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Opis",
              style: TextStyle(fontSize: 10),
            ),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                desc,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {

                },
                child: Text("Dodaj dziecko"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                ),
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
