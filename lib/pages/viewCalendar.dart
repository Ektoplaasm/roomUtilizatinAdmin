import 'dart:async';

import 'package:admin_addschedule/pages/calendar.dart';
import 'package:admin_addschedule/pages/model/reservation_modal.dart';
import 'package:admin_addschedule/pages/model/semester.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';


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

    Future<Semester?> fetchsemester() async {
      return await Semester.getSemester();
    }

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
          gridArea('se').containing(Container(
              width: double.infinity,
              child: Material(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: 300,
                      child: FutureBuilder<List<Semester?>>(
                        future: Semester.fetchAllSemesters(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Semester?>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            String? _selectedValue =
                                snapshot.data![0]?.semester_name ?? '';
                            return DropdownButton<String>(
                              value: _selectedValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                print(newValue);
                                setState(() {
                                  _selectedValue = newValue;
                                });
                                print(_selectedValue);
                              },
                              items: snapshot.data!
                                  .map<DropdownMenuItem<String>>(
                                      (Semester? semester) {
                                    // Check if semester is not null before accessing properties
                                    if (semester != null) {
                                      return DropdownMenuItem<String>(
                                        value: semester.semester_name,
                                        child: Text(semester.semester_name),
                                      );
                                    }
                                    return DropdownMenuItem(
                                        child: Text(
                                            '')); // Return an empty item if semester is null
                                  })
                                  .where((item) => item.value!
                                      .isNotEmpty) // Filter out any empty items
                                  .toList(),
                            );
                          } else {
                            return Text(
                                'No semesters found.'); // Handle case where no data is returned
                          }
                        },
                      )),
                ],
              )))),
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
