import 'package:admin_addschedule/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ViewRoomSchedule extends StatefulWidget {
  const ViewRoomSchedule({super.key});

  @override
  State<ViewRoomSchedule> createState() => _ViewRoomScheduleState();
}

class _ViewRoomScheduleState extends State<ViewRoomSchedule> {
  final FirestoreService firestoreService = FirestoreService();
  
  void _showEditDialog(DocumentSnapshot item) {
  print('Dialog opened for item: ${item.id}');
  
  TextEditingController classController = TextEditingController(text: item['class'].toString());
  TextEditingController courseController = TextEditingController(text: item['course'].toString());
  TextEditingController instructorController = TextEditingController(text: item['instructor'].toString());
  
  String? _selectedRoom = item['room_id'].toString();
  String? _selectedDay = item['weekday'].toString(); 
  int selectedValueStart = (item['start_time']) ?? 6; 
  int selectedValueEnd = (item['end_time']) ?? 7; 

  List<int> timeSchedValue = <int>[6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
  List<String> daysOfTheWeek = <String>[
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  List<int> takenTimes = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Schedule'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: classController,
                    decoration: const InputDecoration(labelText: 'Class'),
                  ),
                  TextField(
                    controller: courseController,
                    decoration: const InputDecoration(labelText: 'Course'),
                  ),
                  TextField(
                    controller: instructorController,
                    decoration: const InputDecoration(labelText: 'Instructor'),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: firestoreService.fetchRooms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map<String, dynamic>> rooms = snapshot.data!;
                        return DropdownButtonFormField2<String>(
                          hint: Text("Select a Room"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          value: _selectedRoom,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRoom = newValue;
                            });
                          },
                          items: rooms.map((room) {
                            return DropdownMenuItem(
                              child: Text(room['room_name'].toString()),
                              value: room['room_id'].toString(),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Select a Day",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDay,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDay = newValue;
                      });
                    },
                    items: daysOfTheWeek.map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day[0].toUpperCase() + day.substring(1).toLowerCase()),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: selectedValueStart,
                        items: timeSchedValue.map((int value) {
                          bool isDisabled = takenTimes.contains(value);
                          var displayValue = _getTimeWithPeriod(value);
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              displayValue,
                              style: TextStyle(color: isDisabled ? Colors.grey : Colors.black),
                            ),
                            enabled: !isDisabled,
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null && !takenTimes.contains(newValue)) {
                            setState(() {
                              selectedValueStart = newValue;
                              selectedValueEnd = newValue + 1; 
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text("To"),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: selectedValueEnd,
                        items: timeSchedValue.map((int value) {
                          bool isDisabled = takenTimes.contains(value);
                          var displayValue = _getTimeWithPeriod(value);
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              displayValue,
                              style: TextStyle(color: isDisabled ? Colors.grey : Colors.black),
                            ),
                            enabled: !isDisabled,
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null && !takenTimes.contains(newValue)) {
                            setState(() {
                              selectedValueEnd = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  print('Saving changes for item: ${item.id}');
                  FirebaseFirestore.instance
                      .collection('schedule_details')
                      .doc(item.id)
                      .update({
                        'class': classController.text,
                        'course': courseController.text,
                        'instructor': instructorController.text,
                        'room_id': _selectedRoom,
                        'start_time': selectedValueStart,
                        'end_time': selectedValueEnd,
                        'weekday': _selectedDay, 
                      })
                      .then((_) {
                        print('Update successful for item: ${item.id}');
                        Navigator.of(context).pop();
                      })
                      .catchError((error) {
                        print('Failed to update item: $error');
                      });
                },
              ),
            ],
          );
        },
      );
    },
  );
}

  String? _selectedWeekday;
  List<Map<String, dynamic>> _weekdays = [
    {'id': 'monday', 'name': 'Monday'},
    {'id': 'tuesday', 'name': 'Tuesday'},
    {'id': 'wednesday', 'name': 'Wednesday'},
    {'id': 'thursday', 'name': 'Thursday'},
    {'id': 'friday', 'name': 'Friday'},
    {'id': 'saturday', 'name': 'Saturday'},
    {'id': 'sunday', 'name': 'Sunday'},
  ];

  String _getTimeWithPeriod(int value) {
    return value < 12 ? '$value AM' : '${value == 12 ? 12 : value - 12} PM';
  }

  
  String? _selectedSemester;
  List<Map<String, dynamic>> _semesters = [];
  List<Map<String, dynamic>> _schedules = [];

  @override
    void initState() {
      super.initState();
      _loadSemesters();
      _loadWeekdays();

    }

  void _filterSchedules(String? selectedSemesterId) {
    setState(() {
      _selectedSemester = selectedSemesterId;
    });

    if (selectedSemesterId == 'all') {
      _loadallschedules();
    }
  }

  void _filterWeekdays(String? selectedWeekday) {
  setState(() {
    _selectedWeekday = selectedWeekday;
  });

  if (selectedWeekday == 'all') {
    _loadallschedules();
  }
}

