import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result extends StatefulWidget {

  final String code;
  final Function() closeScreen;

  const Result({super.key, required this.closeScreen, required this.code});

  @override
  State<Result> createState() => _ResultState();
}

class FirestoreService {
  static Future<String?> getDocumentIdByQrValue(String qrValue) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('sessions').where('qr', isEqualTo: qrValue).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return null;
    }
  }

  static Future<String> getDocumentValue(String? documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('date').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('child') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
  static Future<void> deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('sessions').doc(documentId).delete();
      print("Dokument został pomyślnie usunięty.");
    } catch (e) {
      print("Wystąpił błąd podczas usuwania dokumentu: $e");
    }
  }
  static Future<void> deleteSession(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('date').doc(documentId).delete();
      print("Dokument został pomyślnie usunięty.");
    } catch (e) {
      print("Wystąpił błąd podczas usuwania dokumentu: $e");
    }
  }
}

class _ResultState extends State<Result> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          widget.closeScreen();
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87,)),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          )
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {_checkDocumentByQrValue(context, widget.code);}, child: Text("Show result")),
          ],
        ),
      )
    );
  }
}

Future _checkDocumentByQrValue(BuildContext context, String qr) async {
  void _deleteDocument(BuildContext context, String documentId) async {
    await FirestoreService.deleteDocument(documentId);
  }
  void _deleteSession(BuildContext context, String documentId) async {
    await FirestoreService.deleteSession(documentId);
  }
  String? documentId = await FirestoreService.getDocumentIdByQrValue(qr);
  String? sessionId = qr;
  String? name = await FirestoreService.getDocumentValue(qr);
  if (documentId != null) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("QR poprawny"),
          content: Text("Usunąć sesję: $name?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDocument(context, documentId);
                _deleteSession(context, sessionId);
              },
              child: Text("Tak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Nie"),
            ),
          ],
        );
      },
    );
  } else {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kod QR Niepoprawny"),
          content: Text("Nie znaleziono sesji z podanym kodem QR."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Zamknij"),
            ),
          ],
        );
      },
    );

  }

}

