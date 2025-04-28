import 'package:flutter/material.dart';
import 'package:univents/components/navbar.dart';
import 'package:univents/pages/event_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  String selectedCategory = 'Art';

  final List<String> categories = ['Art', 'Sports', 'Tech', 'Business'];

  final List<Map<String, String>> eventList = [
    {
      'title': 'Portrait Workshop',
      'date': 'April 1, 2025 | 10:00AM',
      'location': '4th Martin Hall',
    },
    {
      'title': 'Origami Workshop',
      'date': 'April 2, 2025 | 11:00AM',
      'location': '4th Martin Hall',
    },
    {
      'title': 'ESPORRE',
      'date': 'April 3, 2025 | 1:00PM',
      'location': '4th Martin Hall',
    },
    {
      'title': 'MUGNA',
      'date': 'April 4, 2025 | 9:00AM',
      'location': '4th Martin Hall',
    },
    {
      'title': 'BALANGKAS',
      'date': 'April 5, 2025 | 3:00PM',
      'location': '4th Martin Hall',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
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
              // Top Greeting Row
              Row(
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
              ),
              const SizedBox(height: 20),

              // Category Selection
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
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () => _onCategorySelected(category),
                      child: IntrinsicWidth(
                        child: Container(
                          height: 28,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ), // 👈 MORE PADDING inside the button
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Color(0xFF163C9F) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFF163C9F)),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Color(0xFF163C9F),
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

              const SizedBox(height: 20),

              // Event Grid
              // Event Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eventList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('lib/images/placeholder.jpg'),
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
                                    eventList[index]['title']!,
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
                                  eventList[index]['date']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  eventList[index]['location']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EventView(
                                              eventTitle:
                                                  eventList[index]['title']!,
                                              eventDate:
                                                  eventList[index]['date']!,
                                              eventLocation:
                                                  eventList[index]['location']!,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF163C9F),
                                    minimumSize: const Size(
                                      double.infinity,
                                      30,
                                    ),
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
                },
              ),
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
}
