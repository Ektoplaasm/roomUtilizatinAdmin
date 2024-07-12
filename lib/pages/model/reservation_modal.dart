import 'dart:async';

import 'package:admin_addschedule/pages/model/reservations.dart';
import 'package:admin_addschedule/pages/model/room.dart';
import 'package:admin_addschedule/pages/model/schedule.dart';
import 'package:admin_addschedule/pages/model/semester.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationModal extends StatefulWidget {
  @override
  RoomSelectionWidgetState createState() => RoomSelectionWidgetState();
}

class RoomSelectionWidgetState extends State<ReservationModal> {
  late Future<List<Room>> futureRooms;
  String? selectedRoomId;
  late DateTime _selectedDate = DateTime.now();
  late String formattedDate = DateFormat('MMMM dd,yyyy').format(_selectedDate);
  final ID = TextEditingController();
  final Name = TextEditingController();
  List<Map<String, dynamic>> listOfTuples = [];
  ValueNotifier<List<Map<String, dynamic>>> endlistOfTuplesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  late String startTimeMessage = "Select Start Time";
  late String endTimeMessage = "Select End Time";

  late TextEditingController idController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController reasonController = TextEditingController();
  late int startTime;
  late int? endTime;
  late DateTime date;
  late String roomID;

  Future<void> submit() async {
  bool exist = false;
  Semester? latestSemester = await Semester.fetchLatestSemester();
  print(latestSemester?.id);

  List<Schedule_Details> schedules =
      await Schedule_Details.getSchedulesBySemester(latestSemester?.id ?? "");

  for (var schedule in schedules) {
    print("test: ${schedules}, time: ${schedule.end_time}");
    if (schedule.weekdays.contains(getDayName(date)) &&
        schedule.room_id == roomID &&
        !((startTime >= schedule.end_time) || (endTime! <= schedule.start_time))) {
      exist = true;
      break;
    }
  }

  if (!exist) {
    Reservation reservation = Reservation(
      idController.text,
      nameController.text,
      emailController.text,
      roomID,
      date,
      startTime,
      endTime!,
      reasonController.text,
      0,
    );

    await reservation.insertReservation(reservation);
    print('Reservation added successfully');
  } else {
    print("Schedule conflict exists");
  }
}


  String getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'Unknown';
    }
  }

  void addMap() {
    int index = 0;
    while (index <= 24) {
      if (index == 0) {
        Map<String, dynamic> newTuple = {'name': '12AM', 'value': index};
        listOfTuples.add(newTuple);
      } else if (index < 12) {
        Map<String, dynamic> newTuple = {'name': '${index}AM', 'value': index};
        listOfTuples.add(newTuple);
      } else if (index == 12) {
        Map<String, dynamic> newTuple = {'name': '${index}PM', 'value': index};
        listOfTuples.add(newTuple);
      } else {
        Map<String, dynamic> newTuple = {
          'name': '${index - 12}PM',
          'value': index
        };
        listOfTuples.add(newTuple);
      }
      index++;
    }
  }

  void addEndStartMap() {
    int index = startTime + 1;
    while (index <= 24) {
      if (index == 0) {
        Map<String, dynamic> newTuple = {'name': '12AM', 'value': index};
        endlistOfTuplesNotifier.value = [
          ...endlistOfTuplesNotifier.value,
          newTuple
        ]; // Update the notifier
      } else if (index <= 12) {
        Map<String, dynamic> newTuple = {'name': '${index}AM', 'value': index};
        endlistOfTuplesNotifier.value = [
          ...endlistOfTuplesNotifier.value,
          newTuple
        ]; // Update the notifier
      } else {
        Map<String, dynamic> newTuple = {
          'name': '${index - 12}PM',
          'value': index
        };
        endlistOfTuplesNotifier.value = [
          ...endlistOfTuplesNotifier.value,
          newTuple
        ]; // Update the notifier
      }
      index++;
    }
  }

  @override
  void initState() {
    super.initState();
    futureRooms = Room.getAllRooms();
    addMap();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reserve Room'),
      content: SingleChildScrollView(
        // Wrap Column in SingleChildScrollView for scrolling
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min to avoid unnecessary space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Student ID Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ID number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            Row(children: [
              Flexible(
                child: FutureBuilder<List<Room>>(
                    future: futureRooms,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<String> items = snapshot.data!
                            .map((room) => room.room_name)
                            .toList();
                        print(items);
                        return DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Room',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedRoomId ?? items[0],
                          onChanged: (String? newValue) {
                            print(newValue);
                            int selectedIndex = items.indexOf(newValue!);
                            Room selectedRoom = snapshot.data![selectedIndex];
                            print(selectedRoom.room_id);
                            setState(() {
                              selectedRoomId = newValue;
                              roomID = selectedRoom.room_id;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        );
                      }
                    }),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(Duration(days: 365 * 100)),
                    );
                    if (picked != null && picked != DateTime.now())
                      print(picked);
                    setState(() {
                      formattedDate =
                          DateFormat('MMMM dd,yyyy').format(picked!);
                      date = picked;
                    });
                  },
                  child: Text(formattedDate),
                ),
              ),
              Flexible(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    hint: Text(startTimeMessage),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          startTimeMessage = listOfTuples.firstWhere(
                              (item) => item['value'] == newValue)['name'];
                          startTime = newValue;
                          endlistOfTuplesNotifier.value = [];
                          if (endTimeMessage != "Select End Time") {
                            if (startTime > endTime!) {
                              endTime = null;
                              endTimeMessage = "Select End Time";
                            }
                          }
                          addEndStartMap();
                        });
                      }
                    },
                    items: listOfTuples.map((item) {
                      int hour = int.parse(item['value'].toString());
                      return DropdownMenuItem<int>(
                        value: hour,
                        child: Text('${item['name']}'),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: endlistOfTuplesNotifier,
                builder: (BuildContext context,
                    List<Map<String, dynamic>> endlistOfTuplesNotifier,
                    Widget? child) {
                  return Flexible(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        hint: Text(endTimeMessage),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              endTimeMessage =
                                  endlistOfTuplesNotifier.firstWhere((item) =>
                                      item['value'] == newValue)['name'];
                              endTime = newValue;
                            });
                          }
                        },
                        items: endlistOfTuplesNotifier.map((item) {
                          int hour = int.parse(item['value'].toString());
                          return DropdownMenuItem<int>(
                            value: hour,
                            child: Text('${item['name']}'),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ]),
            Container(
              width: 500, // Specify the desired width
              child: TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  labelStyle: TextStyle(fontSize: 18),
                  hintText: 'Enter your reason here...',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 2),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('Exit'),
        ),
        ElevatedButton(
          onPressed: () {
            submit();
            Navigator.of(context).pop(); // Close the modal after submission
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
