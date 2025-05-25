import 'package:flutter/material.dart';
import 'package:pluto_apk/User/addchild.dart';
import 'package:pluto_apk/Worker/showlistwork.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/User/qrlist.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/services/auth.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0.0,
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.exit_to_app),
            label: const Text('logout'),
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
              const Text('Type: '),
              Text(globalType!),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddChild()));
              });},child: const Text("Add a child"),),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowListWork()));
              });},child: const Text("Show list of children"),),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRList()));
              });},child: const Text("Show active QR"),),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRScan()));
              });},child: const Text("Scan QR"),),
              const SizedBox(height: 10,),
            ]
        ),
      )
    );
  }
}
