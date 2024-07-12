import 'package:admin_addschedule/firebase_options.dart';
import 'package:admin_addschedule/pages/addRoomSchedule.dart';
import 'package:admin_addschedule/pages/addSemester.dart';
import 'package:admin_addschedule/pages/signin%20copy.dart';
import 'package:admin_addschedule/pages/signin.dart';
import 'package:admin_addschedule/pages/viewReservations.dart';
import 'package:admin_addschedule/pages/viewReservationsApproved.dart';
import 'package:admin_addschedule/pages/viewReservationsDisapproved.dart';
import 'package:admin_addschedule/pages/viewRoomSchedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
          fontSize: 20,
          fontWeight: FontWeight.w500,
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
        return 'View Pending';
      case 1:
        return 'View Approved';
      case 2:
        return 'View Disapproved';
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
          borderRadius: BorderRadius.circular(10),
        ),
        hoverColor: hovercolormain,
        textStyle: TextStyle(color: const Color.fromARGB(255, 102, 102, 102), fontSize: 15),
        selectedTextStyle: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w700),
        hoverTextStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w700,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30,),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: hovercolormain,
          // border: Border.all(
          //   color: actionColor.withOpacity(0.37),
          // ),
          // gradient: const (
          //   colors: [accentCanvasColor],
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.28),
          //     blurRadius: 10,
          //   ),
          // ],
          
        ),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 102, 102, 102),
          size: 30,
        ),
        selectedIconTheme: const IconThemeData(
          color: primaryColor,
          size: 30,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 290,
        decoration: BoxDecoration(
          color: canvasColor,
          border: Border(right: BorderSide(
            width: 0.3,
          )),
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // child: Image.asset('assets/logo.png'),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhosphorIcon(PhosphorIconsFill.chalkboardTeacher, size: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "CISC Room Utilization",
                        style: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      items: [
       SidebarXItem(
          icon: Icons.view_agenda,
          label: 'View Pending',
          onTap: () {
            _controller.selectIndex(0);
          },
        ),

        SidebarXItem(
          icon: PhosphorIconsFill.calendarCheck,
          label: 'View Approved',
          onTap: () {
            _controller.selectIndex(1);
          },
        ),

        SidebarXItem(
          icon: PhosphorIconsFill.calendarSlash,
          label: 'View Disapproved',
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
          icon: Icons.date_range,
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn2()));
          },
        ),

      ],
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
const canvasColor = Color(0xfff0f4f9);
// const gradient2nd = Color(0xff274c77);
const scaffoldBackgroundColor = Color(0xfff0f4f9);
const accentCanvasColor = Color(0xff274c77);
const white = Color.fromARGB(255, 188, 188, 188);
final actionColor = Color.fromARGB(255, 55, 55, 126);
final divider = Divider(color: white.withOpacity(0.3));
const hovercolormain = Color.fromARGB(255, 231, 236, 248);