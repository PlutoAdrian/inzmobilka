import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';


class Account extends StatefulWidget {
  const Account({super.key});


  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String name = '';
  String phone = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My profile"),
        //actions: <Widget>[
        // ElevatedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));}, icon: Icon(Icons.arrow_back), label: Text('Home'))
        //],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nazwa', helperText: name.isEmpty ? '' : name),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText:'Telefon', helperText: phone.isEmpty ? '' : phone),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await updateUserData();
                await fetchUserData();
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
      );
  }

  Future<void> updateUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(globalUID).update({
      'name': _nameController.text.trim().isEmpty ? name : _nameController.text.trim(),
      'phone': _phoneController.text.trim().isEmpty ? phone : _phoneController.text.trim()
    });
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(globalUID)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        phone = data['phone'] ?? '';
      });
    }
  }
}



