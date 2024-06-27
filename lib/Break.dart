import 'package:flutter/material.dart';
import 'package:pluto_apk/services/auth.dart';

class Break extends StatefulWidget {
  const Break({super.key});

  @override
  State<Break> createState() => _BreakState();
}

class _BreakState extends State<Break> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opps..."),
      ),body: Center(
      child: Column(children: [
        Text("Wystąpił problem z authentykacją użytkownika. Zkontaktuj się z administratorem aby dowiedzieć się więcej."),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () async {
          await _auth.signOut();
        },child: Text("Wyloguj"),),
      ],),
    ),
    );
  }
}
