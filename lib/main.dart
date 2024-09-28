import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import Material to use MaterialApp
import 'package:provider/provider.dart';
import 'screens/events_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/settings_screen.dart';
import 'helpers/font_provider.dart'; // Import the FontProvider

void main() {
  runApp(SalubongApp());
}

class SalubongApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontProvider(), // Provide FontProvider to the app
      child: Consumer<FontProvider>( // Listen to font provider changes
        builder: (context, fontProvider, child) {
          return MaterialApp(
            title: 'Salubong App',
            theme: ThemeData(
              brightness: fontProvider.isDarkMode ? Brightness.dark : Brightness.light, // Adjust theme based on dark mode
              primarySwatch: Colors.blue,
            ),
            home: CupertinoAppHome(), // This is where the Cupertino design begins
          );
        },
      ),
    );
  }
}

class CupertinoAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Salubong App',
      theme: const CupertinoThemeData(
        primaryColor: Color.fromARGB(255, 0, 0, 0),
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
