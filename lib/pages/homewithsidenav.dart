import 'package:admin_addschedule/firebase_options.dart';
import 'package:admin_addschedule/pages/addRoomSchedule.dart';
import 'package:admin_addschedule/pages/signin.dart';
import 'package:admin_addschedule/pages/viewReservations.dart';
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
        return 'View Reservation';
      case 1:
        return 'Add Schedule';
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
        textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
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
            child: Image.asset('logo.png'),
          ),
        );
      },
      items: [
       SidebarXItem(
          icon: Icons.view_agenda,
          label: 'View Reservations',
          onTap: () {
            _controller.selectIndex(0);
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
        return AddRoomSchedule();
      default:
        return SignIn();
    }
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color.fromARGB(255, 255, 255, 255);
const scaffoldBackgroundColor = Color.fromARGB(255, 255, 255, 255);
const accentCanvasColor = Color.fromARGB(255, 95, 95, 191);
const white = Color.fromARGB(255, 102, 102, 102);
final actionColor = Color.fromARGB(255, 55, 55, 126).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
const hovercolormain = Color.fromARGB(255, 51, 47, 169);
