import 'package:admin_addschedule/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              // clearIcon: true,
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
              // Start Time Dropdown
              DropdownButton<int>(
              value: selectedValueStart,
              items: timeSchedValue.map((int value) {
                var displayString = value.toString();
                if(displayString == '13'){
                  displayString = '1';
                } else if(displayString == '14'){
                  displayString = '2';
                } else if(displayString == '15'){
                  displayString = '3';
                } else if(displayString == '16'){
                  displayString = '4';
                } else if(displayString == '17'){
                  displayString = '5';
                } else if(displayString == '18'){
                  displayString = '6';
                } else if(displayString == '19'){
                  displayString = '7';
                }

                var displayValue ='';
                if(value < 12){displayValue = "$displayString AM";}else{displayValue = "$displayString PM";}
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(displayValue),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedValueStart = newValue ?? selectedValueStart;
                });
              },
            ),
            const SizedBox(width: 10,),
            const Text("To"),
            const SizedBox(width: 10,),
            // End Time Dropdown
            DropdownButton<int>(
              value: selectedValueEnd,
              items: timeSchedValue.map((int value) {
                var displayString = value.toString();
                if(displayString == '13'){
                  displayString = '1';
                } else if(displayString == '14'){
                  displayString = '2';
                } else if(displayString == '15'){
                  displayString = '3';
                } else if(displayString == '16'){
                  displayString = '4';
                } else if(displayString == '17'){
                  displayString = '5';
                } else if(displayString == '18'){
                  displayString = '6';
                } else if(displayString == '19'){
                  displayString = '7';
                }
                var displayValue ='';
                if(value < 12){displayValue = "$displayString AM";}else{displayValue = "$displayString PM";}
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(displayValue),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedValueEnd = newValue ?? selectedValueEnd;
                });
              },
            ),
            ],),   
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
}
