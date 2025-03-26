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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), 
        scaffoldBackgroundColor: Colors.blue[800], 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800], 
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

  // Pages for navigation
  final List<Widget> pages = [
    const HomePage(),      
    const InsightsPage(),
    const InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PSG',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 32, 
            fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page Content',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Section
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100], 
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 90, 188)),
                ),
              const SizedBox(height: 8.0),
              // const Text(
              //   'Text in summary, will add pie chart and sleep quality',
              //   style: TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
        
        // Sleep Tracker Section
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100], 
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' Sleep \nTracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 90, 188)),
                ),
              const SizedBox(height: 8.0),
              // const Text(
              //   'Will place start and pause here',
              //   style: TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
        
        // Add more sections if needed
      ],
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    // Titles for the information boxes on info page
    final List<String> infoTitles = [
      'EEG', 
      'EOG', 
      'EMG'
    ];

    return ListView.builder(
      itemCount: infoTitles.length, // Number of information boxes
      itemBuilder: (BuildContext context, int index) {
        // Different content for each box
        String bodyText = '';
        switch (index) {
          case 0:
            bodyText = 'Lorem Ipsum is simply dummy text.';
            break;
          case 1:
            bodyText = 'Lorem Ipsum is simply dummy text.';
            break;
          case 2:
            bodyText = 'Lorem Ipsum is simply dummy text.';
            break;
        }

        return Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(40.0),
            height: 150.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: index == 0
                  ? const Color.fromARGB(255, 241, 165, 190)
                  : index == 1
                      ? const Color.fromARGB(255, 167, 142, 235)
                      : Colors.green,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use the infoTitles list to get the title for each information box
                Text(
                  infoTitles[index], // Dynamically set the title from the list
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Space between title and body, adjust
                Text(
                  bodyText,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}