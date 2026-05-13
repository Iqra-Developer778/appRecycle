import 'package:flutter/material.dart';
import 'home.dart';
import 'points.dart';
import 'profile.dart';
import 'ai_tips.dart';
 import 'history.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  late List<Widget> pages;

  late Home homePage;
  late PointsPage points;
  late ProfilePage profilePage;
  late AiTipsPage aiTipsPage;
  late HistoryPage historyPage;
  int currentTabIndex = 0;

  @override
  void initState() {


    homePage = Home();
    points = PointsPage();
    profilePage = ProfilePage();
    aiTipsPage =AiTipsPage();
    historyPage = HistoryPage();

    pages = [homePage, points, aiTipsPage, historyPage, profilePage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },

        items: [
          Icon(Icons.home, color: Colors.white, size: 34.0),
          Icon(Icons.point_of_sale, color: Colors.white, size: 34.0),

          Icon(Icons.smart_toy, color: Colors.white, size: 34.0),
          Icon(Icons.history, color: Colors.white),
          Icon(Icons.person, color: Colors.white, size: 34.0),
        ],
      ), // CurvedNavigationBar

      body: pages[currentTabIndex],
    ); // Scaffold
  }
}