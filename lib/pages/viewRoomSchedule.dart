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
  int selectedValueStart = int.tryParse(item['start_time'].toString()) ?? 6; 
  int selectedValueEnd = int.tryParse(item['end_time'].toString()) ?? 7; 

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

  void _updateTakenTimes() {
    
  }

  List<int> takenTimes = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
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
                      var displayString = _formatTime(value);
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
                      var displayString = _formatTime(value);
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
                    'start_time': selectedValueStart.toString(),
                    'end_time': selectedValueEnd.toString(),
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
}

String _formatTime(int value) {

  return value.toString();
}

String _getTimeWithPeriod(int value) {
  
  return value <= 12 ? '$value AM' : '${value - 12} PM';
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.view_compact, color: Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 10),
              Text("View Schedules", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('schedule_details').snapshots(),
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
