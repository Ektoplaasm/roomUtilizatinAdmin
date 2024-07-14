import 'package:admin_addschedule/pages/model/reservations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: Reservation.readAllActiveReservation(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Reservation>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return AlertDialog(
            title: Text('Pending Room Reservation'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Center(
                          child: Text('Name'),
                        ),
                        width: 300,
                      ),
                      Container(
                        child: Center(child: Text('Room ID')),
                        width: 150,
                      ),
                      Container(
                        child: Center(child: Center(child: Text('Date'))),
                        width: 150,
                      ),
                      Container(
                        child: Center(child: Center(child: Text('Start Time'))),
                        width: 150,
                      ),
                      Container(
                        child: Center(child: Center(child: Text('End Time'))),
                        width: 150,
                      ),
                    ],
                  ),
                  Divider(),
                  ...snapshot.data!
                      .map((reservation) => _buildReservationRow(reservation))
                      .toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildReservationRow(Reservation reservation) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(reservation.date);

    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(width: 300, child: Text(reservation.name)),
            Container(
                width: 150, child: Center(child: Text(reservation.room_id))),
            Container(width: 150, child: Center(child: Text(formattedDate))),
            Container(
                width: 150,
                child:
                    Center(child: Text(convertTime(reservation.start_time)))),
            Container(
                width: 150,
                child: Center(child: Text(convertTime(reservation.end_time)))),
          ],
        ));
  }

  String convertTime(int time) {
    if (time <= 12) {
      return "${time}am";
    } else {
      return "${time - 12}pm";
    }
  }
}
