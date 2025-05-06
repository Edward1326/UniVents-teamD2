import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizationDetailPage extends StatelessWidget {
  final String name;
  final String banner;

  const OrganizationDetailPage({
    super.key,
    required this.name,
    required this.banner,
  });

  Future<Map<String, dynamic>?> fetchOrgDetails() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('organizations')
              .where('name', isEqualTo: name)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
    } catch (e) {
      print("Error fetching org details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchOrgDetails(),
        builder: (context, snapshot) {
          final orgData = snapshot.data;
          final description =
              orgData?['description'] ??
              'This organization is dedicated to student leadership and community development.';
          final email = orgData?['email'] ?? 'sample@email.com';
          final link = orgData?['link'] ?? 'https://event.link';
          final facebook = orgData?['facebook'] ?? 'facebook.com/orgpage';

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(23.31),
                            bottomRight: Radius.circular(23.31),
                          ),
                          child: Container(
                            height: screenHeight / 2.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    banner.isNotEmpty
                                        ? NetworkImage(banner)
                                        : const AssetImage(
                                              'assets/placeholder.jpg',
                                            )
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight / 2.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(23.31),
                              bottomRight: Radius.circular(23.31),
                            ),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: _TabItem(title: "About", isActive: true),
                          ),
                          _TabItem(title: "Photos"),
                          _TabItem(title: "Upcoming Events"),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: _TabItem(title: "More"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF163C9F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InfoRow(icon: Icons.email, text: email, indent: 40.0),
                    InfoRow(icon: Icons.link, text: link, indent: 40.0),
                    InfoRow(icon: Icons.facebook, text: facebook, indent: 40.0),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF163C9F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double indent;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.indent = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(indent, 8, 20, 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF163C9F)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Color(0xFF163C9F)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF163C9F),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(width: 30, height: 2, color: const Color(0xFF163C9F)),
      ],
    );
  }
}
