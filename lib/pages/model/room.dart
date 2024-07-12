import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String room_id;
  String room_name;

  Room(this.room_id, this.room_name);

  static Room fromMap(Map<String, dynamic> map) {
    return Room(map['room_id'], map['room_name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'room_name': room_name,
      'room_id': room_id,
    };
  }

  static Future<List<Room>> getAllRooms() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    List<Room> rooms = [];

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      if (data != null && data is Map<String, dynamic>) {
        // Ensure data is not null and is a Map
        rooms.add(Room.fromMap(data));
      } else {
        print("Data is either null or not a Map<String, dynamic>");
      }
    }

    // Sort the rooms alphabetically by room_name
    rooms.sort((a, b) => a.room_name.compareTo(b.room_name));

    return rooms;
  }
}
