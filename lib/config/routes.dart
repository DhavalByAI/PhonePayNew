import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/screens/home.dart';
import 'package:phonepeproperty/screens/location/selectLocation.dart';
import 'package:phonepeproperty/screens/splash.dart';


final routes = {
  '/':  (BuildContext context) => SplashScreen(),
  '/home': (BuildContext context) => Home(),
  '/state': (BuildContext context) => SelectLocation(),
  '/login': (BuildContext context) => Login(),

};