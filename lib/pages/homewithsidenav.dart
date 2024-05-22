import 'package:admin_addschedule/firebase_options.dart';
import 'package:admin_addschedule/pages/addRoomSchedule.dart';
import 'package:admin_addschedule/pages/addSemester.dart';
import 'package:admin_addschedule/pages/signin.dart';
import 'package:admin_addschedule/pages/viewReservations.dart';
import 'package:admin_addschedule/pages/viewReservationsApproved.dart';
import 'package:admin_addschedule/pages/viewReservationsDisapproved.dart';
import 'package:admin_addschedule/pages/viewRoomSchedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarXExampleApp extends StatelessWidget {
  SidebarXExampleApp({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CISC Room Utilization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      primaryColor: Colors.white,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 46,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),

      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(controller: _controller),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return 'View Pending Reservation';
      case 1:
        return 'View Approved Reservation';
      case 2:
        return 'View Disapproved Reservation';
      case 3:
        return 'Schedules';
      case 4:
        return 'Add Schedule';
      case 5:
        return 'Add Semester';
      default:
        return 'Page Not Found';
    }
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: hovercolormain,
        textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        selectedTextStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        hoverTextStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, gradient2nd],
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.28),
          //     blurRadius: 10,
          //   ),
          // ],
          
        ),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/logo.png'),
          ),
        );
      },
      items: [
       SidebarXItem(
          icon: Icons.view_agenda,
          label: 'View Pending Reservations',
          onTap: () {
            _controller.selectIndex(0);
          },
        ),

        SidebarXItem(
          icon: Icons.view_agenda,
          label: 'View Approved Reservations',
          onTap: () {
            _controller.selectIndex(1);
          },
        ),

        SidebarXItem(
          icon: Icons.view_agenda,
          label: 'View Disapproved Reservations',
          onTap: () {
            _controller.selectIndex(2);
          },
        ),

        SidebarXItem(
          icon: Icons.view_agenda,
          label: 'Schedules',
          onTap: () {
            _controller.selectIndex(3);
          },
        ),
      
        SidebarXItem(
          icon: Icons.schedule,
          label: 'Add Schedule',
          onTap: () {
            _controller.selectIndex(4);
          },
        ),

        SidebarXItem(
          icon: Icons.schedule,
          label: 'Add Semester',
          onTap: () {
            _controller.selectIndex(5);
          },
        ),

        SidebarXItem(
          icon: Icons.logout,
          label: 'Sign out',
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
          },
        ),

      ],
    );
  }

  void _showDisabledAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item disabled for selecting',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _getPageByIndex(controller.selectedIndex);
      },
    );
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return ViewReservations();
      case 1:
        return ViewReservationsApproved();
      case 2:
        return ViewReservationsDisapproved();
      case 3:
        return ViewRoomSchedule();
      case 4:
        return AddRoomSchedule();
      case 5:
        return Semester();
      default:
        return SignIn();
    }
  }
}

const primaryColor = Color(0xff274c77);
const canvasColor = Color.fromARGB(255, 255, 255, 255);
const gradient2nd = Color(0xff274c77);
const scaffoldBackgroundColor = Color(0xfff0f4f9);
const accentCanvasColor = Color(0xff274c77);
const white = Color.fromARGB(255, 188, 188, 188);
final actionColor = Color.fromARGB(255, 55, 55, 126).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
const hovercolormain = Color.fromARGB(255, 162, 162, 162);
// const Color primaryColor = Color(0xff274c77);
// const Color secondaryColor = Color(0xff4f749f);
// const Color bgColor = Color(0xfff0f4f9);
// const Color outlineColor = Color(0xffE4E4E4);
// const Color highlightColor = Color(0xffF8FDFF);