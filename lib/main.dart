import 'package:flutter/cupertino.dart';
import 'screens/events_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(SalubongApp());
}

class SalubongApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Salubong App',
      theme: CupertinoThemeData(
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Add Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => EventsScreen());
          case 1:
            return CupertinoTabView(builder: (context) => AddEventScreen());
          case 2:
          default:
            return CupertinoTabView(builder: (context) => SettingsScreen());
        }
      },
    );
  }
}
