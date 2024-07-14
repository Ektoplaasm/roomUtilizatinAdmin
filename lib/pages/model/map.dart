import 'package:cloud_firestore/cloud_firestore.dart';

class Map_Detail {
  final String map_image;
  final int floor;

  Map_Detail({required this.map_image, required this.floor});

  factory Map_Detail.fromMap(Map<String, dynamic> map) {
    return Map_Detail(
      map_image: map['map_image'] ?? '',
      floor: map['floor'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'map_image': map_image,
      'floor': floor,
    };
  }

  static Future<Map_Detail?> getLatestMap(int floor) async {
    print('getLatestMap Called');
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('map_history')
          .where('floor', isEqualTo: floor)
          .orderBy('date_uploaded', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('not null');
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return Map_Detail.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error reading latest upload details: $e");
      throw Exception("Failed to read latest upload details");
    }
  }
}
