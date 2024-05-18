import 'package:admin_addschedule/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> timeSchedValue = <String>[
    '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM', 
    '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM',
  ];
  List<String> takenTimes = [];
  String selectedValueStart = '6AM';
  String selectedValueEnd = '6AM';
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

  @override
  void initState() {
    super.initState();
    _loadExistingSchedules();
  }

  void _loadExistingSchedules() async {
    List<Map<String, dynamic>> sched_details = await firestoreService.fetchSchedules();
    setState(() {
      takenTimes = sched_details.expand((sched_detail) {
        return [
          sched_detail['start_time'].toString(),
          sched_detail['end_time'].toString(),
        ];
      }).toList() as List<String>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
      ),
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
            // Start Time Dropdown with time validaiton na siya ma grey if taken
            DropdownButton<String>(
              value: selectedValueStart,
              items: timeSchedValue.map((String value) {
                bool isDisabled = takenTimes.contains(value);
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: isDisabled ? Colors.grey : Colors.black),
                  ),
                  enabled: !isDisabled,
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueStart = newValue ?? selectedValueStart;
                });
              },
            ),

            // End Time Dropdown with time validaiton na siya ma grey if taken
            DropdownButton<String>(
              value: selectedValueEnd,
              items: timeSchedValue.map((String value) {
                bool isDisabled = takenTimes.contains(value);
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: isDisabled ? Colors.grey : Colors.black),
                  ),
                  enabled: !isDisabled,
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEnd = newValue ?? selectedValueEnd;
                });
              },
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
}