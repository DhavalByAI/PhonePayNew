import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonepeproperty/config/routes.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/utils/servicelocator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.grey,
        accentColor: Palette.themeColor,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.blueGrey[900],
        accentColor: Palette.themeColor,
        canvasColor: Colors.black,
        cardColor: Colors.blueGrey[900],
        bottomAppBarColor: Colors.grey[900],
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'PhonePe Property',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        routes: routes,

        //home: DemoAdditionalInfo(),
      ),
    );
  }
}
