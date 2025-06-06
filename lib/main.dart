import 'package:flutter/material.dart';
import 'navigation.dart';

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



