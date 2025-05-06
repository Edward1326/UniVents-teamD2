import 'package:flutter/material.dart';

class SavedView extends StatelessWidget {
  final Map<String, String> eventData;

  const SavedView({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background banner image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  eventData['banner'] ?? 'https://via.placeholder.com/300',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Full blue blur overlay
          Container(color: const Color(0xFF163C9F).withOpacity(0.6)),

          // Overlay content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Successfully Joined card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1FA565).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Successfully Joined!',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Kindly present the ticket below upon arrival:',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Ticket card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Event title
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            eventData['title'] ?? 'Untitled Event',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF163C9F),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                          color: Color(0xFF163C9F),
                          thickness: 2,
                          height: 20,
                        ),
                        const SizedBox(height: 12),

                        // Ticket details
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Color(0xFF163C9F),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventData['speaker'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF163C9F),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF163C9F),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventData['dateTime'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF163C9F),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF163C9F),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventData['venue'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF163C9F),
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

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