Future<void> _loadWeekdays() async {
  setState(() {
    _weekdays = [
      {'id': 'all', 'name': 'All'},
      ..._weekdays,
    ];
  });
}

  Future<void> _loadSemesters() async {
    List<Map<String, dynamic>> semesters = await firestoreService.fetchSemesters();
    setState(() {
      _semesters = semesters;
    });
  }

  Future<void> _loadallschedules() async {
  List<Map<String, dynamic>> schedules = await firestoreService.fetchSchedule();
  setState(() {
    _schedules = schedules;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.view_compact, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 10),
              const Text("View Schedules", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedSemester,
                hint: const Text('Select Semester'),
                onChanged: _filterSchedules,
                items: [
                  DropdownMenuItem<String>(
                    value: 'all',
                    child: const Text('All'),
                  ),
                  ..._semesters.map((semester) {
                    return DropdownMenuItem<String>(
                      value: semester['id'],
                      child: Text(semester['semester_name']),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedWeekday,
                hint: const Text('Select Day'),
                onChanged: _filterWeekdays,
                items: _weekdays.map((weekday) {
                  return DropdownMenuItem<String>(
                    value: weekday['id'],
                    child: Text(weekday['name']),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: (_selectedSemester == 'all' && _selectedWeekday == 'all')
    ? FirebaseFirestore.instance.collection('schedule_details').snapshots()
    : (_selectedSemester == 'all')
        ? FirebaseFirestore.instance.collection('schedule_details')
            .where('weekday', isEqualTo: _selectedWeekday)
            .snapshots()
        : (_selectedWeekday == 'all')
            ? FirebaseFirestore.instance.collection('schedule_details')
                .where('semester_id', isEqualTo: _selectedSemester)
                .snapshots()
            : FirebaseFirestore.instance.collection('schedule_details')
                .where('semester_id', isEqualTo: _selectedSemester)
                .where('weekday', isEqualTo: _selectedWeekday)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DataCell> displayedDataCell = [];
            List<DataRow> rows = [];

            for (var item in snapshot.data!.docs) {
              displayedDataCell = [
                DataCell(Center(child: Text(item['class'].toString()))),
                DataCell(Center(child: Text(item['course'].toString()))),
                DataCell(Center(child: Text(item['instructor'].toString()))),
                DataCell(Center(child: Text(item['room_id'].toString()))),
                DataCell(Center(child: Text(item['start_time'].toString()))),
                DataCell(Center(child: Text(item['end_time'].toString()))),
                DataCell(Center(child: Text(item['weekday'].toString()))),
                DataCell(
                  Row(
                    children: [
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 42, 92, 150)),
                          ),
                          onPressed: () {
                            _showEditDialog(item);
                          },
                          child: const Icon(Icons.settings, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ];

              rows.add(DataRow(cells: displayedDataCell));
            }

            return Container(
              alignment: Alignment.topCenter,
              child: FittedBox(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Expanded(child: Center(child: Text('Class', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Instructor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Room', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('End Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Day of the Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                        DataColumn(label: Expanded(child: Center(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                      ],
                      rows: rows.map((row) {
                        final rowIndex = rows.indexOf(row);
                        final color = rowIndex.isEven ? Colors.grey[200] : Colors.white;
                        return DataRow(
                          color: MaterialStateColor.resolveWith((states) => color!),
                          cells: row.cells,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}