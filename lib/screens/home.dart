import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/AddProducts/AddProductSOne.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/screens/CRM/crm.dart';
import 'package:phonepeproperty/screens/chats.dart';
import 'package:phonepeproperty/screens/dashboard.dart';
import 'package:phonepeproperty/screens/profile.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  bool _badgeVisible = true;

  @override
  void initState() {
    super.initState();
    _children = [Dashboard(), CRM(), Chats(), Profile()];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 2) {
        _badgeVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          /*------------------ body ----------------*/
          body: _children[_currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: cDarkBlue,
            onPressed: () => checkUserLogin(),
            child: Icon(Icons.add, color: Colors.white),
            mini: true,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // bottomNavigationBar: BottomNavigationBar(
          //   onTap: onTabTapped,
          //   currentIndex: _currentIndex,
          //   showSelectedLabels: false,
          //   showUnselectedLabels: false,
          //   type: BottomNavigationBarType.fixed,
          //   iconSize: 26.0,
          //   selectedItemColor: cDarkBlue,
          //   //elevation: 4.0,
          //   items: [
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.home_outlined), label: 'Home'),
          //     BottomNavigationBarItem(
          //       icon: _badgeVisible == true
          //           ? Badge(child: Icon(Icons.all_inbox))
          //           : Icon(Icons.all_inbox),
          //       label: 'Inquire',
          //     ),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.person_outline), label: 'Profile'),
          //   ],
          // ),
          bottomNavigationBar: BottomAppBar(
            //bottom navigation bar on scaffold
            //color: Colors.white,
            shape: CircularNotchedRectangle(), //shape of notch
            notchMargin:
                5, //notche margin between floating button and bottom appbar
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: _currentIndex == 0 ? cDarkBlue : Colors.grey,
                  ),
                  onPressed: () => setState(() => _currentIndex = 0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.people_alt_outlined,
                    color: _currentIndex == 1 ? cDarkBlue : Colors.grey,
                  ),
                  onPressed: () => setState(() => _currentIndex = 1),
                ),
                SizedBox(width: 15),
                IconButton(
                  icon: Icon(
                    Icons.store_mall_directory_outlined,
                    color: _currentIndex == 2 ? cDarkBlue : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _currentIndex = 2;
                    _badgeVisible = false;
                  }),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_pin_outlined,
                    color: _currentIndex == 3 ? cDarkBlue : Colors.grey,
                  ),
                  onPressed: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<void> checkUserLogin() async {
    var pref = await SharedPreferences.getInstance();
    var loginStatus = pref.getBool('isLoggedIn') ?? false;
    var googleSingin = pref.getBool('google-signin') ?? false;
    var fbSingin = pref.getBool('fb-signin') ?? false;
    print(loginStatus);

    if (loginStatus || googleSingin || fbSingin) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddProductSOne('', '', '', '', '', '')));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //title: Text('Do you want to exit an App', style: _subTitle,),
            content: Text(
              'Do you want to exit PhonePe Property',
              style: Palette.title,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
