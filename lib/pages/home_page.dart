import 'package:flutter/material.dart';
import 'package:univents/components/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Center(child: Text('Notifications')),
    Center(child: Text('Users')),
    Center(child: Text('Hello World', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search')),
    Center(child: Text('Explore')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
