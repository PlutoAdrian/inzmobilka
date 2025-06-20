import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/addchild.dart';
import 'package:pluto_apk/User/addday.dart';
import 'package:pluto_apk/User/addweek.dart';
import 'package:pluto_apk/User/childevent.dart';
import 'package:pluto_apk/User/editchild.dart';
import 'package:pluto_apk/User/generator.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/database.dart';


class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('children').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('name') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
}

class _ShowListState extends State<ShowList> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista dzieci'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('children').where('parent', isEqualTo: globalUID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wystąpił błąd: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }


          return ListView(
            children:[ ...snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  onTap: () {
                    _showAlert(document.id);
                    //_showDocumentValue(context, document.id);
                  },
                );
            }).toList(),
            ListTile(
              title: Text(
                'Dodaj dziecko',
                style: TextStyle(color: Colors.blue),
              ),
              leading: Icon(Icons.add, color: Colors.blue),
              onTap: () async {setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddChild()));
              });}
            ),
          ],
          );

        },
      ),
    );
  }



  void _showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      setState((){});
    }
  }

  void _showAlertDialog(String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wybierz datę'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedDate == null
                  ? "Nie wybrano daty"
                  : "${selectedDate!.toLocal()}".split(' ')[0]),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showDatePickerDialog,
                child: const Text('Otwórz kalendarz'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DatabaseService().AddDate(selectedDate, value, globalUID!, documentId);
                selectedDate = null;
                Navigator.of(context).pop();
                },
              child: const Text('Dodaj'),
            ),
            TextButton(onPressed:() => Navigator.of(context).pop(), child: const Text('Zamknij'))
          ],
        );
      },
    );
  }

  void _showAlert(String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj sesje'),
          content: Container(
            width: 100,
            height: 300,
            child: ListView(
              children: [
                ListTile(leading: const Icon(Icons.calendar_today),title: const Text('Dzień'),onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddDay(value: value, globalUID: globalUID, id: documentId)));
                });},),
                ListTile(leading: const Icon(Icons.calendar_month),title: const Text('Tydzień'),onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddWeek(value: value, globalUID: globalUID, id: documentId)));
                });},),
                ListTile(leading: const Icon(Icons.event),title: const Text('Event'),onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChildEvent(id: documentId, name: value)));
                });},),
                const Divider(),
                ListTile(leading: const Icon(Icons.edit),title: const Text('Edytuj'),onTap: () async {setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditChild(value: documentId, globalUID: globalUID)));
                });},),
              ],
            ),
          )
        );
      },
    );
  }

  void _showDocumentValue(BuildContext context, String documentId) async {
    String value = await FirestoreService.getDocumentValue(documentId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Wygenerować kod QR?"),
          content: Text("Dla $value"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddSesion(documentId, value, globalUID!);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Generator(code: documentId)));
              },
              child: const Text("Tak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Nie"),
            ),
          ],
        );
      },
    );
  }
}
