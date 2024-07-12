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
              dataSource: snapshot.data,
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                endHour: 20,
                timeIntervalHeight: 39,
              ),
              headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Color.fromARGB(255, 30, 23, 104),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                    fontSize: 25,
                  )),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: Color.fromARGB(255, 237, 235, 255),
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
      rng.nextInt(201),
      rng.nextInt(201),
      rng.nextInt(201),
      1,
    );
  }

  Future<MeetingDataSource> _fetchMeetings(
      String roomId, String semesterId) async {
    print("fetching data");
    print(roomId);
    print(semesterId);
    List<Meeting> appointments = <Meeting>[];

    final Semester? semester = await Semester.getSemesterbyID(semesterId);
    final List<Schedule_Details> scheduleDetails =
        await Schedule_Details.readScheduleDetails(semesterId, roomId);
    final List<Reservation> reservationDetails =
        await Reservation.readReservationDetails(roomId);

    // Reservation
    print("reservation_details: ${reservationDetails}");
    for (var detail in reservationDetails) {
      print("reserved by: ${detail.name}");
      print("Processing detail: ${detail.date.year}");
      print("Processing detail: ${detail.date.month}");
      print("Processing detail: ${detail.date.day}");
      print("Processing detail: ${detail.start_time}");
      print("Processing detail: ${detail.end_time}");
      appointments.add(Meeting(
        eventName: "Reserved By:${detail.name}",
        from: DateTime(detail.date.year, detail.date.month, detail.date.day,
            detail.start_time),
        to: DateTime(detail.date.year, detail.date.month, detail.date.day,
            detail.end_time),
        background: getRandomLightColor(),
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=1',
      ));
    }

    // Schedules
    if (semester != null) {
      print(
          "Semester details: ${semester.start_date.toDate()} - ${semester.end_date.toDate()}");
      print("Schedule details count: ${scheduleDetails.length}");
      for (var detail in scheduleDetails) {
        print("Processing detail: ${detail.class_name}");
        print("Processing detail: ${detail.course}");
        print("Processing detail: ${detail.instructor}");
        print("Processing detail: ${detail.start_time}");
        print("Processing detail: ${detail.end_time}");

        String recurrenceRule = 'FREQ=WEEKLY;BYDAY=';
        for (String day in detail.weekdays) {
          switch (day.toLowerCase()) {
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
            default:
              print("Invalid weekday: ${day}");
              continue;
          }
        }
        int daysCount = countDays(semester.start_date.toDate(),
            semester.end_date.toDate(), detail.weekdays);
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

int countDays(DateTime startDate, DateTime endDate, List<String> days) {
  int count = 0;
  DateTime currentDate = startDate;

  Set<int> targetWeekdays = days.map((day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        throw ArgumentError('Invalid weekday: $day');
    }
  }).toSet();

  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    if (targetWeekdays.contains(currentDate.weekday)) {
      count++;
    }
    currentDate = currentDate.add(Duration(days: 1));
  }
  print(count);
  return count;
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
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
