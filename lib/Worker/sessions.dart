import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_apk/Worker/showchild.dart';
import 'package:pluto_apk/models/session_work.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pluto_apk/models/session.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../services/database.dart';



class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Session>> _sessions;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _sessions = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    _sessions.clear();
    final snap = await FirebaseFirestore.instance
        .collection('date')
        .withConverter(
        fromFirestore: Session.fromFirestore,
        toFirestore: (session, options) => session.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final session = doc.data();
      final day = DateTime.utc(session.date.year, session.date.month, session.date.day);
      if (_sessions[day] == null) {
        _sessions[day] = [];
      }
      _sessions[day]!.add(session);
    }
    setState(() {});
  }

  void _showDocumentValue(BuildContext context, String documentId, String child) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Wygenerować kod QR?"),
          content: Text("Dla $child"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddSesion(documentId, child, globalUID!);
                Navigator.of(context).pop();
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Generator(code: documentId)));
              },
              child: const Text("Tak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Nie"),
            ),
          ],
        );
      },
    );
  }

  List _getEventsForTheDay(DateTime day) {
    return _sessions[day] ?? [];
  }


  final Sessions _calendar = const Sessions();
  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title:const Text('Sesje'),
      ),
      body: ListView(
        children: [
          TableCalendar(
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Container(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(dateFormatter.format(day).toString()),
                  );
                }),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              print(_sessions[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          ..._getEventsForTheDay(_selectedDay).map(
                (session) => SessionWork(
                session: session,
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowChild(id: session.child_id)));
                  //_showDocumentValue(context, session.id, session.child);
                },),
          ),
        ],
      ),
    );
  }
}
