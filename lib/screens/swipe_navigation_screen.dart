import 'package:flutter/material.dart';
import 'package:stormly/screens/home_screen.dart';
import 'package:stormly/screens/second_screen.dart';
import 'package:stormly/screens/third_screen.dart';

class SwipeNavigationScreen extends StatefulWidget {
  @override
  _SwipeNavigationScreenState createState() => _SwipeNavigationScreenState();
}
class _SwipeNavigationScreenState extends State<SwipeNavigationScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Widget> _screens = [
    HomeScreen(),
    SecondScreen(),
    ThirdScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
