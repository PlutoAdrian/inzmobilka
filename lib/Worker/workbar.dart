import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/Worker/sessions.dart';
import 'package:pluto_apk/Worker/showlistwork.dart';
import 'package:pluto_apk/calendar.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/auth.dart';

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
          ListTile(leading: const Icon(Icons.view_list),title: const Text('List of children'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ShowListWork()));
          });},),
          ListTile(leading: const Icon(Icons.qr_code),title: const Text('Scan QR'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QRScan()));
          });},),
          ListTile(leading: const Icon(Icons.calendar_month),title: const Text('Calendar'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Calendar()));
          });},),
          ListTile(leading: const Icon(Icons.calendar_today),title: const Text('Sessions'),onTap: () async {setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Sessions()));
          });},),
          const Divider(),
          ListTile(leading: const Icon(Icons.exit_to_app),title: const Text('Logout'),onTap: () async {
            await _auth.signOut();
          },),
        ],
      ),
    );
  }
}