import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/pages/event_view.dart';
import 'package:univents/components/navbar.dart';
import 'package:univents/pages/home_page.dart';
import 'package:univents/pages/organizations_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allEvents = [];
  bool _isLoading = false;

  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirestore();
  }

  Future<void> _fetchEventsFromFirestore() async {
    setState(() => _isLoading = true);

    try {
      final orgsSnapshot =
          await FirebaseFirestore.instance.collection('organizations').get();
      List<Map<String, dynamic>> allEvents = [];

      for (var org in orgsSnapshot.docs) {
        final orgId = org.id;
        final orgName = org.data()['name'] ?? 'Unknown Org';

        final eventsSnapshot =
            await FirebaseFirestore.instance
                .collection('organizations')
                .doc(orgId)
                .collection('events')
                .get();

        for (var event in eventsSnapshot.docs) {
          final data = event.data();
          allEvents.add({
            'eventId': event.id,
            'orgId': orgId,
            'title': data['title'] ?? 'Untitled Event',
            'orgName': orgName,
          });
        }
      }

      setState(() {
        _allEvents = allEvents;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching events: $e");
      setState(() => _isLoading = false);
    }
  }

  void _performSearch(String query) {
    final q = query.toLowerCase();

    final results =
        _allEvents.where((event) {
          final title = event['title'].toString().toLowerCase();
          final org = event['orgName'].toString().toLowerCase();
          return title.startsWith(q);
        }).toList();

    setState(() => _searchResults = results);
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrganizationsPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search events...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF163C9F)),
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(color: Color(0xFF163C9F)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Color(0xFF163C9F)),
        ),
      ),
    );
  }

  Widget _buildResultsLabel() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Results:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => EventView(
                  eventId: result['eventId'],
                  orgId: result['orgId'],
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF163C9F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            result['title'] ?? 'Untitled',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            result['orgName'] ?? '',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Search for an event'));
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildResultCard(_searchResults[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            if (_searchController.text.isNotEmpty) _buildResultsLabel(),
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
