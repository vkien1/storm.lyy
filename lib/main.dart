import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:stormly/screens/second_screen.dart';
import 'package:stormly/screens/third_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/swipe_navigation_screen.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(
        ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue[800],
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.blue[800]),
          ),
        ),
      ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Task Manager',
            theme: themeProvider.getTheme, 
            initialRoute: '/',
            routes: {
              '/': (context) => LoginScreen(),
              '/homepage': (context) => SwipeNavigationScreen(), 
              '/login': (context) => LoginScreen(),
              '/second': (context) => SecondScreen(),
              '/third': (context) => ThirdScreen(),
              /*
              '/settings': (context) => SettingsScreen(),
              */
            },
          );
        },
      ),
    );
  }
}
