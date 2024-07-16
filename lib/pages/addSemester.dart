  import 'package:flutter/material.dart';
  import 'package:admin_addschedule/services/firestore.dart';
  import 'package:intl/intl.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  class Semester extends StatefulWidget {
    const Semester({Key? key}) : super(key: key);

    @override
    State<Semester> createState() => _SemesterState();
  }

  class _SemesterState extends State<Semester> {
    late TextEditingController _semesterNameController;
    late DateTime _startDate;
    late DateTime _endDate;

    final FirestoreService _firestoreService = FirestoreService();

    @override
    void initState() {
      super.initState();
      _semesterNameController = TextEditingController();
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    }

    @override
    void dispose() {
      _semesterNameController.dispose();
      super.dispose();
    }

    Future<void> _addSemester() async {
    await _firestoreService.addSemester(
      _startDate,
      _semesterNameController.text,
      _endDate,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semester added successfully')),
    );

    _semesterNameController.clear();
  }

  void _showEditDialog(DocumentSnapshot item) {
  print('Dialog opened for item: ${item.id}');
  
  TextEditingController classController = TextEditingController(text: item['semester_name'].toString());
  TextEditingController courseController = TextEditingController(text: item['start'].toString());
  TextEditingController instructorController = TextEditingController(text: item['instructor'].toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Semester'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[


                ])));});});}

  Future<void> deleteSem(BuildContext context, String sem_id) async {
  try {
    await FirebaseFirestore.instance
        .collection('semester')
        .doc(sem_id)
        .delete();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semester deleted successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting semester: $e')),
    );
  }
}


    Future<void> _selectDate(BuildContext context, bool isStartDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
        setState(() {
          if (isStartDate) {
            _startDate = picked;
          } else {
            _endDate = picked;
          }
        });
      }
    }

    String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy \'at\' hh:mm:ss a \'UTC\'Z');
    final String formattedDate = formatter.format(date.toLocal());
    return formattedDate;
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box),
                SizedBox(width: 10,),
                Text('Add Semester', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
        body: 
        Padding(padding: EdgeInsets.all(16), child: 
        Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                              
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Color(0xff274c77)),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                    AlertDialog(
                                    title: const Center(child: Text("Add New Semester", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextField(
                    controller: _semesterNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Semester Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide()
                        
                      ),
                      prefixIcon: Icon(Icons.date_range),
                      suffixIcon: Icon(Icons.info),

                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Start Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style:  const ButtonStyle(
                                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    side: BorderSide(color: Color(0xFF000000))
                                  )
                                ),
                                backgroundColor: WidgetStatePropertyAll(Colors.white)
                                
                              ),
                              
                              onPressed: () => _selectDate(context, true),
                              child: Text(
                                _formatDate(_startDate), style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(' End Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style:  const ButtonStyle(
                                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    side: BorderSide(color: Color(0xFF000000))
                                  )
                                ),
                                backgroundColor: WidgetStatePropertyAll(Colors.white)
                                
                              ),
                            onPressed: () => _selectDate(context, false),
                            child: Text(
                              _formatDate(_endDate), style: const TextStyle(color: Colors.black)
                            ),
                          ),
                        ],
                      ),
                      
                    ]
                  ),
                  
                  SizedBox(height: 20),
                  Center(
                    
                    child: ElevatedButton(
                      onPressed: _addSemester,
                      child: Text('Add Semester'),
                    ),
                  ),
                                        ],
                                      ),
                                    )
                                  )
                                );
                                
                              },
                              child: const Text('New Semester', style: TextStyle(color: Colors.white),)
                            ),

                  ),
                  Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('semester').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No schedules found'));
              }
              
              var filteredDocs = snapshot.data!.docs;
              String formatDate(DateTime dateTime) {
                final DateFormat formatter = DateFormat('MM-dd-yyyy'); // Customize the format as needed
                return formatter.format(dateTime);
              }

              List<DataRow> rows = filteredDocs.map((item) {
                return DataRow(cells: [
                  DataCell(Center(child: Text(item['semester_name']))),
                  
                  DataCell(Center(child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(item['start_date'].toDate().millisecondsSinceEpoch))))),
                  DataCell(Center(child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(item['end_date'].toDate().millisecondsSinceEpoch))))),
                  DataCell(
                    Row(
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 42, 92, 150)),
                            ),
                            onPressed: () {
                              // _showEditDialog(item);
                            },
                            child: const Icon(Icons.settings, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                  AlertDialog(
                                  title: Text("Confirm Semester Deletion?", style: TextStyle(fontSize: 20)),
                                  content: SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(onPressed: (){
                                          deleteSem(context, item['id']);
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
                                        ElevatedButton(onPressed: (){Navigator.of(context).pop();},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff274c77),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          )
                                        ), child: Text('Cancel',style: TextStyle(
                                            color: Colors.white,))),
                                      ],
                                    ),
                                  )
                                )
                              );
                              
                            },
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ]);
              }).toList();
              
              return SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Expanded(child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // PhosphorIcon(PhosphorIconsFill.chalkboard),
                                Text('Semester Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // PhosphorIcon(PhosphorIconsFill.graduationCap),
                                Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(Icons.badge),
                                Text('End Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            DataColumn(label: Expanded(child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(Icons.badge),
                                Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            )))),
                            
                          ],
                          // rows: filteredDocs,
                          rows: rows
                        ),
                      ),
                    ),
                  ),
                ),
              );
              
              
              
              }))
                  
                  
                ],
              ),
        )
        
      );
    }
  }
