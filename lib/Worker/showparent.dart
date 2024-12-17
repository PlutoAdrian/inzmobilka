import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowParent extends StatefulWidget {
  final String id;
  const ShowParent({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowParent> createState() => _ShowParentState();
}

class _ShowParentState extends State<ShowParent> {
  String name = "Ładowanie...";
  String phone = "Ładowanie...";
  @override
  void initState() {
    super.initState();
    fetchParentData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rodzic")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Imie",
              style: TextStyle(fontSize: 10),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Telefon",
              style: TextStyle(fontSize: 10),
            ),

            Text(
              phone,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  Future<void> fetchParentData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? 'Brak';
        phone = data['phone'] ?? 'Brak';
      });
    }
  }
}
