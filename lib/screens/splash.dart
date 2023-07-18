import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/model/CategoryModel.dart';
import 'package:phonepeproperty/screens/home.dart';
import 'package:phonepeproperty/screens/location/selectLocation.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phonepeproperty/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<CategoryModel> _modelCategory;
  bool _error;
  bool _loading;

  @override
  void initState() {
    super.initState();
    startTimer();
    _error = false;
    _loading = true;
    _modelCategory = [];
    //fetchAppConfidData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: cDarkBlue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/img/icon.png')),
                ),
              ),
              /* _loading == true
                  ? Container(
                      margin: EdgeInsets.all(30.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Container(), */
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text('FIND YOUR DREAM PROPERTY\n\nSELL YOUR PROPERTY',
                    style: Palette.whiteSubTitle2, textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(milliseconds: 2000), () {
      navigateUser(); //It will redirect  after 2 seconds
    });
  }

  /* void navigateUser() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) {
        return Home();
      },
      settings: RouteSettings(name: '/home'),
    ));
  } */

  void navigateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var status = preferences.getBool('isLoggedIn') ?? false;
    var stateName = preferences.getString('state_name');
    print(stateName);
    if (stateName != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) {
          return Home();
        },
        settings: RouteSettings(name: '/home'),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) {
          return SelectLocation();
        },
        settings: RouteSettings(name: '/login'),
      ));
    }
  }

  /* Future<void> fetchAppConfidData() async {
    try {
      final response =
          await http.get("${Constants.APP_CONFIG_URL}&lang_code=en");
      List<CategoryModel> fetchedPhotos =
          CategoryModel.parseList(json.decode(response.body));
      setState(() {
        _loading = false;
        _modelCategory.addAll(fetchedPhotos);
        print(fetchedPhotos);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  } */

  Future<void> fetchAppConfidData() async {
    final String url = "${Constants.APP_CONFIG_URL}&lang_code=en";

    http.Response response = await http.post(
      url,
    );

    //object response
    var decode = json.decode(response.body);

    var _status = decode['status'];
    List categoryData = decode['categories'];
    List<CategoryModel> setCategory = CategoryModel.parseList(categoryData);

    setState(() {
      _modelCategory.addAll(setCategory);
      print(categoryData);

      if (_status == "Success") {
        //_loading = false;
        navigateUser();
      } else {
        _loading = true;
      }
    });
  }
}
