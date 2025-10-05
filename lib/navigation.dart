import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Your pages
import 'home_page.dart';
import 'Insights Page/insights_page.dart';
import 'Info Page/info_page.dart';
import 'account_page.dart';

// Providers
import 'providers/sleep_data_provider.dart';
import 'providers/session_provider.dart';

// Models + utils
import 'models/sleep_stage_result.dart';
import 'utils/synthetic_sleep.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 1; // default = HomePage
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      InsightsPage(),
      HomePage(),
      InfoPage(),
    ];

    // Seed several weeks of fake nights only once (when no data exists yet).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<SleepDataProvider>(context, listen: false);
      if (p.results.isEmpty) {
        _seedPastNights(p, days: 42); // ~6 weeks; adjust as needed
      }
    });
  }

  void _seedPastNights(SleepDataProvider p, {int days = 42}) {
    final now = DateTime.now();
    // Seed oldest -> newest so provider.latest is the most recent day
    for (int i = days; i >= 1; i--) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final map = syntheticNight(seed: date.millisecondsSinceEpoch);
      p.addResult(SleepStageResult(timestamp: date, stageDurations: map));
    }
  }

  void _goToAccountPage() {
    final session = Provider.of<SessionProvider>(context, listen: false);
    final userData = session.user ?? {};

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(
          userData: userData.map((k, v) => MapEntry(k, v.toString())),
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
        onDestinationSelected: (index) =>
            setState(() => currentPageIndex = index),
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
