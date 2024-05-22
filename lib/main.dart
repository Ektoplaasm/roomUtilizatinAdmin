import 'package:admin_addschedule/pages/addRoomSchedule.dart';
import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/pages/signin.dart';
import 'package:admin_addschedule/pages/viewReservations.dart';
import 'package:admin_addschedule/pages/viewReservationsApproved.dart';
import 'package:admin_addschedule/pages/viewReservationsDisapproved.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
