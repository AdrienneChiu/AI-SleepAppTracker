import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Insights Page/insights_page.dart';
import 'Info Page/info_page.dart';

// Navigation bar
class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

// Navigation bar state
class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 1; // Tracks the current page index for the nav bar

  // Pages for navigation
  final List<Widget> pages = [
    InsightsPage(),  
    const HomePage(),
    const InfoPage(),    
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '', //If i ever need a title for app
          style: TextStyle(
            color: Colors.white, // Title text color
            fontSize: 32, // Bigger font size
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor, // Match app bar color to background
      ),
      body: pages[currentPageIndex], // Display the page based on the current index
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index; // Switch between pages
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.insights, size: 50),
            icon: const Icon(Icons.insights_outlined, size: 50),
            label: '',  // Home now points to the InsightsPage
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.home, size: 50),
            icon: const Icon(Icons.home_outlined, size: 50),
            label: '',  // Insights now points to the HomePage
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.info, size: 50),
            icon: const Icon(Icons.info_outline, size: 50),
            label: '', // Info page will show "PSG" title
          ),
        ],
      ),
    );
  }
}
