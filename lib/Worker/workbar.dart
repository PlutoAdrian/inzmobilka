import 'package:flutter/material.dart';
import 'package:pluto_apk/User/qrlist.dart';
import 'package:pluto_apk/User/showlist.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/Worker/showlistwork.dart';
import 'package:pluto_apk/calendar.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:pluto_apk/settings.dart';

class WorkBar extends StatefulWidget {
  const WorkBar({super.key});

  @override
  State<WorkBar> createState() => _WorkBarState();
}
final AuthService _auth = AuthService();
class _WorkBarState extends State<WorkBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
              height: 120,
              child: UserAccountsDrawerHeader(accountName: Text(globalUID!), accountEmail: Text(globalEmail!))),
          ListTile(leading: Icon(Icons.view_list),title: Text('List of children'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowListWork()));
          });},),
          ListTile(leading: Icon(Icons.qr_code),title: Text('Scan QR'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRScan()));
          });},),
          ListTile(leading: Icon(Icons.calendar_month),title: Text('Calendar'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Calendar()));
          });},),
          Divider(),
          ListTile(leading: Icon(Icons.settings),title: Text('Settings'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Settings()));
          });},),
          ListTile(leading: Icon(Icons.exit_to_app),title: Text('Logout'),onTap: () async {
            await _auth.signOut();
          },),
        ],
      ),
    );
  }
}