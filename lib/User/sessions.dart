import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pluto_apk/models/session.dart';
import 'package:pluto_apk/models/session_item.dart';
import 'package:intl/intl.dart';

import '../Worker/edit_event.dart';
import '../global/global.dart';
import '../services/database.dart';
import 'generator.dart';



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
        .where('parent', isEqualTo: globalUID)
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
          title: Text("Wygenerować kod QR?"),
          content: Text("Dla $child"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await DatabaseService().AddSesion(documentId, child, globalUID!);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Generator(code: documentId)));
              },
              child: Text("Tak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Nie"),
            ),
          ],
        );
      },
    );
  }

  List _getEventsForTheDay(DateTime day) {
    return _sessions[day] ?? [];
  }


  Sessions _calendar = Sessions();
  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title:Text('Sesje'),
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
                (session) => SessionItem(
                session: session,
                onTap: () async {
                  _showDocumentValue(context, session.id, session.child);
                },
                onDelete: () async {
                  final delete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Session?"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );

                  if (delete ?? false) {
                    await FirebaseFirestore.instance
                        .collection('date')
                        .doc(session.id)
                        .delete();
                    _loadFirestoreEvents();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
