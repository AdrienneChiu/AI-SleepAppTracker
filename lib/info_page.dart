import 'package:flutter/material.dart';

//Information Page
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
                        : const Color.fromRGBO(76, 175, 80, 1),
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
