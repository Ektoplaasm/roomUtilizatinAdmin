import 'dart:math';

import 'package:admin_addschedule/pages/model/notifier.dart';
import 'package:admin_addschedule/pages/model/reservations.dart';
import 'package:admin_addschedule/pages/model/schedule.dart';
import 'package:admin_addschedule/pages/model/semester.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CalendarData>(context);
    String roomId = provider.newroomId;
    String semesterId = provider.newsemesterId;
    print("semester ${semesterId}");

    return Scaffold(
      body: FutureBuilder<MeetingDataSource>(
        future: _fetchMeetings(roomId, semesterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            return SfCalendar(
              view: CalendarView.week,
              showNavigationArrow: true,
              dataSource: snapshot.data,
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                endHour: 20,
                timeIntervalHeight: 100,
              ),
              headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Color(0xff4f749f),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                    fontSize: 25,
                  )),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: Color(0xfff0f4f9),
                dateTextStyle: TextStyle(),
                dayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              todayHighlightColor: Color.fromARGB(255, 30, 23, 104),
            );
          }
        },
      ),
    );
  }

  Color getRandomLightColor() {
    var rng = Random();
    return Color.fromRGBO(
      rng.nextInt(150),
      rng.nextInt(150),
      rng.nextInt(150),
      1,
    );
  }

  Future<MeetingDataSource> _fetchMeetings(
      String roomId, String semesterId) async {
    List<Meeting> appointments = <Meeting>[];

    final Semester? semester = await Semester.getSemesterbyID(semesterId);
    final List<Schedule_Details> scheduleDetails =
        await Schedule_Details.readScheduleDetails(semesterId, roomId);
    final List<Reservation> reservationDetails =
        await Reservation.readActiveReservationDetails(roomId);

    if (reservationDetails.length != 0) {
      for (var detail in reservationDetails) {
        if (detail.type == 1) {
          appointments.add(Meeting(
            eventName: "Reserved By:${detail.name}",
            from: DateTime(
                DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                detail.start_time),
            to: DateTime(
                DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                detail.end_time),
            background: getRandomLightColor(),
            recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=1',
          ));
        } else if (detail.type == 2) {
          int count = DateTime.fromMillisecondsSinceEpoch(detail.end_date).day -
              DateTime.fromMillisecondsSinceEpoch(detail.date).day;
          print(DateTime.fromMillisecondsSinceEpoch(detail.end_date).day);
          print(DateTime.fromMillisecondsSinceEpoch(detail.date).day);
          appointments.add(Meeting(
            eventName: "Reserved By:${detail.name}",
            from: DateTime(
                DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                detail.start_time),
            to: DateTime(
                DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                detail.end_time),
            background: getRandomLightColor(),
            recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=${count + 1}',
          ));
        } else if (detail.type == 3) {
          List<String> daysArray = detail.recurringString.split(",");
          for (var day in daysArray) {
            int count =
                DateTime.fromMillisecondsSinceEpoch(detail.end_date).day -
                    DateTime.fromMillisecondsSinceEpoch(detail.date).day;
            print(DateTime.fromMillisecondsSinceEpoch(detail.end_date).day);
            print(DateTime.fromMillisecondsSinceEpoch(detail.date).day);
            appointments.add(Meeting(
              eventName: "Reserved By:${detail.name}",
              from: DateTime(
                  DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                  DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                  DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                  detail.start_time),
              to: DateTime(
                  DateTime.fromMillisecondsSinceEpoch(detail.date).year,
                  DateTime.fromMillisecondsSinceEpoch(detail.date).month,
                  DateTime.fromMillisecondsSinceEpoch(detail.date).day,
                  detail.end_time),
              background: getRandomLightColor(),
              recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=${count + 1}',
            ));
          }
        }
      }
    }

    // Schedules
    if (semester != null) {
      for (var detail in scheduleDetails) {
        String recurrenceRule = 'FREQ=WEEKLY;BYDAY=';

        switch (detail.weekday.toLowerCase()) {
          case 'monday':
            recurrenceRule += 'MO';
            break;
          case 'tuesday':
            recurrenceRule += 'TU';
            break;
          case 'wednesday':
            recurrenceRule += 'WE';
            break;
          case 'thursday':
            recurrenceRule += 'TH';
            break;
          case 'friday':
            recurrenceRule += 'FR';
            break;
          case 'saturday':
            recurrenceRule += 'SA';
            break;
          case 'sunday':
            recurrenceRule += 'SU';
            break;
          default:
            print("Invalid weekday: ${detail.weekday}");
            continue;
        }
        int daysCount = countDays(semester.start_date.toDate(),
            semester.end_date.toDate(), detail.weekday);
        print("How Many Days?${daysCount}");

        appointments.add(Meeting(
          eventName: detail.class_name +
              "\n" +
              detail.course +
              "\n" +
              detail.instructor,
          from: DateTime(
              semester.start_date.toDate().year,
              semester.start_date.toDate().month,
              semester.start_date.toDate().day,
              detail.start_time),
          to: DateTime(
              semester.start_date.toDate().year,
              semester.start_date.toDate().month,
              semester.start_date.toDate().day,
              detail.end_time),
          background: getRandomLightColor(),
          recurrenceRule: '$recurrenceRule;COUNT=$daysCount',
        ));
      }
    } else {
      print("Semester not found");
    }

    return MeetingDataSource(appointments);
  }
}

int countDays(DateTime startDate, DateTime endDate, String dayOfWeek) {
  int count = 0;
  DateTime currentDate = startDate;
  print(dayOfWeek);
  print(startDate);
  print(endDate);
  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    if (currentDate.weekday == getWeekdayNumber(dayOfWeek)) {
      count++;
    }

    currentDate = currentDate.add(Duration(days: 1));
  }

  return count;
}

int getWeekdayNumber(String dayName) {
  switch (dayName.toLowerCase()) {
    case 'monday':
      return 1;
    case 'tuesday':
      return 2;
    case 'wednesday':
      return 3;
    case 'thursday':
      return 4;
    case 'friday':
      return 5;
    case 'saturday':
      return 6;
    case 'sunday':
      return 0;
    default:
      throw ArgumentError('Invalid day name provided.');
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to as DateTime;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
}

class Meeting {
  Meeting(
      {this.eventName = '',
      required this.from,
      required this.to,
      required this.background,
      this.isAllDay = false,
      this.recurrenceRule});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String? recurrenceRule;
}
