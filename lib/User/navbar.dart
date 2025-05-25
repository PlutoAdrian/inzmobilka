import 'package:flutter/material.dart';
import 'package:pluto_apk/User/account.dart';
import 'package:pluto_apk/User/qrlist.dart';
import 'package:pluto_apk/User/sessions.dart';
import 'package:pluto_apk/User/showlist.dart';
import 'package:pluto_apk/services/auth.dart';

import 'addchild.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}
final AuthService _auth = AuthService();
class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
              height: 80,
              child: UserAccountsDrawerHeader(accountName: Text('Panel rodzica'), accountEmail: Text(''))),
          ListTile(leading: const Icon(Icons.child_care),title: const Text('Add child'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddChild()));
          });},),
          ListTile(leading: const Icon(Icons.view_list),title: const Text('List of children'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowList()));
          });},),
          ListTile(leading: const Icon(Icons.qr_code),title: const Text('List of QR'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRList()));
          });},),
          ListTile(leading: const Icon(Icons.calendar_today),title: const Text('Sessions'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Sessions()));
          });},),
          const Divider(),
          ListTile(leading: const Icon(Icons.person),title: const Text('Konto'),onTap: () async {setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Account()));
          });},),

          ListTile(leading: const Icon(Icons.exit_to_app),title: const Text('Logout'),onTap: () async {
            await _auth.signOut();
          },),
        ],
      ),

    );
  }
}
