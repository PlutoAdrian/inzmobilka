import 'package:flutter/material.dart';
import 'package:pluto_apk/User/userhome.dart';

import '../services/database.dart';

class AddWeek extends StatefulWidget {
  final String value;
  final String? globalUID;
  final String id;
  const AddWeek({Key? key, required this.value, required this.globalUID, required this.id}) : super(key: key);

  @override
  State<AddWeek> createState() => _AddWeekState();
}

class _AddWeekState extends State<AddWeek> {
  DateTime? startDate;
  int weeks = 1;
  List<bool> selectedDays = [false, false, false, false, false];
  List<DateTime> generatedDates = [];
  final List<String> daysOfWeek = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Day'),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wybierz dni tygodnia:'),
            ToggleButtons(
              isSelected: selectedDays,
              onPressed: (index) {
                setState(() {
                  selectedDays[index] = !selectedDays[index];
                });
              },
              children: daysOfWeek
                  .map((day) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(day),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),

            Text('Liczba tygodni:'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wpisz liczbę tygodni',
              ),
              onChanged: (value) {
                setState(() {
                  weeks = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 20),

            Text('Data rozpoczęcia:'),
            TextButton(
              onPressed: _selectStartDate,
              child: Text(
                startDate == null
                    ? 'Wybierz datę'
                    : "${startDate!.toLocal()}".split(' ')[0],
              ),
            ),
            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _generateSchedule();
                  },
                child: Text('Dodaj'),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _generateSchedule() async {
    if (startDate == null || weeks <= 0 || !selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uzupełnij wszystkie pola!')),
      );
      return;
    }

    List<DateTime> dates = [];
    DateTime currentDate = startDate!;

    for (int week = 0; week < weeks; week++) {
      for (int i = 0; i < 5; i++) {
        if (selectedDays[i]) {
          DateTime targetDate = currentDate.add(Duration(days: i));
          await DatabaseService().AddDate(targetDate, widget.value, widget.globalUID!, widget.id);
          dates.add(targetDate);
        }
      }
      currentDate = currentDate.add(Duration(days: 7));
    }
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserHome()));
    });
  }

}


