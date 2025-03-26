import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//App settings
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

// Navigation bar
class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

// Navigation bar state
class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0; // Tracks the current page index for the nav bar

  // Pages for navigation
  final List<Widget> pages = [
    const InsightsPage(),  
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


class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Insights Page Content',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

//Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            color: Colors.blue[100], // Light Blue Background for the summary
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
              //   'This section provides a summary of your sleep analysis, highlighting key metrics such as sleep stages, duration, and quality.',
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
            color: Colors.blue[100], // Light Blue Background for the sleep tracker
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
              //   'Track your sleep cycles, including deep sleep, light sleep, and REM sleep, and monitor any potential sleep disturbances.',
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

//Insights Page
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    // Define the titles for the information boxes
    final List<String> infoTitles = [
      'EGG', 
      'EOG', 
      'EMG'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PSG',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor, // Match the background color
      ),
      body: ListView.builder(
        itemCount: infoTitles.length, // Number of information boxes
        itemBuilder: (BuildContext context, int index) {
          // Different content for each box
          String bodyText = '';
          switch (index) {
            case 0:
              bodyText = 'Lorem Ipsum is simply dummy text';
              break;
            case 1:
              bodyText = 'Lorem Ipsum is simply dummy text';
              break;
            case 2:
              bodyText = 'Lorem Ipsum is simply dummy text';
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
                crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
                children: [
                  // Center the title using the Center widget
                  Center(
                    child: Text(
                      infoTitles[index], // Dynamically set the title from the list
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between title and body
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
      ),
    );
  }
}
