import 'dart:async';

import 'package:admin_addschedule/pages/calendar.dart';
import 'package:admin_addschedule/pages/model/reservation_modal.dart';
import 'package:admin_addschedule/pages/model/semester.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

import 'model/notifier.dart';


const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color.fromARGB(0, 36, 40, 48);

class PietPainting extends StatefulWidget {
  final Function(String, String)? onRoomUpdated;

  const PietPainting({Key? key, this.onRoomUpdated}) : super(key: key);

  @override
  PietPaintingState createState() => PietPaintingState();
}

class PietPaintingState extends State<PietPainting> {

    late String currentSemester;

  String getCurrentSemester() {
    return currentSemester;
  }

  Future<void> getLatestSemester() async {
    Semester? latestSemester = await Semester.fetchLatestSemester();
    if (latestSemester != null) {
      setState(() {
        print("print semester${latestSemester.semester_name}");
        currentSemester = latestSemester.id!;
      });
      Provider.of<CalendarData>(context, listen: false)
          .updateSemester(currentSemester!);
    } else {
      // Handle the case where no semester is found
      print("No semester found.");
    }
  }

  Future<void> getAllSemester() async {
    List<Semester?> latestSemester = await Semester.fetchAllSemesters();

    // Iterate over the list, handling potential null values
    for (Semester? semesterNullable in latestSemester) {
      if (semesterNullable != null) {
        // Cast the nullable Semester to a non-nullable Semester for printing
        Semester semester = semesterNullable!;
        print(
            'Semester Name: ${semester.semester_name}, Start Date: ${semester.start_date.toDate()}, End Date: ${semester.end_date.toDate()}, Created Date: ${semester.date_created.toDate()}');
      }
    }
  }

  @override
  void initState() {
    getLatestSemester();
    getAllSemester();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final columnSizes = screenSize.width > 600
        ? [3.0.fr, 3.0.fr, 3.0.fr, 3.7.fr, 3.fr, 3.fr]
        : [10.0.fr, 10.0.fr];
    final rowSizes = screenSize.width > 600
        ? [1.fr, 3.0.fr, 3.0.fr, 3.0.fr, 3.0.fr, 3.0.fr, 1.fr, 1.fr]
        : [.5.fr, 1.0.fr, 1.0.fr, .5.fr, 1.0.fr, .5.fr];
    final areas = screenSize.width > 600
        ? '''
        hd hd hd na se se
        ca ca ca ca ca ca
        ca ca ca ca ca ca
        ca ca ca ca ca ca
        ca ca ca ca ca ca
        ca ca ca ca ca ca
        fl fl fl bw bw bw
        fo fo fo fo fo fo
        '''
        : '''
        hd hd
        cf2 cf2
        cf2 cf2
        fl fl
        ca ca
        fo fo
        ''';

    void showModalExample(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReservationModal();
        },
      );
    }

    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 0,
        rowGap: 0,
        areas: areas,
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        children: [
          gridArea('ca').containing(CalendarWidget()),
          gridArea('hd').containing(Container(color: Colors.white)),
          gridArea('na').containing(Container(
              width: 200,
              color: Colors.white,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalExample(context);
                },
                icon: Icon(Icons.add),
                label: Text('New Reservation'),
              ))),
          gridArea('se').containing(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          20), //border raiuds of dropdown button
                      //blur radius of shadow
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: FutureBuilder<List<Semester?>>(
                        future: Semester.fetchAllSemesters(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Semester?>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            // Find the index of the currentSemester in the list of items
                            int? currentIndex = snapshot.data!.indexWhere(
                                (item) => item?.id == currentSemester);

                            return Material(
                              child: DropdownButton<String>(
                                underline: Container(),
                                hint: Text(
                                  'Select a semester',
                                  style: TextStyle(fontFamily: 'Satoshi'),
                                ),
                                value: currentSemester,
                                onChanged: (String? newValue) {
                                  print("New sem:${newValue}");
                                  Provider.of<CalendarData>(context,
                                          listen: false)
                                      .updateSemester(newValue!);
                                  setState(() {
                                    currentSemester = newValue!;
                                  });
                                },
                                items: snapshot.data!
                                    .where((semester) =>
                                        semester !=
                                        null) // Filter out null semesters
                                    .map((Semester? semester) =>
                                        DropdownMenuItem<String>(
                                          value: semester?.id ??
                                              '', // Provide a default value if semester is null
                                          child: Text(
                                              semester?.semester_name ?? '',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Satoshi')), // Provide a default text if semester is null
                                        ))
                                    .toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                // Add other widgets here if needed
              ],
            ),
          ),
          gridArea('fl').containing(Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
              ],
            ),
          )),

          gridArea('bw').containing(Container(color: Colors.white)),
          gridArea('fo').containing(Container(color: Colors.white)),
        ],
      ),
    );
  }
}
