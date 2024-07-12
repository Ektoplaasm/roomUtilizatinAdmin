import 'package:cloud_firestore/cloud_firestore.dart';

class Semester {
  final String? id;
  String semester_name;
  Timestamp start_date;
  Timestamp end_date;
  Timestamp date_created;

  Semester(this.id, this.semester_name, this.start_date, this.end_date,
      this.date_created);

  static Semester fromMap(Map<String, dynamic> map, [String? id]) {
    return Semester(
      id ?? map['id'],
      map['semester_name'] as String,
      map['start_date'] as Timestamp,
      map['end_date'] as Timestamp,
      map['date_created'] as Timestamp,
    );
  }

  static Future<Semester?> getSemester() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('semester').doc().get();
    if (doc.exists) {
      return Semester.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<Semester?> getSemesterbyID(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('semester').doc(id).get();
    if (doc.exists) {
      return Semester.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<Semester?>> fetchAllSemesters() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('semester')
        .orderBy('date_created', descending: true)
        .get();
    List<Semester?> semesters = [];
    for (var doc in querySnapshot.docs) {
      if (doc.exists) {
        semesters.add(Semester.fromMap(doc.data() as Map<String, dynamic>));
      }
    }
    return semesters;
  }

  static Future<Semester?> fetchLatestSemester() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('semester')
        .orderBy('date_created', descending: true)
        .limit(1)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first);

    if (!snapshot.exists) {
      return null;
    }

    // Pass the document ID to the fromMap method
    return Semester.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }
}
