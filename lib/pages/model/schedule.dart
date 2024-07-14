import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule_Details {
  String course;
  String class_name;
  String room_id;
  String instructor;
  int start_time;
  int end_time;
  String semester_id;
  String weekday;

  Schedule_Details(this.course, this.class_name, this.room_id, this.instructor,
      this.start_time, this.end_time, this.semester_id, this.weekday);

  static Schedule_Details fromMap(Map<String, dynamic> map) {
    return Schedule_Details(
        map['course'] ?? '',
        map['class'] ?? '',
        map['room_id'] ?? '',
        map['instructor'] ?? '',
        map['start_time'] ?? 0,
        map['end_time'] ?? 0,
        map['semester_id'] ?? '',
        map['weekday'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'class': class_name,
      'room_id': room_id,
      'instructor': instructor,
      'start_time': start_time,
      'end_time': end_time,
      'semester_id': semester_id,
      'weekday': weekday
    };
  }

  static Future<List<Schedule_Details>> readScheduleDetails(
      String semester_id, String room_id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('schedule_details')
          .where('semester_id', isEqualTo: semester_id)
          .where('room_id', isEqualTo: room_id)
          .get();
      for (var scheds in querySnapshot.docs) {
        print(scheds);
      }
      return querySnapshot.docs
          .map((doc) =>
              Schedule_Details.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }

  static Future<List<Schedule_Details>> getSchedules(
      String semester_id, int room_id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('semester_id', isEqualTo: semester_id)
          .where('room_id', isEqualTo: room_id)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Schedule_Details.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }

  static Future<List<Schedule_Details>> getSchedulesBySemester(
      String room_id, String semester_id) async {
    try {
      print("sem_id:${semester_id}");
      print("sem_id:${room_id}");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('schedule_details')
          .where('room_id', isEqualTo: room_id)
          .where('semester_id', isEqualTo: semester_id)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Schedule_Details.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }

  static Future<List<Schedule_Details>> getSchedulesByRoom(
      String room_id) async {
    try {
      print("sem_id:${room_id}");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('schedule_details')
          .where('room_id', isEqualTo: room_id)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Schedule_Details.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }
}
