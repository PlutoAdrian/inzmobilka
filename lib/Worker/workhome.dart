import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/Worker/sessions.dart';
import 'package:pluto_apk/Worker/showlistwork.dart';
import 'package:pluto_apk/Worker/workevent.dart';
import 'package:pluto_apk/calendar.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:intl/intl.dart';


class WorkHome extends StatefulWidget {
  const WorkHome({super.key});

  @override
  State<WorkHome> createState() => _WorkHomeState();
}

class FirestoreService {
  static Future<String> getDocumentValue(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('events').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get('title') as String;
      } else {
        return "";
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
      return "";
    }
  }
}

class _WorkHomeState extends State<WorkHome> {
  var h, w;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    List wid = [
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowListWork()));
        });},
        child: Column(
            children: [
              Icon(Icons.child_care,size: 100,),
              Text("Lista dzieci",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRScan()));
        });},
        child: Column(
            children: [
              Icon(Icons.qr_code,size: 100,),
              Text("Skaner QR",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Eventlist()));
        });},
        child: Column(
            children: [
              Icon(Icons.calendar_view_day,size: 100,),
              Text("Wydarzenia",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Calendar()));
        });},
        child: Column(
            children: [
              Icon(Icons.calendar_month,size: 100,),
              Text("Kalendarz",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Sessions()));
        });},
        child: Column(
            children: [
              Icon(Icons.event,size: 100,),
              Text("Sesje",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {await _auth.signOut();},
        child: Column(
            children: [
              Icon(Icons.exit_to_app,size: 100,),
              Text("Wyloguj",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
    ];
    return Scaffold(
        body: Container(
          color: Colors.blue,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h*0.06,),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text("Panel pracownika", style: TextStyle(color: Colors.white, fontSize: 45,),)),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.blue
                ),
                height: h*0.20,
                width: w,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50)
                  ),
                ),
                height: h*0.80,
                width: w,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.1,mainAxisSpacing: 25,),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){},
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [
                                    Colors.white,
                                    Colors.white38,
                                  ]
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    spreadRadius: 1,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [wid[index]],
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        )
    );
  }
}
