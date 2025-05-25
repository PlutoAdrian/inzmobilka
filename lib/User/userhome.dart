import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/User/account.dart';
import 'package:pluto_apk/User/event.dart';
import 'package:pluto_apk/User/eventlist.dart';
import 'package:pluto_apk/User/navbar.dart';
import 'package:intl/intl.dart';
import 'package:pluto_apk/User/sessions.dart';
import 'package:pluto_apk/User/showlist.dart';

import '../services/auth.dart';
import 'qrlist.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}


final AuthService _auth = AuthService();
class _UserHomeState extends State<UserHome> {
  var h, w;

  final dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    List wid = [
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowList()));
        });},
        child: Column(
            children: [
              Icon(Icons.child_care,size: 100,),
              Text("Moje dzieci",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRList()));
        });},
        child: Column(
            children: [
              Icon(Icons.qr_code,size: 100,),
              Text("Lista QR",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Eventlist()));
        });},
        child: Column(
            children: [
              Icon(Icons.event,size: 100,),
              Text("Wydarzenia",style: TextStyle(color: Colors.black, fontSize: 20))
            ]
        ),
      ),
      GestureDetector(
        onTap: () async {setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Sessions()));
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Account()));
        });},
        child: Column(
            children: [
              Icon(Icons.settings,size: 100,),
              Text("Moje konto",style: TextStyle(color: Colors.black, fontSize: 20))
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
                      child: Text("Panel opiekuna", style: TextStyle(color: Colors.white, fontSize: 50,),)),
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
