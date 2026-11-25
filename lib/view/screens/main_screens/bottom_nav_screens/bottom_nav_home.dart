import 'package:flutter/material.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import 'Explore_screen.dart';
import 'home_screen.dart';

class BottomNavHome extends StatefulWidget {
  const BottomNavHome({super.key});

  @override
  State<BottomNavHome> createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    debugPrint("Selected index: $_selectedIndex");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listOfScreens = [
      HomeScreen(
        onExploreTap: () {
          debugPrint("Callback received in BottomNavHome");
          _onItemTapped(1);
        },
      ),
      ExploreScreen(),
    ];
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: listOfScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Image.asset(AppAssets.homeIcon, scale: 2,color: AppColors.primary,), label: 'Home'),
          BottomNavigationBarItem(icon: Image.asset(AppAssets.exploreIcon, scale: 2,color: AppColors.primary,), label: 'Explore',),
          BottomNavigationBarItem(icon: Image.asset(AppAssets.saveIcon, scale: 2,color: AppColors.primary,), label: 'Saved'),
          BottomNavigationBarItem(icon: Image.asset(AppAssets.profileIcon,scale: 2,color: AppColors.primary,), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.border_grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
