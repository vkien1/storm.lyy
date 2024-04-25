import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui'; // Required for ImageFilter

import 'package:stormly/screens/home_screen.dart';
import 'package:stormly/screens/second_screen.dart';
import 'package:stormly/screens/third_screen.dart';
import 'package:stormly/screens/map_screen.dart';
// import 'package:stormly/screens/settings_screen.dart'; // This import is no longer needed.

class SwipeNavigationScreen extends StatefulWidget {
  @override
  _SwipeNavigationScreenState createState() => _SwipeNavigationScreenState();
}

class _SwipeNavigationScreenState extends State<SwipeNavigationScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  // State variables for toggles.
  bool home = false;
  bool lockScreen = false;
  bool notification = true;
  bool statusBar = true;

  final List<Widget> _screens = [
    HomeScreen(),
    SecondScreen(),
    ThirdScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Opacity(
              opacity: 0.7,
              child: Container(
                height: kToolbarHeight,
                color: Colors.grey[900]?.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.map, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapScreen()),
                          );
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_screens.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Color.fromARGB(255, 83, 83, 83),
                            ),
                          );
                        }),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _showSettingsDrawer(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            children: [
              SwitchListTile(
                title: Text('Fahrenheit', style: TextStyle(color: Colors.white)),
                value: home,
                onChanged: (bool value) {
                  setState(() {
                    home = value;
                  });
                  Navigator.pop(context);
                },
              ),
              SwitchListTile(
                title: Text('Celsius', style: TextStyle(color: Colors.white)),
                value: lockScreen,
                onChanged: (bool value) {
                  setState(() {
                    lockScreen = value;
                  });
                  Navigator.pop(context);
                },
              ),
              // More toggles can be added here
              ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout actions
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
