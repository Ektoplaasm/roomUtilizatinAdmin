import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class FirestoreService {
  final CollectionReference sched_details = FirebaseFirestore.instance.collection('schedule_details');
  final CollectionReference listofrooms = FirebaseFirestore.instance.collection('rooms');
  final CollectionReference listofsemester = FirebaseFirestore.instance.collection('semester');
  

  Future<void> addSched(String classCode, String courseCode, String instructor, String roomCode, int startTime, int endTime, String? selectedDay, String _selectedSemester){
    // List<String> weekdays = selectedDays.m
    // List weekdays = selectedDays.map((item) => item.value).toList();

    String documentID = sched_details.doc().id;
    
    return sched_details.doc(documentID).set({
      'class' : classCode,
      'course' : courseCode,
      'instructor' : instructor,
      'room_id' : roomCode,
      'start_time' : startTime,
      'end_time' : endTime,
      'weekday' : selectedDay,
      'semester_id' : _selectedSemester,
      'sched_id' : documentID,
    });

  }

  //get data time start and end para butang sa taken start and end time
  Future<List<Map<String, dynamic>>?> fetchSchedules(roomId, semId, day) async {
    if(roomId != null && semId != null && day != null ) {
    QuerySnapshot snapshot = await sched_details.where('room_id', isEqualTo: roomId).where('semester_id', isEqualTo: semId).where('weekday', isEqualTo: day).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } else {
      return null;
    }
    
  }

  //for user login
  Future addUser(String userId, Map<String, dynamic>  userInfoMap){
    return FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    QuerySnapshot snapshot = await listofrooms.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchSemester() async {
    QuerySnapshot snapshot = await listofsemester.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> addSemester(String end_date, String semester_name, String start_date,){
    String documentID = sched_details.doc().id;
    
    return listofsemester.doc(documentID).set({
      'end_date' : end_date,
      'semester_name' : semester_name,
      'start_date' : start_date,
      'id' : documentID,
    });

  }

}
