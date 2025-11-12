// Author: Adrienne Chiu (2025)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'providers/sleep_data_provider.dart';
import 'providers/session_provider.dart';


import 'login_page/login_page.dart';
import 'navigation.dart';
import 'sleep_predictor_page.dart';
import 'Insights Page/insights_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SleepDataProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App for AI Sleep',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.blue[800],
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue[800]),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const NavigationExample(), 
        '/insights': (_) => const InsightsPage(),
        '/predict': (_) => const SleepPredictorPage(),
      },
    );
  }
}










// Author: Adrienne Chiu (2025)