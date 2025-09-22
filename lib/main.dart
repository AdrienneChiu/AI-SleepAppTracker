import 'package:ai_sleepapp/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sleep_predictor_page.dart';
import 'providers/sleep_data_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SleepDataProvider(),
      child: const MyApp(),
    ),
  );
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
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue[800]),
      ),
      routes: {
        '/predict': (_) => const SleepPredictorPage(),
      },
      home: const LoginPage(),
    );
  }
}