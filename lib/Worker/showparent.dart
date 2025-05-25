import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowParent extends StatefulWidget {
  final String id;
  const ShowParent({super.key, required this.id});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rodzic")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Imie",
              style: TextStyle(fontSize: 10),
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Telefon",
              style: TextStyle(fontSize: 10),
            ),

            Text(
              phone,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
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
