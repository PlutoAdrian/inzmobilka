import 'package:flutter/material.dart';
import 'package:pluto_apk/User/account.dart';
import 'package:pluto_apk/User/datelist.dart';
import 'package:pluto_apk/User/qrlist.dart';
import 'package:pluto_apk/User/sessions.dart';
import 'package:pluto_apk/User/showlist.dart';
import 'package:pluto_apk/calendar.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:pluto_apk/settings.dart';

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
          SizedBox(
              height: 80,
              child: UserAccountsDrawerHeader(accountName: Text('Panel rodzica'), accountEmail: Text(''))),
          ListTile(leading: Icon(Icons.child_care),title: Text('Add child'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddChild()));
          });},),
          ListTile(leading: Icon(Icons.view_list),title: Text('List of children'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowList()));
          });},),
          ListTile(leading: Icon(Icons.qr_code),title: Text('List of QR'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRList()));
          });},),
          ListTile(leading: Icon(Icons.calendar_today),title: Text('Sessions'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Sessions()));
          });},),
          Divider(),
          ListTile(leading: Icon(Icons.person),title: Text('Konto'),onTap: () async {setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Account()));
          });},),

          ListTile(leading: Icon(Icons.exit_to_app),title: Text('Logout'),onTap: () async {
            await _auth.signOut();
          },),
        ],
      ),

    );
  }
}
