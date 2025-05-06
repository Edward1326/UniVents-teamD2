import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/components/navbar.dart';
import 'package:univents/pages/organizations_details.dart';
import 'package:univents/pages/home_page.dart';
import 'package:univents/pages/search.dart';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  int _selectedIndex = 1;
  List<Map<String, dynamic>> organizations = [];
  List<Map<String, dynamic>> filteredOrgs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('organizations').get();

      final List<Map<String, dynamic>> orgs =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'name': data['name'] ?? 'Unnamed Org',
              'banner': data['banner'] ?? '',
            };
          }).toList();

      setState(() {
        organizations = orgs;
        filteredOrgs = orgs;
      });
    } catch (e) {
      print("Error fetching organizations: $e");
    }
  }

  void _filterOrganizations(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredOrgs =
          organizations
              .where((org) => org['name'].toLowerCase().contains(lowerQuery))
              .toList();
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Organizations',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3D56),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                onChanged: _filterOrganizations,
                decoration: InputDecoration(
                  hintText: 'Search Organization',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  children:
                      filteredOrgs.map((org) {
                        return OrganizationCard(
                          name: org['name'],
                          banner: org['banner'],
                        );
                      }).toList(),
                ),
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

class OrganizationCard extends StatelessWidget {
  final String name;
  final String banner;

  const OrganizationCard({super.key, required this.name, required this.banner});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    banner.isNotEmpty
                        ? NetworkImage(banner)
                        : const AssetImage('assets/placeholder.jpg')
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x57798093), Color(0xA6445C9A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => OrganizationDetailPage(
                              name: name,
                              banner: banner,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 74),
                  ),
                  child: const Text('View'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
