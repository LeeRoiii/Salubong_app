import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class EventCountdown extends StatefulWidget {
  final String eventTitle;
  final DateTime eventDate;
  final String backgroundImageUrl;

  const EventCountdown({
    Key? key,
    required this.eventTitle,
    required this.eventDate,
    required this.backgroundImageUrl,
  }) : super(key: key);

  @override
  _EventCountdownState createState() => _EventCountdownState();
}

class _EventCountdownState extends State<EventCountdown> with SingleTickerProviderStateMixin {
  Duration _timeUntilEvent = Duration.zero;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setupAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = widget.eventDate.difference(now);

      // Update duration or reset if the event has passed
      if (difference.isNegative) {
        setState(() {
          _timeUntilEvent = Duration.zero;
        });
        _timer?.cancel(); // Stop the timer if the event has passed
      } else {
        setState(() {
          _timeUntilEvent = difference;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false; // Prevent default back navigation
      },
      child: CupertinoPageScaffold(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.backgroundImageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _buildCountdownContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.share, color: Colors.white),
            onPressed: () {
              // Implement share functionality
              print('Share button pressed'); // Placeholder
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.eventTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildAnimatedCountdown(),
          SizedBox(height: 50),
          _buildEventDetails(),
        ],
      ),
    );
  }

  Widget _buildAnimatedCountdown() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animation.value * 0.05),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCountdownItem(_timeUntilEvent.inDays, 'DAYS'),
          _buildCountdownItem(_timeUntilEvent.inHours % 24, 'HOURS'),
          _buildCountdownItem(_timeUntilEvent.inMinutes % 60, 'MINUTES'),
          _buildCountdownItem(_timeUntilEvent.inSeconds % 60, 'SECONDS'),
        ],
      ),
    );
  }

  Widget _buildCountdownItem(int value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(CupertinoIcons.calendar, dateFormat.format(widget.eventDate)),
          SizedBox(height: 12),
          _buildDetailRow(CupertinoIcons.time, timeFormat.format(widget.eventDate)),
          SizedBox(height: 12),
          _buildDetailRow(CupertinoIcons.repeat, 'Repeats every year'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
