import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/screens/home.dart';
import 'package:podcast/screens/settings.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  dynamic currentPage = const HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.grey.shade100,
        selectedIndex: _currentIndex,
        onItemSelected: (index) => _onItemSelected(index),
        items: [
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.houseChimney),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Home',
              ),
            ),
            activeColor: const Color(0xff7E57C2),
            inactiveColor: Colors.black54,
          ),
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.searchengin),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Search'),
            ),
            activeColor: const Color(0xff7E57C2),
            inactiveColor: Colors.black54,
          ),
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.solidHeart),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Favourites'),
            ),
            activeColor: const Color(0xff7E57C2),
            inactiveColor: Colors.black54,
          ),
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.gear),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Settings'),
            ),
            activeColor: const Color(0xff7E57C2),
            inactiveColor: Colors.black54,
          ),
        ],
      ),
    );
  }

  _onItemSelected(index) {
    setState(() {
      _currentIndex = index;

      if (index == 0) {
        setState(() {
          currentPage = const HomePage();
        });
      } else if (index == 3) {
        setState(() {
          currentPage = const SettingsPage();
        });
      }
    });
  }
}
