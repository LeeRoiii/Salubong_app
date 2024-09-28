import '../Widgets/background_options.dart';
import '../helpers/database_helper.dart';


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart" show DateFormat;
import 'package:image_picker/image_picker.dart';
import '../Widgets/location_field.dart';
import '../Widgets/date_picker.dart';



class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _backgroundImageUrl;
  Color _color = CupertinoColors.systemBlue;
  Gradient? _backgroundGradient;

  final dbHelper = DatabaseHelper.instance;

  // Use ValueNotifier to hold state
  final ValueNotifier<String> _eventNameNotifier = ValueNotifier('');
  final ValueNotifier<String> _locationNotifier = ValueNotifier('');

  final List<String> _eventSuggestions = [
    'My Birthday 🎉',
    'Wedding 💍',
    'Graduation 🎓',
    'Anniversary ❤️',
    'Christmas 🎄',
    'New Year 🎆',
    'Vacation ✈️',
    'Promotion 🎉',
    'Retirement 🎊',
    'Baby Shower 👶',
    'Housewarming 🏠',
    'Bridal Shower 👰',
    'Engagement 💍',
    'Conference 📅',
    'Team Meeting 👥',
    'Concert 🎤',
    'Family Reunion 👨‍👩‍👧‍👦',
    'Charity Event 💖',
    'Sports Game 🏀',
    'Festival 🎪',
    'Holiday Party 🎉',
    'Business Launch 🚀',
    'Date Night 💕',
    'Workshop 🛠️',
    'Job Interview 💼',
    'Doctor’s Appointment 🏥',
    'Fitness Class 🏋️‍♂️',
    'Yoga Session 🧘',
    'Book Club 📚',
    'Movie Night 🎬',
    'Gaming Tournament 🎮',
    'Picnic 🍉',
    'Road Trip 🚗',
    'Back to School 🎒',
    'Shopping Day 🛍️',
    'Art Exhibit 🎨',
    'Music Festival 🎶',
    'Marathon 🏃‍♂️',
    'Tech Expo 💻',
  ];


  final ImagePicker _picker = ImagePicker();

  // Update the image selection and notify listeners
  Future<void> _selectImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _backgroundImageUrl = pickedFile.path;
        _backgroundGradient = null;
      });
    }
  }

  // Update color and notify listeners
  void _setColorAndGradient(Color color) {
    setState(() {
      _color = color;
      _backgroundImageUrl = null;
      _backgroundGradient = LinearGradient(
        colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
      );
    });
  }

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => DatePickerWidget(
        initialDate: _selectedDate,
        onDateChanged: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  // Save event to database
  void _saveEvent() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _eventNameController.text,
      DatabaseHelper.columnDate: _selectedDate.toIso8601String(),
      DatabaseHelper.columnReminder: _reminderController.text,
      DatabaseHelper.columnLocation: _locationController.text,
      DatabaseHelper.columnBackgroundImage: _backgroundImageUrl,
      DatabaseHelper.columnColor: _color.value,
    };

    final id = await dbHelper.insert(row);
    if (id > 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Event added successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ));
      _clearForm();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add event. Please try again.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _clearForm() {
    setState(() {
      _eventNameController.clear();
      _reminderController.clear();
      _locationController.clear();
      _selectedDate = DateTime.now();
      _backgroundImageUrl = null;
      _backgroundGradient = null;

      // Clear the notifiers
      _eventNameNotifier.value = '';
      _locationNotifier.value = '';
    });
  }

        @override
        Widget build(BuildContext context) {
          return Material(
            child: CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                middle: Text('Add New Event'),
              ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use ValueListenableBuilder for the EventPreviewWidget
                  ValueListenableBuilder<String>(
                    valueListenable: _eventNameNotifier,
                    builder: (context, eventName, child) {
                      return EventPreviewWidget(
                        eventNameController: _eventNameController,
                        selectedDate: _selectedDate,
                        backgroundImageUrl: _backgroundImageUrl,
                        backgroundGradient: _backgroundGradient,
                        color: _color,
                        location: _locationController.text,
                      );
                    },
                  ),

                const SizedBox(height: 20),
                EventTitleField(eventNameController: _eventNameController),
                const SizedBox(height: 10),
                EventSuggestions(
                  suggestions: _eventSuggestions,
                  onSuggestionSelected: (suggestion) {
                    _eventNameController.text = suggestion;
                    _eventNameNotifier.value =
                        suggestion; // Update the notifier
                  },
                ),
                const SizedBox(height: 20),
                DateField(
                  selectedDate: _selectedDate,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),
                ReminderField(reminderController: _reminderController),
                const SizedBox(height: 20),
                LocationField(locationController: _locationController),
                const SizedBox(height: 20),
                BackgroundOptions(
                  onImageSelected: _selectImageFromGallery,
                  onColorSelected: _setColorAndGradient,
                ),
                const SizedBox(height: 30),
                Center(
                  child: CupertinoButton.filled(
                    onPressed: _saveEvent,
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context, dynamic locationController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'LOCATION',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 10),
      CupertinoTextField(
        controller: locationController,
        placeholder: 'Optional Enter location...',
        padding: const EdgeInsets.all(16.0),
        style: const TextStyle(fontSize: 18),
        suffix: GestureDetector(
          onTap: () => _pickLocation(context),
          child: const Icon(
            CupertinoIcons.location_circle,
            size: 28,
            color: CupertinoColors.black,
          ),
        ),
      ),
    ],
  );
}

_pickLocation(BuildContext context) {

}

class EventPreviewWidget extends StatelessWidget {
  final TextEditingController eventNameController;
  final DateTime selectedDate;
  final String? backgroundImageUrl;
  final Gradient? backgroundGradient;
  final Color color;
  final String? location; // Add a location parameter

  const EventPreviewWidget({super.key,
    required this.eventNameController,
    required this.selectedDate,
    this.backgroundImageUrl,
    this.backgroundGradient,
    required this.color,
    this.location, // Initialize the location parameter
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = selectedDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        // Add navigation or other actions on tap if needed
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              backgroundImageUrl != null
                  ? Image.file(
                      File(backgroundImageUrl!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: backgroundGradient,
                      ),
                    ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventNameController.text.isEmpty
                          ? 'Event Title'
                          : eventNameController.text,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, yyyy').format(selectedDate),
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Align items
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$daysUntil ${daysUntil == 1 ? 'Day' : 'Days'} Until',
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (location != null &&
                            location!
                                .isNotEmpty) // Display location if provided
                          Expanded(
                            child: Text(
                              location!,
                              textAlign:
                                  TextAlign.end, // Align text to the right
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventTitleField extends StatelessWidget {
  final TextEditingController eventNameController;

  const EventTitleField({super.key, required this.eventNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TITLE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        CupertinoTextField(
          controller: eventNameController,
          placeholder: 'Birthday, Vacation, Christmas...',
          padding: const EdgeInsets.all(16.0),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class EventSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionSelected;

  const EventSuggestions({super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUGGESTIONS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  child: Text(suggestion),
                  onPressed: () => onSuggestionSelected(suggestion),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DateField({super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATE & TIME',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                DateFormat.yMMMMd().format(selectedDate),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReminderField extends StatelessWidget {
  final TextEditingController reminderController;

  const ReminderField({super.key, required this.reminderController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REMINDERS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        CupertinoTextField(
          controller: reminderController,
          placeholder: 'Optional Enter reminder...',
          padding: const EdgeInsets.all(16.0),
          style: const TextStyle(fontSize: 18),
          maxLength: 30,
        ),
      ],
    );
  }
}

