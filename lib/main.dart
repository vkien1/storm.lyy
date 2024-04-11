import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'widgets/theme_provider.dart';
//screens
import 'widgets/swipe_navigation_screen.dart';
import 'screens/login_screen.dart';
import 'package:stormly/screens/second_screen.dart';
import 'package:stormly/screens/third_screen.dart';
import 'package:stormly/screens/map_screen.dart';
//screens

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
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            foregroundColor: Colors.grey[600],
            elevation: 0, 
          ),
          bottomAppBarColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[600],
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.grey[600]),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
              '/map': (context) => MapScreen(),
            },
          );
        },
      ),
    );
  }
}
