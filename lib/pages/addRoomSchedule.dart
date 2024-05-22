import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:admin_addschedule/main.dart';

class AddRoomSchedule extends StatefulWidget {
  const AddRoomSchedule({super.key});

  @override
  State<AddRoomSchedule> createState() => _HomePageState();
}

class _HomePageState extends State<AddRoomSchedule> {
  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  List<int> timeSchedValue = <int>[
    6, 7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18, 19,
  ];
  int selectedValueStart = 6;
  int selectedValueEnd = 6;
  List<ValueItem> dayoftheweek = const <ValueItem>[
    ValueItem(label: 'monday', value: 'monday'),
    ValueItem(label: 'tuesday', value: 'tuesday'),
    ValueItem(label: 'wednesday', value: 'wednesday'),
    ValueItem(label: 'thursday', value: 'thursday'),
    ValueItem(label: 'friday', value: 'friday'),
    ValueItem(label: 'saturday', value: 'saturday'),
    ValueItem(label: 'sunday', value: 'sunday'),
  ];
  List<ValueItem> selectedDays = [];

  final FirestoreService firestoreService = FirestoreService();

  TextEditingController classCode = TextEditingController();
  TextEditingController courseCode = TextEditingController();
  TextEditingController instructor = TextEditingController();
  TextEditingController roomCode = TextEditingController();
  MultiSelectController selecteddayoftheweek = MultiSelectController();

  List<int> takenTimes = [];

  @override
  void initState() {
    super.initState();
    _loadExistingSchedules();
    fetchsemester();
  }

  void _loadExistingSchedules() async {
    List<Map<String, dynamic>> schedDetails = await firestoreService.fetchSchedules();
    setState(() {
      takenTimes = schedDetails.expand((schedDetail) {
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

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                  return DropdownButtonFormField2<String>(
                    hint: Text("Select a Room"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),

                      )
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
                  return DropdownButtonFormField2<String>(
                    hint: Text("Select a Semester"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),

                      )
                    ),
                    value: _selectedSemester,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSemester = newValue;
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
              MultiSelectDropDown(
                controller: selecteddayoftheweek,
                onOptionSelected: (options) {
                  setState(() {
                    selectedDays = options;
                  });
                  
                },
                
                inputDecoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey)
                  
                ),
                
                hint: 'Select the day of the week.',
                hintStyle: TextStyle(fontSize: 17,), 
                
                
                options: dayoftheweek,
                maxItems: 7,
                selectionType: SelectionType.multi,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
              
              SizedBox(height: 15,),

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
                  const SizedBox(width: 10,),
                  const Text("To"),
                  const SizedBox(width: 10,),
               
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
              SizedBox(height: 15,),
              
              ElevatedButton(
                onPressed: () {
                  firestoreService.addSched(
                    classCode.text,
                    courseCode.text,
                    instructor.text,
                    _selectedRoom!,
                    selectedValueStart,
                    selectedValueEnd,
                    selectedDays,
                    _selectedSemester!,
                  );
                },
                child: const Text('Add Schedule'),
              ),
            ],
          ),
        ),
      ),
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
