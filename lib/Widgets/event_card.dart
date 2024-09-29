import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../helpers/database_helper.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final String selectedFont;

  const EventCard({Key? key, required this.event, required this.selectedFont})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String eventName = event[DatabaseHelper.columnName] ?? 'Event';
    final DateTime eventDate = DateTime.parse(event[DatabaseHelper.columnDate]);
    final String? location = event[DatabaseHelper.columnLocation];
    final String? backgroundImageUrl = event[DatabaseHelper.columnBackgroundImage];
    final int? colorValue = event[DatabaseHelper.columnColor];
    final Color eventColor = colorValue != null
        ? Color(colorValue)
        : CupertinoColors.systemGrey;
    final int daysUntil = eventDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        // Add navigation or other actions on tap if needed
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: eventColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              if (backgroundImageUrl != null && File(backgroundImageUrl).existsSync())
                Image.file(
                  File(backgroundImageUrl),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [eventColor, eventColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                      eventName,
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: selectedFont, // Use selected font
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, yyyy').format(eventDate),
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        if (location != null && location.isNotEmpty)
                          Expanded(
                            child: Text(
                              location,
                              textAlign: TextAlign.end,
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
