import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:musicnation/screens/favourite/favourite_screen.dart';
import 'package:musicnation/screens/home/home_screen.dart';
import 'package:musicnation/screens/playlist/playlist_screen.dart';
import 'package:musicnation/screens/settings/settings_page.dart';

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({Key? key}) : super(key: key);

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomeScreen(),
    PlaylistScreen(),
    FavouriteScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        color: const Color.fromRGBO(1, 7, 29, 1.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            // tabMargin: EdgeInsets.all(3),
            padding: const EdgeInsets.all(16),
            gap: 8,
            backgroundColor: const Color.fromRGBO(1, 7, 29, 1.0),
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 63, 58, 58),
            color: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.playlist_add_circle_rounded,
                text: 'Playlist',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Liked',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
