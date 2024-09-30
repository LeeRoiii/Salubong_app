import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/add_event_screen.dart';
import 'package:myapp/screens/events_screen.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'helpers/font_provider.dart';

void main() {
  runApp(SalubongApp());
}

class SalubongApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontProvider(),
      child: MaterialApp(
        title: 'Salubong App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _eventsNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.black, // Set active tab color to black
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
            return CupertinoTabView(
              navigatorKey: _eventsNavigatorKey, // Set the navigator key for Events
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async {
                    // Add this to refresh the EventsScreen when navigating back
                    if (_eventsNavigatorKey.currentState!.canPop()) {
                      _eventsNavigatorKey.currentState!.pop(); // Go back in the stack
                      return false; // Prevent default pop behavior
                    }
                    return true; // Allow default pop behavior
                  },
                  child: EventsScreen(),
                );
              },
            );
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
