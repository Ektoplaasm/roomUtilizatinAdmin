import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:view_reservation/services/firestore.dart';

class ViewReservations extends StatefulWidget {
  const ViewReservations({super.key});

  @override
  State<ViewReservations> createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              List<DataCell> displayedDataCell = [];

              for (var item in snapshot.data!.docs){
                //Formatting Time
                //Start Time
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
                //EndTime
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


                //Checking and replacing status (1 = Reserved, else = Awaiting Action) 
                String status = '';
                if (item['status'].toString() == '1'){
                  status = 'Reserved';
                } else {status = 'Awaiting Action';}
                //Adding firestore data to list
                displayedDataCell.add(
                  DataCell(Text(item['id'].toString())),
                );
                displayedDataCell.add(
                  DataCell(Text(item['name'].toString())),
                );
                displayedDataCell.add(
                  DataCell(Text(item['email'].toString())),
                );
                displayedDataCell.add(
                  DataCell(Text(item['room_id'].toString())),
                );
                displayedDataCell.add(
                  DataCell(Text(displayStringStart)),
                );
                displayedDataCell.add(
                  DataCell(Text(displayStringEnd)),
                );
                displayedDataCell.add(
                  DataCell(Text(item['reason'].toString())),
                );
                displayedDataCell.add(
                  DataCell(Text(status)),
                );
              }
              //Generate Table
              return FittedBox(
              //Table Header
                child:  DataTable(
              columns: const <DataColumn>[
              DataColumn(label: Expanded(child: Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Room', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('End Time', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)))),
              DataColumn(label: Expanded(child: Text('Reservation Status', style: TextStyle(fontWeight: FontWeight.bold)))),
              ], 
              //Table Body
              rows: <DataRow>[
                for (int i = 0; i < displayedDataCell.length; i += 8)
                  DataRow(cells: [displayedDataCell[i], displayedDataCell[i+1], displayedDataCell[i+2], displayedDataCell[i+3], displayedDataCell[i+4], displayedDataCell[i+5], displayedDataCell[i+6], displayedDataCell[i+7]])
              ], ),
              );
            }
            //Loading Icon When Data is being loaded
            else {return const Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [CircularProgressIndicator()],);}
          } 
        )
      );}}


      


      // DataTable(
      //   columns: 
      //   const <DataColumn>[
      //     DataColumn(label: 
      //     Expanded(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Room', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('End Time', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Reason', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Reservation Status', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //     DataColumn(label: 
      //     Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold),))
      //     ),
      //   ],
      //   rows: 
          // const<DataRow>[
          //   DataRow(cells: <DataCell>[
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),
          //     DataCell(Text('Test')),

          //   ]
          //   )
          // ]

