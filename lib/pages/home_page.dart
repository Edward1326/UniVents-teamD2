import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/components/navbar.dart';
import 'package:univents/pages/event_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  String selectedCategory = 'Tech';
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];

  final List<String> categories = [
    'Tech',
    'Business',
    'Music',
    'Health',
    'Education',
    'Volunteerism',
    'Faith',
    'Art',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collectionGroup('events').get();

      List<Map<String, dynamic>> loadedEvents = [];

      for (var doc in snapshot.docs) {
        final eventData = doc.data() as Map<String, dynamic>;
        final List<dynamic> statusList = eventData['status'] ?? [];

        if ((eventData['orguid'] != null) &&
            (statusList.contains('pending') || statusList.contains('done'))) {
          loadedEvents.add({
            'id': doc.id,
            'orgId': (eventData['orguid'] as DocumentReference).id,
            'title': eventData['title'] ?? '',
            'banner': eventData['banner'] ?? '',
            'date': formatDate(eventData['datetimestart']),
            'location': eventData['location'] ?? '',
            'category': eventData['category'] ?? '',
          });
        }
      }

      setState(() {
        allEvents = loadedEvents;
        filterEvents();
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  void filterEvents() {
    setState(() {
      filteredEvents =
          allEvents
              .where(
                (event) =>
                    (event['category'] ?? '').toLowerCase() ==
                    selectedCategory.toLowerCase(),
              )
              .toList();
    });
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate().add(const Duration(hours: 8));
    return "${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year} | ${_formatTime(dateTime)}";
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      filterEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(),
              const SizedBox(height: 20),
              _buildCategorySelector(),
              const SizedBox(height: 20),
              _buildEventGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, John Edward!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF163C9F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to explore different Events?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF163C9F),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF163C9F), width: 2),
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('lib/images/profile.jpg'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose an Event:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 28,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return GestureDetector(
                onTap: () => _onCategorySelected(category),
                child: IntrinsicWidth(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF163C9F) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF163C9F)),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: isSelected ? Colors.white : Color(0xFF163C9F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredEvents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(
            event['banner'] ?? 'https://via.placeholder.com/150',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF798093).withOpacity(0.7),
              Color(0xFF445C9A).withOpacity(0.8),
              Color(0xFF163C9F).withOpacity(0.9),
            ],
            stops: const [0.34, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      event['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    event['date'] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    event['location'] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EventView(
                                eventId: event['id'],
                                orgId: event['orgId'],
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF163C9F),
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
