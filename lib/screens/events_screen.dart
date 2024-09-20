import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_countdown.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String dateString = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateString,
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: CupertinoColors.systemGrey,
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Upcoming Events',
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  EventCard(
                    eventTitle: 'My Birthday',
                    eventDate: DateTime(2024, 9, 30, 20, 48),
                    backgroundImageUrl: 'https://example.com/image1.jpg',
                    color: CupertinoColors.systemPink,
                  ),
                  SizedBox(height: 16),
                  EventCard(
                    eventTitle: 'Conference',
                    eventDate: DateTime(2024, 10, 5, 9, 0),
                    backgroundImageUrl: 'https://example.com/image2.jpg',
                    color: CupertinoColors.systemTeal,
                  ),
                  SizedBox(height: 16),
                  EventCard(
                    eventTitle: 'Wedding',
                    eventDate: DateTime(2024, 10, 7, 15, 30),
                    backgroundImageUrl: 'https://example.com/image3.jpg',
                    color: CupertinoColors.systemIndigo,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventTitle;
  final DateTime eventDate;
  final String backgroundImageUrl;
  final Color color;

  const EventCard({
    required this.eventTitle,
    required this.eventDate,
    required this.backgroundImageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = eventDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EventCountdown(
              eventTitle: eventTitle,
              eventDate: eventDate,
              backgroundImageUrl: backgroundImageUrl, // Pass the background image URL
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                backgroundImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      color.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        eventTitle,
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('MMMM d, yyyy').format(eventDate),
                        style: TextStyle(
                          color: CupertinoColors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$daysUntil ${daysUntil == 1 ? 'Day' : 'Days'} Until',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
