import 'package:admin_addschedule/pages/homepage.dart';
import 'package:admin_addschedule/pages/signin.dart';
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

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(title: const Text('View Reservations'), onTap: () => _navPush(context, const ViewReservations())),
          ListTile(title: const Text('Add Room Schedules'), onTap: () => _navPush(context, const AddRoomSchedule()))
        ],
      ),
    );
  }

  Future<dynamic> _navPush(BuildContext context, Widget page) {
    return Navigator.push(context, MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
