import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/userhome.dart';

import '../global/global.dart';
import '../services/database.dart';

class EditChild extends StatefulWidget {
  final String value;
  final String? globalUID;
  const EditChild({Key? key, required this.value, required this.globalUID}) : super(key: key);

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {
  String name = '';
  String desc = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchChildData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edycja dziecka')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
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
                  SizedBox(width: 16),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: Text('Dodaj'),
                      ),
                      SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: Text('Usuń'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Imię', helperText: name.isEmpty ? '' : name),
            ),

            SizedBox(height: 5),

            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Opis', helperText: desc.isEmpty ? '' : desc),
              maxLines: 3,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await updateChildData();
                await fetchChildData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dane zostały zapisane')),
                );
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateChildData() async {
    await FirebaseFirestore.instance.collection('children').doc(widget.value).update({
      'name': _nameController.text.trim().isEmpty ? name : _nameController.text.trim(),
      'desc': _descController.text.trim().isEmpty ? desc : _descController.text.trim()
    });
  }

  Future<void> fetchChildData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('children')
        .doc(widget.value)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        desc = data['desc'] ?? '';
      });
    }
  }
}
