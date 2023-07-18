import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/screens/Auth/termscondition.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phonepeproperty/screens/yourAds.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String name = '';
  String email = '';
  String profileImg = '';
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin fblogin = FacebookLogin();

  bool isdark;

  @override
  void initState() {
    super.initState();
    checkUserLoginProfile();
    userData();
    print("init value " + isdark.toString());
    _darkSwitchValue(isdark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Profile', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 24.0),
          Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                /*---------------- Card Container -------------------*/
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
                  child: Card(
                    elevation: 12.0,
                    shadowColor: Colors.black26,
                    shape: Palette.topCardShape,
                    child: Column(
                      children: [
                        SizedBox(height: 60.0),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Text('$name', style: Palette.header),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Text('E-mail', style: Palette.subTitle)),
                              Container(
                                  child: Text('$email', style: Palette.title2)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text('Username',
                                      style: Palette.subTitle)),
                              Container(
                                  child:
                                      Text('$username', style: Palette.title2)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Divider(height: 0.0),
                        ListTile(
                          title: Text('My Ads', style: Palette.title2),
                          leading: Icon(Icons.photo_size_select_large),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YourAds(),
                              )),
                        ),
                        Divider(height: 0.0),
                        ListTile(
                          title: Text('Dark mode', style: Palette.title2),
                          leading: Icon(Icons.brightness_4_outlined),
                          trailing: Switch(
                              value: isdark,
                              activeColor: cDarkBlue,
                              onChanged: (value) {
                                setState(() {
                                  isdark = value;
                                  _switchToDarkMode(isdark);
                                });
                              }),
                          //onTap: () => changeBrightness(),
                        ),
                        Divider(height: 0.0),
                        ListTile(
                          title:
                              Text('Terms & Condition', style: Palette.title2),
                          leading: Icon(Icons.list_alt_outlined),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsCondition())),
                        ),
                        Divider(height: 0.0),
                        ListTile(
                          title: Text('Logout', style: Palette.title2),
                          leading: Icon(Icons.exit_to_app),
                          onTap: () => _logoutUser(),
                        ),
                      ],
                    ),
                  ),
                ),
                /*---------------- Profile Image Container -------------------*/

                Container(
                  width: 110.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Palette.themeColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset.fromDirection(1.5, 7),
                      ),
                    ],
                    image: profileImg != '' || profileImg != null
                        ? DecorationImage(
                            image: NetworkImage('$profileImg'),
                            fit: BoxFit.cover,
                          )
                        : Container(),
                    borderRadius: BorderRadius.all(Radius.circular(55.0)),
                    border: Border.all(
                      color: cDarkBlue,
                      width: 2.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      email = pref.getString('email');
      username = pref.getString('username');
      profileImg = pref.getString('profileImg');
    });

    print('Profile Name === $name');
  }

  Future<void> checkUserLoginProfile() async {
    var pref = await SharedPreferences.getInstance();
    var loginStatus = pref.getBool('isLoggedIn') ?? false;
    var googleSingin = pref.getBool('google-signin') ?? false;
    var fbSingin = pref.getBool('fb-signin') ?? false;
    print(loginStatus);

    if (loginStatus || googleSingin || fbSingin) {
      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile())); */
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void _logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //preferences?.clear();

    var googleSignIn = preferences.getBool('google-signin');
    var fbSignIn = preferences.getBool('fb-signin');

    preferences.setString('userid', '');
    preferences.setString('username', '');
    preferences.setString('name', '');
    preferences.setString('email', '');
    preferences.setString('profileImg', '');

    if (googleSignIn == true) {
      signOutGoogle();
      preferences?.setBool('google-signin', false);
    } else if (fbSignIn == true) {
      signOut();
      preferences?.setBool('fb-signin', false);
    } else {
      preferences?.setBool('isLoggedIn', false);
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print("User Signed Out");
  }

  Future<bool> signOut() async {
    await fblogin.logOut();
    return true;
  }

  Future<bool> _darkSwitchValue(bool isDark) async {
    var pref = await SharedPreferences.getInstance();
    isdark = pref.getBool('isDark') ?? false;
    print("get value" + isdark.toString());
    return false;
  }

  void _switchToDarkMode(bool isdark) async {
    var pref = await SharedPreferences.getInstance();

    if (!isdark) {
      // sets theme mode to light
      AdaptiveTheme.of(context).setLight();
      pref?.setBool('isDark', false);
      print(isdark);
    } else {
      // sets theme mode to dark
      AdaptiveTheme.of(context).setDark();
      pref?.setBool('isDark', true);
      print(isdark);
    }
  }
}
