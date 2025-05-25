import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class EditChild extends StatefulWidget {
  final String value;
  final String? globalUID;
  const EditChild({super.key, required this.value, required this.globalUID});

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {
  String name = '';
  String desc = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edycja dziecka')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey[300],
                      child: const Text(
                        'Placeholder',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: const Text('Dodaj'),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {

                        },
                        child: const Text('Usuń'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Imię', helperText: name.isEmpty ? '' : name),
            ),

            const SizedBox(height: 5),

            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Opis', helperText: desc.isEmpty ? '' : desc),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await updateChildData();
                await fetchChildData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dane zostały zapisane')),
                );
              },
              child: const Text('Zapisz'),
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
