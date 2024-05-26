import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViewReservations extends StatefulWidget {
  const ViewReservations({super.key});

  @override
  State<ViewReservations> createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> {
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

  Future<void> sendEmailApprove(String name, String room_name, String status, String email, String reason, String date) async {
    Map<String, dynamic> templateParams = {
      'student': name,
      'room': room_name,
      'status': "APPROVED",
      'recipient': email,
      'reason' : reason,
      'date' : date,
    };

    try {
      await EmailJS.send(
        'service_3ca0m4k',
        'template_cu85d3d',
        templateParams,
        const Options(
          publicKey: 'JdeXxH2HpzwOpFZ_x',
          privateKey: '57Qs_qxxVbgTpvCI9HFOP',
        ),
      );
      print('SUCCESS TO SEND APPROVAL!');
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> sendEmailDisapprove(String name, String room_name, String status, String email, String reason, String date) async {
    Map<String, dynamic> templateParams = {
      'student': name,
      'room': room_name,
      'status': "DISAPPROVED",
      'recipient': email,
      'reason' : reason,
      'date' : date,
    };

    try {
      await EmailJS.send(
        'service_3ca0m4k',
        'template_cu85d3d',
        templateParams,
        const Options(
          publicKey: 'JdeXxH2HpzwOpFZ_x',
          privateKey: '57Qs_qxxVbgTpvCI9HFOP',
        ),
      );
      print('SUCCESS TO SEND DISAPPROVAL!');
    } catch (error) {
      print(error.toString());
    }
  }

  TextEditingController reasonController = TextEditingController();
    
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
              const Text("View Room Reservations", style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          )),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection('reservations')
              .where('status', isEqualTo: 0)
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
                    DataCell(
                      Row(
                        children: [
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Color(0xff274c77)),
                              ),
                              onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Center(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhosphorIcon(PhosphorIconsFill.warningCircle),
                                      Text("Room Utilization Request", style: TextStyle(fontSize: 25)),
                                    ],
                                    
                                  )
                                  
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: 
                                  SizedBox(
                                  width: 300,
                                  child: 
                                  ListBody(
                                    children: <Widget>[
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            PhosphorIcon(PhosphorIconsFill.identificationBadge),
                                            const Text(
                                                  "Name: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                            Flexible(child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(item['name'].toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          PhosphorIcon(PhosphorIconsFill.at),
                                          const Text(
                                                  "Email: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                
                                                SizedBox(width: 10),
                                                Text(
                                                  item['email'].toString(),
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),


                                      SizedBox(height: 10,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          PhosphorIcon(PhosphorIconsFill.chalkboard),
                                          const Text("Room: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          Flexible
                                          (child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                          SizedBox(width: 10,),
                                          Text(item['room_id'].toString(), style: TextStyle(fontSize: 15),),
                                            ],
                                          )),
                                          
                                      ]),
                                      
                                      SizedBox(height: 10,),

                                      Column(children: [
                                        
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            PhosphorIcon(PhosphorIconsFill.timer),
                                            const Text("Time Requested: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            PhosphorIcon(PhosphorIconsFill.hourglassHigh),
                                            SizedBox(width: 10,),
                                            Text(displayStringStart, style: TextStyle(fontSize: 15),),
                                            const Text(' To ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                            PhosphorIcon(PhosphorIconsFill.hourglassLow),
                                            SizedBox(width: 10,),
                                            Text(displayStringEnd, style: TextStyle(fontSize: 15),),
                                          ],
                                        ),
                                        
                                      ]),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          PhosphorIcon(PhosphorIconsFill.question),
                                            SizedBox(width: 10,),
                                          const Text('Reason for request:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Expanded(child: SingleChildScrollView(
                                        child: Text(item['reason'].toString(), textAlign: TextAlign.justify, style: TextStyle(fontSize: 15),),
                                      )),
                                      
                                      
                                        ],
                                      )
                                    )
                                  )
                                )
                              )
                              ,
                              child: const Text('View', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.green),
                              ),
                              // updateStatus(item.id);
                                // sendEmailApprove(item['id'].toString(), item['room_id'].toString(), item['status'].toString(), item['email'].toString() );
                              onPressed: ()  => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                AlertDialog(
                                title: Text("Confirm Approval of Request?", style: TextStyle(fontSize: 20)),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      SizedBox(
                                        width: 100.0,
                                        child: TextField(
                                          maxLines: null,
                                          controller: reasonController,
                                          decoration: InputDecoration(labelText: 'Enter Message for the Student.'),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(onPressed: (){
                                            BoxDecoration(
                                              color: Color(0xff274c77),
                                              
                                            );
                                            updateStatus(item.id);
                                            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['date']);
                                            sendEmailApprove(item['id'].toString(), item['room_id'].toString(), item['status'].toString(), item['email'].toString(), reasonController.text, DateFormat('MMMM d, yyyy').format(dateTime));
                                            reasonController.clear();
                                            Navigator.of(context).pop();
                                          }, 
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff274c77),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                            )
                                          ),
                                          child: Text('Confirm', style: TextStyle(
                                              color: Colors.white,
                                            ),)),
                                          SizedBox(width: 10,),
                                          ElevatedButton(onPressed: (){Navigator.of(context).pop();reasonController.clear();},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff274c77),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                            )
                                          ), child: Text('Cancel',style: TextStyle(
                                              color: Colors.white,))),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                )),
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.red),
                              ),
                              onPressed: ()  => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                AlertDialog(
                                title: Text("Reject Room Utilization", style: TextStyle(fontSize: 20)),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      
                                      SizedBox(
                                        width: 100.0,
                                        child: TextField(
                                          maxLines: null,
                                          controller: reasonController,
                                          decoration: InputDecoration(labelText: 'Enter Reason for Rejection.'),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                        ElevatedButton(onPressed: (){
                                        updateStatustoRejected(item.id);
                                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['date']);
                                        sendEmailDisapprove(item['id'].toString(), item['room_id'].toString(), item['status'].toString(), item['email'].toString(), reasonController.text, DateFormat('MMMM d, yyyy').format(dateTime));
                                        reasonController.clear();
                                        Navigator.of(context).pop();
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff274c77),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        )
                                      ), child: Text('Confirm',style: TextStyle(
                                          color: Colors.white,))),
                                      const SizedBox(width: 10),
                                      ElevatedButton(onPressed: (){Navigator.of(context).pop();reasonController.clear();}, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff274c77),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ) 
                                      ),
                                      child: Text('Cancel', style: TextStyle(color: Colors.white),)),
                                      ],)
                                      
                                    ],
                                  ),
                                )
                                )),
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      
                    ),
                  ];
        
                  rows.add(DataRow(cells: displayedDataCell));
                }
                
                return Container(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
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
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PhosphorIcon(PhosphorIconsFill.gearSix),
                                Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    ),
                  ),
                );
              }
              
              else {return const Center(child: CircularProgressIndicator());}
            } 
          ),
      )
      );
  }
}
