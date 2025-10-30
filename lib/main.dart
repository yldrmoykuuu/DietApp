import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healty/controllers/goal_controller.dart';
import 'package:healty/controllers/user_provider.dart';
import 'package:healty/controllers/besin_controller.dart';
import 'package:healty/controllers/meal_controller.dart';
import 'package:healty/controllers/water_controller.dart';
import 'package:healty/screens/mainScreen.dart';
import 'package:healty/screens/profileScreen.dart';
import 'package:healty/screens/register.dart';
import 'package:healty/screens/splashScreen.dart';


import 'package:provider/provider.dart';

import 'controllers/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();





  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WaterController()),
        ChangeNotifierProvider(create: (_) => MealController()),
        ChangeNotifierProvider(create: (_) => GoalController()),

        ChangeNotifierProvider(create: (_) => BesinController()),
        Provider<AuthService>(create: (_) => AuthService()),
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
      title: 'Healty App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MainScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
