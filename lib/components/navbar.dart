// components/custom_navbar.dart
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF163C9F), // Dark Blue
        unselectedItemColor: const Color(
          0xFF163C9F,
        ).withOpacity(0.3), // Light Blue
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_none, 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.group_outlined, 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 2, isHome: true),
            label: '',
          ),
          BottomNavigationBarItem(icon: _buildIcon(Icons.search, 3), label: ''),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.explore_outlined, 4),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index, {bool isHome = false}) {
    bool isSelected = selectedIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color:
              isSelected
                  ? const Color(0xFF163C9F)
                  : const Color(0xFF163C9F).withOpacity(0.3),
          size: isHome && isSelected ? 28 : 24, // Slightly bigger for home
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF163C9F),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
