import 'dart:async';

import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/pages/model/reservations.dart';
import 'package:admin_addschedule/pages/model/room.dart';
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
  int? _groupValue = 1;

  late TextEditingController idController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController reasonController = TextEditingController();
  late int startTime;
  late int? endTime;
  late DateTime date = DateTime.now();
  late DateTime endDate = DateTime.now();
  late String roomID;

  // boolean days
  bool isMondayTrue = false;
  bool isTuesdayTrue = false;
  bool isWednesdayTrue = false;
  bool isThursdayTrue = false;
  bool isFridayTrue = false;
  bool isSaturdayTrue = false;
  bool isSundayTrue = false;

  bool isValidEmail(String email) {
    RegExp regExp = new RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regExp.hasMatch(email);
  }

  Future<bool> submit() async {
    print(DaytoString());
    bool exist = false;

    if (_groupValue == 1) {
      Reservation newreservation = Reservation(
          idController.text,
          nameController.text,
          emailController.text,
          roomID,
          date.millisecondsSinceEpoch,
          0,
          startTime,
          endTime!,
          reasonController.text,
          1,
          "",
          0);

      print(newreservation.email);
      await Reservation.insertReservation(newreservation);
    } else if (_groupValue == 2) {
      Reservation newreservation = Reservation(
          idController.text,
          nameController.text,
          emailController.text,
          roomID,
          date.millisecondsSinceEpoch,
          endDate.millisecondsSinceEpoch,
          startTime,
          endTime!,
          reasonController.text,
          2,
          '',
          0);

      print(newreservation.email);
      await Reservation.insertReservation(newreservation);
    } else {
      Reservation newreservation = Reservation(
          idController.text,
          nameController.text,
          emailController.text,
          roomID,
          date.millisecondsSinceEpoch,
          endDate.millisecondsSinceEpoch,
          startTime,
          endTime!,
          reasonController.text,
          3,
          DaytoString(),
          0);

      print(newreservation.email);
      await Reservation.insertReservation(newreservation);
    }
    return false;
  }

  String DaytoString() {
    String dayString = "";
    if (isMondayTrue == true) {
      dayString += "monday";
    }
    if (isTuesdayTrue == true) {
      if (isMondayTrue == false) {
        dayString += "tuesday";
      } else {
        dayString += ",tuesday";
      }
    }
    if (isWednesdayTrue == true) {
      if (isTuesdayTrue == false && isMondayTrue == false) {
        dayString += "wednesday";
      } else {
        dayString += ",wednesday";
      }
    }
    if (isThursdayTrue == true) {
      if (isWednesdayTrue == false &&
          isTuesdayTrue == false &&
          isMondayTrue == false) {
        dayString += "thursday";
      } else {
        dayString += ",thursday";
      }
    }
    if (isFridayTrue == true) {
      if (isThursdayTrue == false &&
          isWednesdayTrue == false &&
          isTuesdayTrue == false &&
          isMondayTrue == false) {
        dayString += "friday";
      } else {
        dayString += ",friday";
      }
    }
    if (isSaturdayTrue == true) {
      if (isFridayTrue == false &&
          isThursdayTrue == false &&
          isWednesdayTrue == false &&
          isTuesdayTrue == false &&
          isMondayTrue == false) {
        dayString += "saturday";
      } else {
        dayString += ",saturday";
      }
    }
    if (isSundayTrue == true) {
      if (isSaturdayTrue == false &&
          isFridayTrue == false &&
          isThursdayTrue == false &&
          isWednesdayTrue == false &&
          isTuesdayTrue == false &&
          isMondayTrue == false) {
        dayString += "sunday";
      } else {
        dayString += ",sunday";
      }
    }
    return dayString;
  }

  bool validate() {
    if (idController.text == "" ||
        nameController.text == "" ||
        emailController.text == "" ||
        reasonController.text == "" ||
        roomID == "" ||
        date == Null ||
        startTime == Null ||
        endTime == Null) {
      return false;
    } else {
      return true;
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
    int index = 7;
    while (index <= 19) {
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
    while (index <= 19) {
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
        ];
      } else {
        Map<String, dynamic> newTuple = {
          'name': '${index - 12}PM',
          'value': index
        };
        endlistOfTuplesNotifier.value = [
          ...endlistOfTuplesNotifier.value,
          newTuple
        ];
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
    return SizedBox(
        width: 500,
        height: 500,
        child: AlertDialog(
          title: Center(child: Text('Reserve Room', style: TextStyle(fontWeight: FontWeight.bold),)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID Number'),
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        // Ensure Expanded is a direct child of Row
                        child: ListTile(
                          title: const Text('Once'),
                          leading: Radio<int>(
                            value: 1,
                            groupValue: _groupValue,
                            onChanged: (int? value) {
                              setState(() {
                                _groupValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        // Ensure Expanded is a direct child of Row
                        child: ListTile(
                          title: const Text('Spanned'),
                          leading: Radio<int>(
                            value: 2,
                            groupValue: _groupValue,
                            onChanged: (int? value) {
                              setState(() {
                                _groupValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        // Ensure Expanded is a direct child of Row
                        child: ListTile(
                          title: const Text('Recurring'),
                          leading: Radio<int>(
                            value: 3,
                            groupValue: _groupValue,
                            onChanged: (int? value) {
                              setState(() {
                                _groupValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: _groupValue == 1
                      ? onceWidget()
                      : _groupValue == 2
                          ? spanWidget()
                          : _groupValue == 3
                              ? recurringWidget()
                              : Container(),
                ),
                Container(
                  width: double.infinity,
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
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Exit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (isValidEmail(emailController.text)) {
                      submit().then((result) {
                        if (result == true) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Schedule is already taken"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Invalid email"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Container(
              height: 10,
            )
          ],
        ));
  }

  Widget onceWidget() {
    return Column(children: <Widget>[
      // Label for the first row
      Text("Room Selection and Date Setting", style: TextStyle(fontSize: 18)),

      Padding(
          padding: EdgeInsets.all(20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Flexible(
              child: FutureBuilder<List<Room>>(
                  future: futureRooms,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator instead of empty text
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<String> items =
                          snapshot.data!.map((room) => room.room_name).toList();
                      return Container(
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0), 
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: DropdownButton2<String>(
                          underline: Container(),
                          isExpanded: true,
                          hint: Text(
                            'Select Room',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                        ),
                      );
                    }
                  }),
            ),
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(Duration(days: 365 * 100)),
                  );
                  if (picked != null && picked != DateTime.now()) print(picked);
                  setState(() {
                    formattedDate = DateFormat('MMMM dd,yyyy').format(picked!);
                    date = picked!;
                  });
                },
                child: Text(formattedDate, style: TextStyle(color: Colors.white),),
              ),
            ),
          ])),

      Text("Time Selection", style: TextStyle(fontSize: 18)),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0), 
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0),
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
          ),
          SizedBox(height: 20),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: endlistOfTuplesNotifier,
            builder: (BuildContext context,
                List<Map<String, dynamic>> endlistOfTuplesNotifier,
                Widget? child) {
              return Flexible(
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0), 
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButton<int>(
                      hint: Text(endTimeMessage),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            endTimeMessage = endlistOfTuplesNotifier.firstWhere(
                                (item) => item['value'] == newValue)['name'];
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
                ),
              );
            },
          ),
        ],
      ),
      SizedBox(height: 10,),
    ]);
  }

  Widget spanWidget() {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
          child: FutureBuilder<List<Room>>(
              future: futureRooms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> items =
                      snapshot.data!.map((room) => room.room_name).toList();
                  print(items);
                  return DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Room',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
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
              if (picked != null && picked != DateTime.now()) print(picked);
              setState(() {
                formattedDate = DateFormat('MMMM dd,yyyy').format(picked!);
                date = picked;
              });
            },
            child: Text(formattedDate),
          ),
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
              if (picked != null && picked != DateTime.now()) print(picked);
              setState(() {
                formattedDate = DateFormat('MMMM dd,yyyy').format(picked!);
                endDate = picked;
              });
            },
            child: Text(formattedDate),
          ),
        ),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                          endTimeMessage = endlistOfTuplesNotifier.firstWhere(
                              (item) => item['value'] == newValue)['name'];
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
        ],
      )
    ]);
  }

  Widget recurringWidget() {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
          child: FutureBuilder<List<Room>>(
              future: futureRooms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> items =
                      snapshot.data!.map((room) => room.room_name).toList();
                  print(items);
                  return DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Room',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
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
              if (picked != null && picked != DateTime.now()) print(picked);
              setState(() {
                formattedDate = DateFormat('MMMM dd,yyyy').format(picked!);
                date = picked;
              });
            },
            child: Text(formattedDate),
          ),
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
              if (picked != null && picked != DateTime.now()) print(picked);
              setState(() {
                formattedDate = DateFormat('MMMM dd,yyyy').format(picked!);
                endDate = picked;
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
                        endTimeMessage = endlistOfTuplesNotifier.firstWhere(
                            (item) => item['value'] == newValue)['name'];
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
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                  title: const Text('Monday'),
                  leading: Checkbox(
                      value: isMondayTrue,
                      onChanged: (bool? value) {
                        setState(() {
                          isMondayTrue = value!;
                        });
                      })),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Tuesday'),
                leading: Checkbox(
                    value: isTuesdayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isTuesdayTrue = value!;
                      });
                    }),
              ),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Wednesday'),
                leading: Checkbox(
                    value: isWednesdayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isWednesdayTrue = value!;
                      });
                    }),
              ),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Thursday'),
                leading: Checkbox(
                    value: isThursdayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isThursdayTrue = value!;
                      });
                    }),
              ),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Friday'),
                leading: Checkbox(
                    value: isFridayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isFridayTrue = value!;
                      });
                    }),
              ),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Saturday'),
                leading: Checkbox(
                    value: isSaturdayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isSaturdayTrue = value!;
                      });
                    }),
              ),
            ),
            Expanded(
              // Ensure Expanded is a direct child of Row
              child: ListTile(
                title: const Text('Sunday'),
                leading: Checkbox(
                    value: isSundayTrue,
                    onChanged: (bool? value) {
                      setState(() {
                        isSundayTrue = value!;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [],
      )
    ]);
  }
}
