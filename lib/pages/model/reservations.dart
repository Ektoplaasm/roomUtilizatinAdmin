import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String name;
  String email;
  String room_id;
  DateTime date;
  int start_time;
  int end_time;
  String reason;
  int status;

  Reservation(this.id, this.name, this.email, this.room_id, this.date,
      this.start_time, this.end_time, this.reason, this.status);

  static Reservation fromMap(Map<String, dynamic> map) {
    return Reservation(
        map['id'],
        map['name'],
        map['email'],
        map['room_id'],
        (map['date'] as Timestamp).toDate(),
        map['start_time'],
        map['end_time'],
        map['reason'],
        map['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'room_id': room_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'reason': reason,
      'status': status
    };
  }

  Future<void> insertReservation(Reservation reservation) async {
    CollectionReference reservationsCollection =
        FirebaseFirestore.instance.collection('reservations');
    try {
      await reservationsCollection.add(reservation.toMap());
      print('Reservation inserted successfully.');
    } catch (e) {
      print('Failed to insert reservation: $e');
    }
  }

  static Future<List<Reservation>> readReservationDetails(
      String room_id) async {
    try {
      print("Reservation_id: ${room_id}");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('room_id', isEqualTo: room_id)
          .get();

      return querySnapshot.docs
          .map((doc) => Reservation.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }
}
