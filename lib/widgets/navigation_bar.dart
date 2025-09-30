import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;

  const NavBar({required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: const Color(0xFFF7F7F7),
      ),
      height: 75,
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context,
              icon: Icons.home,
              isSelected: selectedIndex == 0,
              routeName: '/homepage'),
          // Search icon
          _buildNavItem(
            context,
            icon: Icons.remove_red_eye_outlined,
            isSelected: selectedIndex == 1,
            routeName: '/scoutpage',
          ),
          // Bar chart icon
          _buildNavItem(
            context,
            icon: Icons.description_outlined,
            isSelected: selectedIndex == 2,
            routeName: '/datapage',
          ),
          // Settings icon
          _buildNavItem(
            context,
            icon: Icons.settings,
            routeName: '/settingspage',
            isSelected: selectedIndex == 3,
          ),
        ],
      ),
    );
  }

  /// Helper method to create a navigation item
  Widget _buildNavItem(BuildContext context,
      {required IconData icon, required bool isSelected, String? routeName}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          color:
              isSelected ? const Color.fromRGBO(50, 50, 124, 1) : Colors.black,
          onPressed: () {
            if (routeName != null) {
              Navigator.pushNamedAndRemoveUntil(
                  context, routeName, (route) => false);
            }
          },
        ),
        if (isSelected)
          Container(
            width: 24, // Match the icon width
            height: 2,
            color: const Color.fromRGBO(50, 50, 124, 1),
          ),
      ],
    );
  }
}
