import 'package:flutter/material.dart';
import 'package:pluto_apk/User/userhome.dart';

import '../services/database.dart';

class AddDay extends StatefulWidget {
  final String value;
  final String? globalUID;
  final String id;
  const AddDay({super.key, required this.value, required this.globalUID, required this.id,});

  @override
  State<AddDay> createState() => _AddDayState();
}

class _AddDayState extends State<AddDay> {
  @override
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(selectedDate == null
                    ? "Nie wybrano daty"
                    : "${selectedDate!.toLocal()}".split(' ')[0]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showDatePickerDialog,
                  child: const Text('Otwórz kalendarz'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: selectedDate == null ? null : () async {
                  await DatabaseService().AddDate(selectedDate, widget.value, widget.globalUID!, widget.id);
                  selectedDate = null;
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserHome()));
                  });
                  },
                  style: TextButton.styleFrom(
                    shadowColor: selectedDate == null ? null : Colors.grey,
                    backgroundColor: selectedDate == null ? Colors.grey : Colors.white,
                  ),
                  child: const Text('Dodaj'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void _showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      setState((){});
    }
  }
}
