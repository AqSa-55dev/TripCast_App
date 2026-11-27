import 'package:flutter/material.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import 'Explore_screen.dart';
import 'home_screen.dart';
import 'saved_journeys.dart';

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
      SavedJourneys(
        onPlanTap: () {
          // Switch to Explore tab when "Plan a journey" button is tapped
          _onItemTapped(1);
        },
      ),
      // Placeholder for Profile screen
      Container(
        color: AppColors.background,
        child: Center(
          child: Text(
            "Profile Screen",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: listOfScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.homeIcon, scale: 2, color: _selectedIndex == 0 ? AppColors.primary : AppColors.muted),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.exploreIcon, scale: 2, color: _selectedIndex == 1 ? AppColors.primary : AppColors.muted),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.saveIcon, scale: 2, color: _selectedIndex == 2 ? AppColors.primary : AppColors.muted),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.profileIcon, scale: 2, color: _selectedIndex == 3 ? AppColors.primary : AppColors.muted),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        onTap: _onItemTapped,
      ),
    );
  }
}

