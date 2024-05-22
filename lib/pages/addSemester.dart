import 'package:flutter/material.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:intl/intl.dart';

class Semester extends StatefulWidget {
  const Semester({Key? key}) : super(key: key);

  @override
  State<Semester> createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  late TextEditingController _semesterNameController;
  late DateTime _startDate;
  late DateTime _endDate;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _semesterNameController = TextEditingController();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  void dispose() {
    _semesterNameController.dispose();
    super.dispose();
  }

  Future<void> _addSemester() async {
    final String formattedStartDate = _formatDate(_startDate);
    final String formattedEndDate = _formatDate(_endDate);

    await _firestoreService.addSemester(
      formattedStartDate,
      _semesterNameController.text,
      formattedEndDate,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semester added successfully')),
    );
    
    _semesterNameController.clear();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy \'at\' hh:mm:ss a \'UTC\'Z');
    final String formattedDate = formatter.format(date.toLocal());
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Semester'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _semesterNameController,
              decoration: InputDecoration(labelText: 'Semester Name'),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text('Start Date:'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    _formatDate(_startDate),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text('End Date:'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    _formatDate(_endDate),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSemester,
              child: Text('Add Semester'),
            ),
          ],
        ),
      ),
    );
  }
}
