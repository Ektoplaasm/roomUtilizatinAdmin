
import 'package:admin_addschedule/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViewReservationsApproved extends StatefulWidget {
  const ViewReservationsApproved({super.key});

  @override
  State<ViewReservationsApproved> createState() => _ViewReservationsApprovedState();
}

class _ViewReservationsApprovedState extends State<ViewReservationsApproved> {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateStatus(String docId) async {
    await FirebaseFirestore.instance.collection('reservations').doc(docId).update({'status': 1});
  }
  Future<void> updateStatustoRejected(String docId) async {
    await FirebaseFirestore.instance.collection('reservations').doc(docId).update({'status': 2});
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.view_compact, color: const Color.fromARGB(255, 0, 0, 0),),
              SizedBox(width: 10,),
              const Text("Approved Room Reservations", style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          )),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('status', isEqualTo: 1)
            .snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              List<DataCell> displayedDataCell = [];
              List<DataRow> rows = [];

              for (var item in snapshot.data!.docs){
                // Formatting Time
                var displayStringStart = item['start_time'].toString();
                if(displayStringStart == '13'){
                  displayStringStart = '1 PM';
                } else if(displayStringStart == '14'){
                  displayStringStart = '2 PM';
                } else if(displayStringStart == '15'){
                  displayStringStart = '3 PM';
                } else if(displayStringStart == '16'){
                  displayStringStart = '4 PM';
                } else if(displayStringStart == '17'){
                  displayStringStart = '5 PM';
                } else if(displayStringStart == '18'){
                  displayStringStart = '6 PM';
                } else if(displayStringStart == '19'){
                  displayStringStart = '7 PM';
                } else {
                  displayStringStart = "${item['start_time'].toString()} AM";
                }
                // End Time
                var displayStringEnd = item['end_time'].toString();
                if(displayStringEnd == '13'){
                  displayStringEnd = '1 PM';
                } else if(displayStringEnd == '14'){
                  displayStringEnd = '2 PM';
                } else if(displayStringEnd == '15'){
                  displayStringEnd = '3 PM';
                } else if(displayStringEnd == '16'){
                  displayStringEnd = '4 PM';
                } else if(displayStringEnd == '17'){
                  displayStringEnd = '5 PM';
                } else if(displayStringEnd == '18'){
                  displayStringEnd = '6 PM';
                } else if(displayStringEnd == '19'){
                  displayStringEnd = '7 PM';
                } else {displayStringEnd = "${item['end_time'].toString()} AM";}

              
              String status;
              Color color;

              
              switch (item['status'].toString()) {
                case '1':
                  status = 'Reservation Approved';
                  color = const Color.fromARGB(255, 0, 128, 0); 
                  break;
                case '2':
                  status = 'Reservation Disapproved';
                  color = const Color.fromARGB(255, 255, 0, 0); 
                  break;
                case '0':
                  status = 'Reservation Pending';
                  color = const Color.fromARGB(255, 255, 165, 0); 
                  break;
                default:
                  status = 'Unknown Status';
                  color = const Color.fromARGB(255, 0, 0, 0);
                  break;
              }

              Color statustextColor;
              Color statusBGColor;
              Color statusBorderColor;

              switch (item['status'].toString()) {
                case '1':
                  statustextColor = Colors.white;
                  statusBGColor = Colors.green;
                  statusBorderColor = Colors.green;
                  break;
                case '2':
                  statustextColor = Colors.white;
                  statusBGColor = const Color.fromARGB(255, 255, 0, 0); 
                  statusBorderColor = const Color.fromARGB(255, 255, 0, 0); 
                  break;
                case '0':
                  statustextColor = Colors.black;
                  statusBGColor = const Color.fromARGB(255, 255, 165, 0); 
                  statusBorderColor = const Color.fromARGB(255, 255, 165, 0); 
                  break;
                default:
                  statustextColor = Colors.black;
                  statusBGColor = const Color.fromARGB(255, 0, 0, 0);
                  statusBorderColor = const Color.fromARGB(255, 0, 0, 0);
                  break;
              }

              Widget statusWidget = Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBGColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusBorderColor),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statustextColor),
                ),
              );

              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['date']);
              String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);

              
                displayedDataCell = [
                  DataCell(Center(child: Text(item['id'].toString()))),
                  DataCell(Center(child: Text(item['name'].toString()))),
                  DataCell(Center(child: Text(item['email'].toString()))),
                  DataCell(Center(child: Text(item['room_id'].toString()))),
                  DataCell(Center(child: Text(formattedDate))),
                  DataCell(Center(child: Text(displayStringStart))),
                  DataCell(Center(child: Text(displayStringEnd))),
                  // DataCell(Center(child: Text(item['reason'].toString()))),
                  DataCell(Center(child: statusWidget)),
                  
                ];

                rows.add(DataRow(cells: displayedDataCell));
              }
              
              return 
              Container(
                alignment: Alignment.topCenter,
                child:
              FittedBox(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Expanded(child: Center(child: Row(
                        children: [
                          PhosphorIcon(PhosphorIconsFill.identificationBadge),
                          Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      )))),
                      DataColumn(label: Expanded(child: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                      DataColumn(label: Expanded(child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(PhosphorIconsFill.at),
                          Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      )))),
                     DataColumn(label: Expanded(child: Center(child: Row(
                              children: [
                                PhosphorIcon(PhosphorIconsFill.chalkboard),
                                Text('Room', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              children: [
                                PhosphorIcon(PhosphorIconsFill.calendarDot),
                                Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              children: [
                                PhosphorIcon(PhosphorIconsFill.hourglassHigh),
                                Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              children: [
                                PhosphorIcon(PhosphorIconsFill.hourglassLow),
                                Text('End Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),// DataColumn(label: Expanded(child: Center(child: Text('Reason', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))))),
                      DataColumn(label: Expanded(child: Center(child: Row(
                        children: [
                          PhosphorIcon(PhosphorIconsFill.checkCircle),
                          Text('Reservation Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      )))),
                      ],
                    rows: rows.map((row) {
                    final rowIndex = rows.indexOf(row);
                    final color = rowIndex.isEven ? bgColor : Colors.white;
                    return DataRow(
                      color: WidgetStateColor.resolveWith((states) => color!),
                      cells: row.cells,
                    );
                  }).toList(),
                  ),
                ),
              ));
            }
            
            else {return const Center(child: CircularProgressIndicator());}
          } 
        ) 
      );
  }
}
