import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventView extends StatefulWidget {
  final String eventId;
  final String orgId;

  const EventView({super.key, required this.eventId, required this.orgId});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  bool _isMapSelected = false;
  Map<String, dynamic>? eventData;
  String? organizerName;
  int slotsRemaining = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  Future<void> fetchEventDetails() async {
    try {
      final eventDoc =
          await FirebaseFirestore.instance
              .collection('organizations')
              .doc(widget.orgId)
              .collection('events')
              .doc(widget.eventId)
              .get();

      final attendeesSnapshot =
          await FirebaseFirestore.instance
              .collection('organizations')
              .doc(widget.orgId)
              .collection('events')
              .doc(widget.eventId)
              .collection('attendees')
              .get();

      final orgDoc =
          await FirebaseFirestore.instance
              .collection('organizations')
              .doc(widget.orgId)
              .get();

      if (eventDoc.exists) {
        final event = eventDoc.data() as Map<String, dynamic>;
        final totalSlots = event['total_slots'] ?? 0;
        final attendeesCount = attendeesSnapshot.size;

        setState(() {
          eventData = event;
          slotsRemaining = totalSlots - attendeesCount;
          organizerName =
              orgDoc.exists
                  ? (orgDoc.data()?['name'] ?? 'Organizer')
                  : 'Organizer';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Event not found!');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching event details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (eventData == null) {
      return const Scaffold(body: Center(child: Text('Event not found')));
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      eventData!['banner'] ?? 'https://via.placeholder.com/150',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF163C9F).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData!['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        Icons.location_on,
                        eventData!['location'] ?? 'Unknown Location',
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        Icons.calendar_month,
                        formatEventDateRange(
                          eventData!['datetimestart'],
                          eventData!['datetimeend'],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        Icons.group,
                        organizerName ?? 'Organizer',
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        Icons.chair,
                        '$slotsRemaining slots remaining',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          _buildTabButtons(),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventData!['description'] ?? 'No Description Provided.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF163C9F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join Event',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF163C9F), size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isMapSelected = false;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Event Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163C9F),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 2,
                  width: 111,
                  color:
                      !_isMapSelected
                          ? const Color(0xFF163C9F)
                          : Colors.transparent,
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              setState(() {
                _isMapSelected = true;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Map',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163C9F),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 2,
                  width: 40,
                  color:
                      _isMapSelected
                          ? const Color(0xFF163C9F)
                          : Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatEventDateRange(dynamic startTimestamp, dynamic endTimestamp) {
    if (startTimestamp == null) return 'No start date';

    DateTime start = (startTimestamp as Timestamp).toDate().add(
      const Duration(hours: 8),
    );
    DateTime? end =
        endTimestamp != null
            ? (endTimestamp as Timestamp).toDate().add(const Duration(hours: 8))
            : null;

    if (end == null || end.isBefore(start)) {
      return "${_getMonthName(start.month)} ${start.day}, ${start.year} | ${_formatTime(start)}";
    }

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return "${_getMonthName(start.month)} ${start.day}, ${start.year} | ${_formatTime(start)} - ${_formatTime(end)}";
    }

    return "${_getMonthName(start.month)} ${start.day} - ${_getMonthName(end.month)} ${end.day}, ${end.year} | ${_formatTime(start)} - ${_formatTime(end)}";
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute$period";
  }
}
