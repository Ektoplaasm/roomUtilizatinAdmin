import 'dart:async';
import 'dart:convert';

import 'package:admin_addschedule/pages/calendar.dart';
import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/pages/model/map.dart';
import 'package:admin_addschedule/pages/model/pending.dart';
import 'package:admin_addschedule/pages/model/reservation_modal.dart';
import 'package:admin_addschedule/pages/model/semester.dart';
import 'package:admin_addschedule/pages/ui_components.dart';
import 'package:admin_addschedule/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

import 'model/notifier.dart';

const Color primaryColor = Color(0xff274c77);

class Map_Display extends StatefulWidget {
  const Map_Display({Key? key}) : super(key: key);

  @override
  State<Map_Display> createState() => _Map_DisplayState();
}

class _Map_DisplayState extends State<Map_Display> {
  late String base64 = '';
  late String currentSemester = '';
  late int currentFloor = 1;
  String? selectedRoom;

  @override
  void initState() {
    super.initState();
    getLatestSemester();
  }

  void showModalReservation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReservationModal();
      },
    );
  }

  void showModalPending(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PendingModal();
      },
    );
  }

  Future<void> getLatestSemester() async {
    Semester? latestSemester = await Semester.fetchLatestSemester();
    if (latestSemester != null) {
      setState(() {
        print("print semester${latestSemester.semester_name}");
        currentSemester = latestSemester.id!;
      });
      Provider.of<CalendarData>(context, listen: false)
          .updateSemester(currentSemester);
    } else {
      print("No semester found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Row(
            
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 5,),
              Text(
                "Calendar",
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
              
            ],
          ),
        ),
        actions: [
          Container(
            child: Row(
              children: [
                SemesterDropdown(),
                SizedBox(width: 10),
                RoomDropdown(),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () {
                  showModalReservation(context);
                }, child: Row(
                  children: [
                    Icon(Icons.post_add_rounded, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text("Reservation", style: TextStyle(color: Colors.white),),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () {
                  showModalPending(context);
                }, child: Row(
                  children: [
                    Icon(Icons.pending_actions, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text("Pending", style: TextStyle(color: Colors.white),),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                ),
                
                SizedBox(width: 10,),
                
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: CalendarWidget()),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RoomDropdown extends StatefulWidget {
  @override
  _RoomDropdownState createState() => _RoomDropdownState();
}

class _RoomDropdownState extends State<RoomDropdown> {
  String? selectedRoom;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        List<DropdownMenuItem<String>> roomItems = snapshot.data!.docs
            .map((DocumentSnapshot document) {
          return DropdownMenuItem<String>(
            value: document.id,
            child: Text(
              document['room_name'],
              style: TextStyle(fontFamily: 'Satoshi'),
            ),
          );
        }).toList();

        return Container(
          height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0), 
              borderRadius: BorderRadius.circular(5.0), 
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0), 
          child: DropdownButton<String>(
            underline: Container(),
            value: selectedRoom,
            hint: Text(
              'Select a room',
              style: TextStyle(fontFamily: 'Satoshi'),
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedRoom = newValue;
              });
              if (newValue != null) {
                DocumentSnapshot selectedDocument = snapshot.data!.docs
                    .firstWhere((doc) => doc.id == newValue);
                print('Room selected: ${selectedDocument.id}');
                Provider.of<CalendarData>(context, listen: false)
                    .updateCalendar(selectedDocument['room_id']);
              }
            },
            items: roomItems,
          ),
        );
      },
    );
  }
}

class SemesterDropdown extends StatefulWidget {
  @override
  _SemesterDropdownState createState() => _SemesterDropdownState();
}

class _SemesterDropdownState extends State<SemesterDropdown> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Semester?>>(
      future: Semester.fetchAllSemesters(),
      builder: (BuildContext context, AsyncSnapshot<List<Semester?>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return Container(
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0), 
              borderRadius: BorderRadius.circular(5.0), 
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0), 
            child: DropdownButton<String>(
            underline: Container(),
            hint: Text(
              'Select a semester',
              style: TextStyle(fontFamily: 'Satoshi'),
            ),
            value: Provider.of<CalendarData>(context).semesterId,
            onChanged: (String? newValue) {
              print("New sem:${newValue}");
              Provider.of<CalendarData>(context, listen: false)
                  .updateSemester(newValue!);
            },
            items: snapshot.data!
                .where((semester) => semester != null)
                .map((Semester? semester) => DropdownMenuItem<String>(
                      value: semester?.id ?? '',
                      child: Text(semester?.semester_name ?? '',
                          style: TextStyle(fontFamily: 'Satoshi')),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
