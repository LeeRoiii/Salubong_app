import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

class EventPreviewWidget extends StatelessWidget {
  final TextEditingController eventNameController;
  final DateTime selectedDate;
  final String? backgroundImageUrl;
  final Gradient? backgroundGradient;
  final Color color; // Default color will be set to black
  final String? location;

  const EventPreviewWidget({
    super.key,
    required this.eventNameController,
    required this.selectedDate,
    this.backgroundImageUrl,
    this.backgroundGradient,
    this.color = CupertinoColors.black, // Default to black
    this.location,
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
                  color: CupertinoColors.black,
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
                        if (location != null && location!.isNotEmpty)
                          Expanded(
                            child: Text(
                              location!,
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
