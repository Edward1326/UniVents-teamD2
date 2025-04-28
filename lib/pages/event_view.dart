import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  final String eventTitle;
  final String eventDate;
  final String eventLocation;
  final String organizer;
  final String slotsRemaining;

  const EventView({
    super.key,
    required this.eventTitle,
    required this.eventDate,
    required this.eventLocation,
    this.organizer = 'Ateneo Culture and Arts Cluster',
    this.slotsRemaining = '18 slots remaining',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image with Gradient Overlay (1/3 of screen)
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/placeholder.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF163C9F).withOpacity(0.34),
                    ],
                  ),
                ),
              ),
              // Back Button
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Event Details Card (positioned halfway over the image)
          Transform.translate(
            offset: const Offset(0, -60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    eventTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Event Details with Icons
                  _buildDetailRow(Icons.location_on, eventLocation),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.access_time, eventDate),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.group, organizer),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.people, slotsRemaining),
                ],
              ),
            ),
          ),

          // Event Overview Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Event Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF163C9F),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Map',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF163C9F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Unleash your creativity and enhance your artistic skills at our Portrait Workshop! This hands-on session is designed for participants at all levels—whether you\'re a budding artist or looking to refine your portrait techniques. Guided by experienced instructors, you\'ll explore the fundamentals of portrait creation, including:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Observational Drawing Techniques'),
                        Text('• Creative Mark-Making'),
                        Text('• Live Model Practice'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Join Event Button
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
}
