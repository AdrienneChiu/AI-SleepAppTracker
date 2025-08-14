import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Insights Page/insights_page.dart';
import 'Info Page/info_page.dart';
import 'account_page.dart';

class NavigationExample extends StatefulWidget {
  final Map<String, dynamic> userData; // Updated type to dynamic

  const NavigationExample({super.key, required this.userData});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 1; // Default to HomePage
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll([
      InsightsPage(),
      const HomePage(),
      InfoPage(), // Removed userData parameter since it's not defined in InfoPage
    ]);
  }

  void _goToAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(
          userData: widget.userData.map((key, value) => MapEntry(key, value.toString())),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'SleepApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32, color: Colors.white),
            onPressed: _goToAccountPage,
            tooltip: 'Account',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.insights, size: 50),
            icon: Icon(Icons.insights_outlined, size: 50),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home, size: 50),
            icon: Icon(Icons.home_outlined, size: 50),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info, size: 50),
            icon: Icon(Icons.info_outline, size: 50),
            label: '',
          ),
        ],
      ),
    );
  }
}
