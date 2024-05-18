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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule')),
      drawer: const DrawerCustom(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: classCode,
              decoration: const InputDecoration(
                hintText: 'Enter Class Code',
              ),
            ),
            TextField(
              controller: courseCode,
              decoration: const InputDecoration(
                hintText: 'Enter Course Code',
              ),
            ),
            TextField(
              controller: instructor,
              decoration: const InputDecoration(
                hintText: 'Enter Instructor Name',
              ),
            ),
            TextField(
              controller: roomCode,
              decoration: const InputDecoration(
                hintText: 'Enter Room Code',
              ),
            ),
            MultiSelectDropDown(
              controller: selecteddayoftheweek,
              onOptionSelected: (options) {
                setState(() {
                  selectedDays = options;
                });
              },
              options: dayoftheweek,
              maxItems: 7,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start Time Dropdown with disabled na time if selected na
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
                // End Time Dropdown with disabled na time if selected na
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
            ElevatedButton(
              onPressed: () {
                firestoreService.addSched(
                  classCode.text,
                  courseCode.text,
                  instructor.text,
                  roomCode.text,
                  selectedValueStart,
                  selectedValueEnd,
                  selectedDays,
                );
              },
              child: const Text('Add Schedule to Firebase'),
            ),
          ],
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
