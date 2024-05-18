import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class FirestoreService {
  final CollectionReference sched_details = FirebaseFirestore.instance.collection('schedule_details');

  Future<void> addSched(String classCode, String courseCode, String instructor, String roomCode, String startTime, String endTime, String selectedValueEnd, List<ValueItem> selectedDays){
    List weekdays = selectedDays.map((item) => item.value).toList();
    return sched_details.add({
      'class' : classCode,
      'course' : courseCode,
      'instructor' : instructor,
      'room_id' : roomCode,
      'start_time' : startTime,
      'end_time' : endTime,
      'weekday' : weekdays,
      'semester_id' : 'OeuPodVAHxh2AKNQWU77'
    });
}

}



