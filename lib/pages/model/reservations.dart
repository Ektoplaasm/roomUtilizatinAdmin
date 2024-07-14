import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String name;
  String email;
  String room_id;
  int date;
  int end_date;
  int start_time;
  int end_time;
  String reason;
  int type;
  String recurringString;
  int status;

  Reservation(
      this.id,
      this.name,
      this.email,
      this.room_id,
      this.date,
      this.end_date,
      this.start_time,
      this.end_time,
      this.reason,
      this.type,
      this.recurringString,
      this.status);

  static Reservation fromMap(Map<String, dynamic> map) {
    return Reservation(
        map['id'],
        map['name'],
        map['email'],
        map['room_id'],
        map['date'],
        map['end_date'] ?? 0,
        map['start_time'],
        map['end_time'],
        map['reason'],
        map['type'] ?? 0,
        map['recurringString'] ?? "",
        map['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'room_id': room_id,
      'date': date,
      'end_date': end_date,
      'start_time': start_time,
      'end_time': end_time,
      'reason': reason,
      'type': type,
      'recurring': recurringString,
      'status': status
    };
  }

  static Future<void> insertReservation(Reservation reservation) async {
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

  static Future<List<Reservation>> readActiveReservationDetails(
      String room_id) async {
    try {
      print("Reservation_id: ${room_id}");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('room_id', isEqualTo: room_id)
          .where('status', isEqualTo: 1)
          .get();

      return querySnapshot.docs
          .map((doc) => Reservation.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error reading schedule details: $e");
      return [];
    }
  }

  static Future<List<Reservation>> readAllActiveReservation() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('status', isEqualTo: 0)
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
