import 'package:flutter/foundation.dart';

class CalendarData extends ChangeNotifier {
  String roomId = 'CISC LAB 24';
  String semesterId = 'VADNIF3AR9TgVy0s5u3s';

  String get newroomId => roomId;
  String get newsemesterId => semesterId;

  void updateCalendar(String newroomId) {
    roomId = newroomId;
    notifyListeners();
  }

  void updateSemester(String newsemesterId) {
    semesterId = newsemesterId;
    notifyListeners();
  }
}
