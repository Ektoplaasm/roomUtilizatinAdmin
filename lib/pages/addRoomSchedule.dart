import 'package:admin_addschedule/themes/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:admin_addschedule/main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:quiver/iterables.dart';

class AddRoomSchedule extends StatefulWidget {
  const AddRoomSchedule({super.key});

  @override
  State<AddRoomSchedule> createState() => _HomePageState();
}

class _HomePageState extends State<AddRoomSchedule> {
  final formKey = new GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  List<int> timeSchedValue = <int>[
    6, 7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18, 19,
  ];
  int selectedValueStart = 6;
  int selectedValueEnd = 6;
  List<ValueItem> dayoftheweek = const <ValueItem>[
    ValueItem(label: 'Monday', value: 'monday'),
    ValueItem(label: 'Tuesday', value: 'tuesday'),
    ValueItem(label: 'Wednesday', value: 'wednesday'),
    ValueItem(label: 'Thursday', value: 'thursday'),
    ValueItem(label: 'Friday', value: 'friday'),
    ValueItem(label: 'Saturday', value: 'saturday'),
    ValueItem(label: 'Sunday', value: 'sunday'),
  ];
  List<String> daysoftheweek = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday'];
  List<ValueItem> selectedDays = [];

  final FirestoreService firestoreService = FirestoreService();

  TextEditingController classCode = TextEditingController();
  TextEditingController courseCode = TextEditingController();
  TextEditingController instructor = TextEditingController();
  TextEditingController roomCode = TextEditingController();
  MultiSelectController selecteddayoftheweek = MultiSelectController();

  List<int> takenTimes = [];
  var chunks = [];

  
  @override
  void initState() {
    super.initState();
    _loadExistingSchedules(null, null, null);
    fetchsemester();
  }

  // start time => disabled <= end time

  void _loadExistingSchedules(roomId, semId, day) async {
    List<Map<String, dynamic>>? schedDetails = await firestoreService.fetchSchedules(roomId, semId, day);
    setState(() {
      takenTimes = schedDetails!.expand((schedDetail) {
        return [
          schedDetail['start_time'] as int,
          schedDetail['end_time'] as int,
        ];
      }).toList();
    });
  }

  void fetchsemester() async {
    List<Map<String, dynamic>> listofsemester = await firestoreService.fetchSemester();
    ((List<Map<String, dynamic>> semesters) {
      setState(() {
        
        _dropdownMenuItems.add(DropdownMenuItem(child: Text('Select a Semester'), value: null));
        for (var semester in semesters) {
          _dropdownMenuItems.add(DropdownMenuItem(
            child: Text(semester['semester_name']), 
            value: semester['id'],
          ));
        }
      });
    });
  }

  void fetchroom() async {
    List<Map<String, dynamic>> listofsemester = await firestoreService.fetchRooms();
    ((List<Map<String, dynamic>> rooms) {
      setState(() {
        _dropdownMenuItems.add(DropdownMenuItem(child: Text('Select a Room'), value: null));
        for (var room in rooms) {
          _dropdownMenuItems.add(DropdownMenuItem(
            child: Text(room['room_name']),
            value: room['room_id'],
          ));
        }
      });
    });
  }

  String? _selectedSemester;
  String? _selectedRoom;
  String? _selectedDay;
  List liststart = [];
  List listEnd = [];
  bool allowConflicts = false;

