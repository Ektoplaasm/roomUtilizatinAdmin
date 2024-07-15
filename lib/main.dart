import 'package:admin_addschedule/pages/addRoomSchedule.dart';
import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/pages/model/notifier.dart';
import 'package:admin_addschedule/pages/signin%20copy.dart';
import 'package:admin_addschedule/pages/signin.dart';
import 'package:admin_addschedule/pages/viewReservations.dart';
import 'package:admin_addschedule/pages/viewReservationsApproved.dart';
import 'package:admin_addschedule/pages/viewReservationsDisapproved.dart';
import 'package:admin_addschedule/pages/viewRoomSchedule.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalendarData(),
      child: MainApp(),
    )
  );
    // const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SignIn2(),
      home: SidebarXExampleApp(),
    );
  }
}
