import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Insights Page/insights_page.dart';
import 'Info Page/info_page.dart';
import 'account_page.dart';

class NavigationExample extends StatefulWidget {
  final Map<String, dynamic>? userData; // nullable

  const NavigationExample({super.key, this.userData});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 1; // default = HomePage
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const InsightsPage(),
      const HomePage(),
      const InfoPage(),
    ];
  }

  void _goToAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(
          userData: widget.userData?.map((k, v) => MapEntry(k, v.toString())) ?? {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Padding(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32, color: Colors.white),
            onPressed: _goToAccountPage,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(() => currentPageIndex = index),
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
