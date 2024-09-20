import 'package:flutter/cupertino.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add Event'),
      ),
      child: Center(
        child: Text('Add Event Content Here'), // Placeholder for your content
      ),
    );
  }
}
