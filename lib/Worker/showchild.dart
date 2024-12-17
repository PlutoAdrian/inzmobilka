import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/showparent.dart';

class ShowChild extends StatefulWidget {
  final String id;
  const ShowChild({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowChild> createState() => _ShowChildState();
}

class _ShowChildState extends State<ShowChild> {
  String name = "Ładowanie...";
  String desc = "Ładowanie...";
  String parent = '';
  @override

  void initState() {
    super.initState();
    fetchChildData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dziecko')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      color: Colors.grey[300],
                      child: Text(
                        'Placeholder',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 4000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Imie",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 18),
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
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowParent(id: parent)));
              });},
              child: Text('Rodzic'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchChildData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('children')
        .doc(widget.id)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        desc = data['desc'] ?? 'Brak';
        parent = data['parent'] ?? '';
      });
    }
  }
}