  @override
  Widget build(BuildContext context) {
    print(_selectedDay);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_box),
              SizedBox(width: 10,),
              const Text('Add Schedule', style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        )),
      body: 
      Form(
      key: formKey,
      child: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 300, right: 300),
          child: Column(
            children: [
              TextField(
                controller: classCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                  hintText: 'Enter Class Code',
                  prefixIcon: Icon(Icons.class_),
                  suffixIcon: Icon(Icons.info),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: courseCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue
                    )
                  ),
                  hintText: 'Enter Course Code',
                  prefixIcon: Icon(Icons.school),
                  suffixIcon: Icon(Icons.info),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: instructor,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue
                    ),
                  ),
                  hintText: 'Enter Instructor Name',
                  prefixIcon: Icon(Icons.badge),
                  suffixIcon: Icon(Icons.info),
                ),
              ),
              SizedBox(height: 15,),
              FutureBuilder<List<Map<String, dynamic>>>(
              future: firestoreService.fetchRooms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  
                  return Text('Error: ${snapshot.error}');
                } else {
                  
                  List<Map<String, dynamic>> rooms = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: "Select Room" ,
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 17,),
                      prefixIcon: Icon(Icons.sensor_door_rounded)

                    ),
                    value: _selectedRoom,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRoom = newValue;
                        _loadExistingSchedules(newValue, _selectedSemester, _selectedDay);
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
              SizedBox(height: 15,),
              FutureBuilder<List<Map<String, dynamic>>>(
              future: firestoreService.fetchSemester(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                 
                  return Text('Error: ${snapshot.error}');
                } else {
               
                  List<Map<String, dynamic>> semesters = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: "Select a Semester" ,
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 17,),
                      prefixIcon: Icon(Icons.lock_clock_rounded)
                    ),
                    borderRadius: BorderRadius.circular(5),

                    value: _selectedSemester,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSemester = newValue;
                        _loadExistingSchedules(_selectedRoom, newValue, _selectedDay);
                      });
                    },
                    items: semesters.map((semester) {
                      return DropdownMenuItem(
                        child: Text(semester['semester_name'].toString()),
                        value: semester['id'].toString(),
                      );
                    }).toList(),
                  );
                  
                }
              },
              ),

              SizedBox(height: 15,),
              DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: "Select a Day" ,
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 17,),
                      prefixIcon: Icon(Icons.lock_clock_rounded)
                    ),
                    borderRadius: BorderRadius.circular(5),
                    value: _selectedDay,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDay = newValue;
                        _loadExistingSchedules(_selectedRoom, _selectedSemester, newValue);
                      });
                    },
                    items: daysoftheweek.map((val) {
                      return DropdownMenuItem(
                        child: Text(val[0].toUpperCase() + val.substring(1).toLowerCase()),
                        value: val,
                      );
                    }).toList(),
                  ),
              
              
              SizedBox(height: 15,),

              Container(
              
              child: Column(
                children: [
                  
                  CheckboxListTile(
                    title: Row(
                      children: [
                        PhosphorIcon(PhosphorIconsFill.warning, color: Colors.red,),
                        SizedBox(width: 5,),
                        Text('Allow conflicting time', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    value: allowConflicts,
                    onChanged: (bool? value) {
                      setState(() {
                        allowConflicts = value!;
                      });
                    },
                  ),
                ],
              ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0), 
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<int>(
                        underline: SizedBox(),
                        value: selectedValueStart,
                        items: timeSchedValue.map((int value) {
                          if (takenTimes.isNotEmpty) {
                            var pairs = partition(takenTimes, 2);
                            for (List<int> pair in pairs) {
                              var timeSlots = List.generate(pair.elementAt(1) - pair.elementAt(0), (i) => pair.elementAt(1) - (i + 1));
                              liststart.addAll(timeSlots);
                            }
                          }
                          bool isDisabled = liststart.contains(value) && !allowConflicts;
                      
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
                          if (newValue != null && (!liststart.contains(newValue) || allowConflicts)) {
                            setState(() {
                              selectedValueStart = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("To", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0), 
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<int>(
                        underline: SizedBox(),
                        value: selectedValueEnd,
                        items: timeSchedValue.map((int value) {
                          if (takenTimes.isNotEmpty) {
                            var pairs = partition(takenTimes, 2);
                            for (List<int> pair in pairs) {
                              var timeSlots = List.generate(pair.elementAt(1) - pair.elementAt(0), (i) => pair.elementAt(1) - (i + 1));
                              listEnd.addAll(timeSlots);
                            }
                          }
                          bool isDisabled = listEnd.contains(value) && !allowConflicts;
                      
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
                          if (newValue != null && (!listEnd.contains(newValue) || allowConflicts)) {
                            setState(() {
                              selectedValueEnd = newValue;
                          });
                        }
                      },
                                        ),
                    ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                ElevatedButton(
                onPressed: () {
                  firestoreService.addSched(
                    classCode.text,
                    courseCode.text,
                    instructor.text,
                    _selectedRoom!,
                    selectedValueStart,
                    selectedValueEnd,
                    _selectedDay,
                    _selectedSemester!,
                  ).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Schedule added successfully!'),
                      ),
                    );

                    formKey.currentState!.reset();
                    classCode.clear();
                    courseCode.clear();
                    instructor.clear();
                    setState(() {
                      _selectedRoom = null;
                      _selectedDay = null;
                      _selectedSemester = null;
                      takenTimes = [];
                      selectedValueStart = 6;
                      selectedValueEnd = 6;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white,),
                      SizedBox(width: 5,),
                      const Text('Add Schedule', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              ElevatedButton(onPressed: (){
                formKey.currentState!.reset();
                classCode.clear();
                courseCode.clear();
                instructor.clear();
                _selectedRoom = null;
                _selectedDay = null;
                _selectedSemester = null;
                takenTimes = [];
                selectedValueStart = 6;
                selectedValueEnd = 6;
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cleared!'),
                      ),
                    );
                  };
                }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
              child: Container(child: Row(
                children: [
                  Icon(Icons.clear, color: Colors.white,),
                  SizedBox(width: 5,),
                  const Text('Clear Form', style: TextStyle(color: Colors.white),),
                ],
              )))
              ],)
              
            ],
          ),
        ),
      ),

      )
      
    );
  }

  String _formatTime(int value) {
    if (value >= 13 && value <= 19) {
      return (value - 12).toString();
    }
    return value.toString();
  }

  String _getTimeWithPeriod(int value) {
    String period = value < 12 ? 'AM' : 'PM';
    return "${_formatTime(value)} $period";
  }
  
}
