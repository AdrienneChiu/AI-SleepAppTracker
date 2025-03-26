import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App for AI Sleep',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Dark Blue theme
        scaffoldBackgroundColor: Colors.blue[800], // Set background to dark blue
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800], // Set AppBar color to match scaffold background
        ),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0; // Tracks the current page index for the nav bar

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // AppBar title
        backgroundColor: theme.scaffoldBackgroundColor, // Use the same color as scaffold background
      ),
      body: <Widget>[

        // Home page
        const Center(
          child: Text(
            'Insights Here',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),

        // Insights page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text('Summary', style: TextStyle(color: Colors.blue)),
                  subtitle: Text('Hours Slept', style: TextStyle(color: Colors.blue)),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Sleep Tracker', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),

        // Info page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(70.0),
                  padding: const EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Information 1',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(70.0),
                padding: const EdgeInsets.all(70.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Information 2',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex], // Display the page based on current index
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        //indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.insights, size: 40),
            icon: const Icon(Icons.insights_outlined, size: 40),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.home, size: 40),
            icon: const Icon(Icons.home_outlined, size: 40),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.info, size: 40),
            icon: const Icon(Icons.info_outline, size: 40),
            label: '',
          ),
        ],
      ),
    );
  }
}
