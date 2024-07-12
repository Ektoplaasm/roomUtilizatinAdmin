import 'package:flutter/foundation.dart';

class CalendarData extends ChangeNotifier {
  String roomId = 'CISC LAB 24';
  String semesterId = 'OeuPodVAHxh2AKNQWU77';

  String get newroomId => roomId;
  String get newsemesterId => semesterId;

  void updateCalendar(String newroomId, String newsemesterId) {
    roomId = newroomId;
    semesterId = newsemesterId;
    notifyListeners();
  }
}
