import 'package:flutter/material.dart';
import 'package:pluto_apk/User/addchild.dart';
import 'package:pluto_apk/Worker/showlistwork.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/User/qrlist.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:pluto_apk/User/showlist.dart';

import 'User/generator.dart';
import 'models/user.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0.0,
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text(globalUID!),
              Text('Type: '),
              Text(globalType!),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddChild()));
              });},child: Text("Add a child"),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowListWork()));
              });},child: Text("Show list of children"),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRList()));
              });},child: Text("Show active QR"),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRScan()));
              });},child: Text("Scan QR"),),
              SizedBox(height: 10,),
            ]
        ),
      )
    );
  }
}
