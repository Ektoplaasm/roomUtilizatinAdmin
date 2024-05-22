import 'package:flutter/material.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    await _firestoreService.addSemester(
      _startDate,
      _semesterNameController.text,
      _endDate,
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
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_box),
              SizedBox(width: 10,),
              Text('Add Semester', style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 300, right: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _semesterNameController,
                  decoration: InputDecoration(
                    labelText: 'Semester Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide()
                    ),
                    prefixIcon: Icon(Icons.date_range),
                    suffixIcon: Icon(Icons.info),

                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Start Date:'),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _selectDate(context, true),
                            child: Text(
                              _formatDate(_startDate),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(' End Date:'),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text(
                            _formatDate(_endDate),
                          ),
                        ),
                      ],
                    ),
                    
                  ]
                ),
                
                SizedBox(height: 20),
                Center(
                  
                  child: ElevatedButton(
                    onPressed: _addSemester,
                    child: Text('Add Semester'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
