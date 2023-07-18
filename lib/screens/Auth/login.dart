import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:phonepeproperty/screens/Auth/forgetPass.dart';
import 'package:phonepeproperty/screens/Auth/privacypolicy.dart';
import 'package:phonepeproperty/screens/Auth/singup.dart';
import 'package:phonepeproperty/screens/Auth/termscondition.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  //Facebook login
  Map userProfile;
  final facebookLogin = FacebookLogin();
  FacebookLogin fblogin = FacebookLogin();

  bool _isLoggedIn = false;

  String _status;

  bool _validate = false;
  bool _obsecurePass = true;

  String _message = '';

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    //googleSignIn = GoogleSignIn();
  }

  /* ----------------- padding, margin --------------- */
  EdgeInsets _five = EdgeInsets.all(5.0);
  EdgeInsets _standard = EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0);

  /* ----------------- Main Build Function --------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Palette.themeColor,
      key: _scaffoldKey,
      /*------------- Body -------------*/
      body: WillPopScope(
        onWillPop: () async {
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

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);

          return true;
        },
        child: Container(
          decoration: Palette.authBg,
          child: ListView(
            children: [
              SizedBox(height: 60.0),
              Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/img/icon.png')),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: _standard,
                child: Column(
                  children: [
                    /*------------- UserName -------------*/
                    Padding(
                      padding: _standard * 2,
                      child: TextField(
                        controller: userNameController,
                        keyboardType: TextInputType.name,
                        style: Palette.textFieldWhite,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Email / Username',
                          labelStyle: Palette.textFieldLabelWhite,
                          errorText: _validate ? 'Value Can\'t be empty' : null,
                        ),
                      ),
                    ),

                    /*------------- Password -------------*/
                    Padding(
                      padding: _standard * 2,
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obsecurePass,
                        style: Palette.textFieldWhite,
                        //keyboardType: TextInputType.,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Password',
                            labelStyle: Palette.textFieldLabelWhite,
                            errorText:
                                _validate ? 'Value Can\'t be empty' : null,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obsecurePass = !_obsecurePass;
                                });
                              },
                              child: Icon(
                                _obsecurePass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPass(),
                                ));
                          },
                          child: Text(
                            'Forgot Password ? ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.0),

                    /*------------- Sign in -------------*/
                    Padding(
                      padding: _standard * 2,
                      child: Row(
                        children: [
                          Expanded(
                              child: MaterialButton(
                            elevation: 8.0,
                            shape: Palette.buttonShape,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                if (userNameController.text.isEmpty) {
                                  _validate = true;
                                } else if (passwordController.text.isEmpty) {
                                  _validate = true;
                                } else {
                                  _validate = false;
                                  initOneSignal(context, 'login');
                                  //_loginApiCalling();
                                }
                              });
                            },
                            child: Padding(
                              padding: _five * 3,
                              child: Text('LOGIN', style: Palette.buttonText),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: _standard,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                initOneSignal(context, 'google');
                              }
                              // signInWithGoogle()
                              /*.then((result) {
                              if (result != null) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/home', (Route<dynamic> route) => false);
                              }
                            })*/
                              ,
                              child: Container(
                                height: 42.0,
                                width: 42.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/img/google.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              //onTap: () => loginWithFacebook(),
                              onTap: () {
                                initOneSignal(context, 'facebook');
                                //_showErrorDialogue('Comming Soon..!');
                              },
                              child: Container(
                                height: 42.0,
                                width: 42.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/img/fblogo.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0),
                    /*------------------- New user ----------------*/
                    Container(
                      margin: _standard,
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Divider(thickness: 2.0, color: Colors.white)),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ));
                            },
                            child: Text(
                              'New user? Register Now',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                  color: Colors.white),
                            ),
                          ),
                          Expanded(
                              child:
                                  Divider(thickness: 2.0, color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      margin: _standard,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: MaterialButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy())),
                                child: Text(
                                  'Privacy Policy',
                                  style: Palette.whiteLinkUnderline,
                                )),
                          ),
                          Container(
                            child: MaterialButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsCondition())),
                                child: Text(
                                  'Term & Conditions',
                                  style: Palette.whiteLinkUnderline,
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //
  /*-------------- Login Api Calling-------------*/
  //
  Future<void> _loginApiCalling(String deviceToken) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    var preferences = await SharedPreferences.getInstance();

    String _username = userNameController.text;
    String _password = passwordController.text;

    var req = {
      'username': _username,
      'password': _password,
      'device_token': deviceToken,
    };

    final String url = Constants.LOG_IN;

    http.Response response = await http.post(url, body: req);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    setState(() {
      //Navigator
      if (_status == 'success') {
        //set user details
        String userid = decode['user_id'].toString();
        String userName = decode['username'];
        String name = decode['name'] ?? "-";
        String email = decode['email'] ?? "-";
        String picture = decode['picture'];
        String token = decode['token'];

        print("Data ::: $userid, $userName, $name, $email, $picture");

        //set Data
        preferences.setString('userid', userid);
        preferences.setString('username', userName);
        preferences.setString('name', name);
        preferences.setString('email', email);
        preferences.setString('token', token);
        if (picture ==
            "https:\/\/phonepeproperty.com\/storage\/profile\/small_") {
          preferences.setString('profileImg',
              "https://phonepeproperty.com/storage/profile/small_default_user.png");
        } else {
          preferences.setString('profileImg', picture);
        }
        preferences?.setBool('isLoggedIn', true);

        Navigator.pop(_keyLoader.currentContext);
        //_register();
        print('Firebase Token Message : $_message');
        _showDialog();
      } else {
        Navigator.pop(_keyLoader.currentContext);
        String message = decode['message'];
        _showErrorDialogue(message);
      }
    });

    print(response.body);
  }

  Future<void> initOneSignal(BuildContext context, String loginType) async {
    /// Set App Id.
    await OneSignal.shared.setAppId(kOneSingleAppId);
    final status = await OneSignal.shared.getDeviceState();
    final String osUserID = status?.userId;

    print("OS ID :::::::: $osUserID");
    if (loginType == 'login') {
      _loginApiCalling(osUserID);
    } else if (loginType == 'google') {
      _showDealerBuilderDialogue("google", osUserID);
      //_handleGoogleSignIn(osUserID);
    } else if (loginType == 'facebook') {
      _showDealerBuilderDialogue("facebook", osUserID);
    }
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );
  }

  Future<void> _handleGoogleSignIn(String deviceToken, String userType) async {
    try {
      await _googleSignIn.signIn();
      GoogleSignInAccount user = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print("singinData:::::::::::::::::::$user");
      if (user != null) {
        // setState(() {
        //   name = user.displayName;
        //   email = user.email;
        //   image = user.photoUrl ?? "";
        //   gid = user.id;
        //   setPrefrence(name, email, image, gid);
        // });

        LoadingDialog.showLoadingDialog(context, _keyLoader);

        var preferences = await SharedPreferences.getInstance();

        var username = user.email.split("@");
        var req = {
          'username': username[0],
          'name': user.displayName,
          'email': user.email,
          'type': userType,
          'oauth_provider': 'google',
          'oauth_uid': user.id.toString(),
          'picture': user.photoUrl ?? "",
          'device_token': deviceToken,
        };

        print("Request body : $req");

        final String url = Constants.LOG_IN;

        http.Response response = await http.post(url, body: req);

        //object response
        Map<String, dynamic> decode = json.decode(response.body);
        print("Response ::: $decode");
        _status = decode['status'];

        setState(() {
          _googleSignIn.disconnect();
          //Navigator
          if (_status == 'success') {
            //set user details
            String userid = decode['user_id'].toString();
            String userName = decode['username'];
            String name = decode['name'] ?? "-";
            String email = decode['email'] ?? "-";
            String picture = decode['picture'];
            String token = decode['token'];

            print("Data ::: $userid, $userName, $name, $email, $picture");

            //set Data
            preferences.setString('userid', userid);
            preferences.setString('username', userName);
            preferences.setString('name', name);
            preferences.setString('email', email);
            preferences.setString('token', token);
            if (picture ==
                "https:\/\/phonepeproperty.com\/storage\/profile\/small_") {
              preferences.setString('profileImg',
                  "https://phonepeproperty.com/storage/profile/small_default_user.png");
            } else {
              preferences.setString('profileImg', picture);
            }
            preferences?.setBool('google-signin', true);

            Navigator.pop(_keyLoader.currentContext);
            //_register();
            print('Firebase Token Message : $_message');
            _showDialog();
          } else {
            Navigator.pop(_keyLoader.currentContext);
            String message = decode['error'];
            _showErrorDialogue(message);
          }
        });

        print(response.body);
      } else {
        _showErrorDialogue("Google login faild..!");
      }
    } catch (error) {
      Navigator.pop(_keyLoader.currentContext);
      print(error);
    }
  }

  Future<void> _handleFacebookSignIn(
      String deviceToken, String userType) async {
    try {
      // await _googleSignIn.signIn();
      // GoogleSignInAccount user = await _googleSignIn.signIn();

      // final GoogleSignInAuthentication googleSignInAuthentication =
      //     await user.authentication;

      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleSignInAuthentication.accessToken,
      //   idToken: googleSignInAuthentication.idToken,
      // );

      // bool isLoggedIn = await facebookLogin.isLoggedIn;

      FacebookLoginResult result =
          await facebookLogin.logIn(["email", "public_profile"]);

      facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          String token = result.accessToken.token;

          final AuthCredential credential =
              FacebookAuthProvider.credential(token);

          await _auth.signInWithCredential(credential);
          // final graphResponse = await http.get(
          //     'https://graph.facebook.com/v2.12/me?fields=name,email,picture.width(400)&access_token=${token}');
          // final profile = JSON.jsonDecode(graphResponse.body);

          //print("Profile ::: $profile");
          print("Profile credetial ::: $credential");

          // LoadingDialog.showLoadingDialog(context, _keyLoader);

          // var preferences = await SharedPreferences.getInstance();

          // var username = user.email.split("@");
          // var req = {
          //   'username': username[0],
          //   'name': user.displayName,
          //   'email': user.email,
          //   'type': userType,
          //   'oauth_provider': 'google',
          //   'oauth_uid': user.id.toString(),
          //   'picture': user.photoUrl ?? "",
          //   'device_token': deviceToken,
          // };

          // print("Request body : $req");

          // final String url = Constants.LOG_IN;

          // http.Response response = await http.post(url, body: req);

          // //object response
          // Map<String, dynamic> decode = json.decode(response.body);
          // print("Response ::: $decode");
          // _status = decode['status'];

          // setState(() {
          //   _googleSignIn.disconnect();
          //   //Navigator
          //   if (_status == 'success') {
          //     //set user details
          //     String userid = decode['user_id'].toString();
          //     String userName = decode['username'];
          //     String name = decode['name'] ?? "-";
          //     String email = decode['email'] ?? "-";
          //     String picture = decode['picture'];
          //     String token = decode['token'];

          //     print("Data ::: $userid, $userName, $name, $email, $picture");

          //     //set Data
          //     preferences.setString('userid', userid);
          //     preferences.setString('username', userName);
          //     preferences.setString('name', name);
          //     preferences.setString('email', email);
          //     preferences.setString('token', token);
          //     if (picture ==
          //         "https:\/\/phonepeproperty.com\/storage\/profile\/small_") {
          //       preferences.setString('profileImg',
          //           "https://phonepeproperty.com/storage/profile/small_default_user.png");
          //     } else {
          //       preferences.setString('profileImg', picture);
          //     }
          //     preferences?.setBool('google-signin', true);

          //     Navigator.pop(_keyLoader.currentContext);
          //     //_register();
          //     print('Firebase Token Message : $_message');
          //     _showDialog();
          //   } else {
          //     Navigator.pop(_keyLoader.currentContext);
          //     String message = decode['error'];
          //     _showErrorDialogue(message);
          //   }
          // });

          // print(response.body);

          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          _showErrorDialogue("Facebook login faild..!, ${result.errorMessage}");
          break;
      }
    } catch (error) {
      Navigator.pop(_keyLoader.currentContext);
      print(error);
    }
  }

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    var pref = await SharedPreferences.getInstance();
    String name;
    String username;
    String email;
    String profile;
    String pass;
    String loginType;

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    print('start gmail login');

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    print('end gmail login');

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      //set Data
      name = user.displayName;
      username = user.email
              .replaceAll('.', '')
              .replaceAll('@gmailcom', '')
              .replaceAll('@yahoocom', '') +
          user.uid.substring(0, 3);
      email = user.email;
      profile = user.photoURL;
      pass = user.uid.substring(0, 9);
      loginType = 'google-signin';
      print("uid ==== $pass");
      //set to profile
      pref.setString('name', name);
      pref.setString('username', username);
      pref.setString('email', email);
      pref.setString('profileImg', profile);
      pref?.setBool('google-signin', true);
      print('Google singin user Name === $username');

      print("username ====== $username");
      print("password ====== $pass");

      _googleloginApiCalling(username, pass, name, email, loginType);

      return '$user';
    }

    return null;
  }

  //facebook login
  loginWithFacebook() async {
    var pref = await SharedPreferences.getInstance();
    String name;
    String username;
    String email;
    String profileImg;
    String id;
    String pass;
    String loginType;

    final result =
        await facebookLogin.logIn(["email", "public_profile", "user_friends"]);
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;

    switch (result.status) {
      case FacebookLoginStatus.error:
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,email,picture.width(400)&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        userProfile = profile;
        _isLoggedIn = true;
        if (userProfile != null) {
          //set Data
          name = profile['name'];
          id = profile['id'];
          pass = id.substring(0, 9);
          username = profile['name'].toLowerCase().replaceAll(" ", "") +
              id.substring(0, 6);
          email = profile['name'].toLowerCase().replaceAll(" ", "") +
              id.substring(0, 3) +
              '@gmail.com';
          //email = profile['email'];
          profileImg = profile['picture']['data']['url'];
          loginType = 'fb-signin';

          //set to profile
          pref.setString('name', name);
          pref.setString('username', username);
          pref.setString('email', email);
          pref.setString('profileImg', profileImg);
          pref?.setBool('fb-signin', true);

          print('username == $username');
          print('email === $email');
          print('user profile === $profileImg');

          /*Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);*/

          //_googleloginApiCalling(username, pass, name, email, loginType);
          _facebookLoginApiCalling(username, pass, name, email, loginType);
        }

        break;
    }
  }

  /*--------------google facebook Signup Api Calling-------------*/
  Future<void> registerApiCall(String username, String password, String name,
      String email, String loginType) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);
    var preferences = await SharedPreferences.getInstance();
    String _userid;
    String _userName;
    String _name;
    String _email;
    String _picture;

    final String url =
        "${Constants.REGISTER}&username=$username&password=$password&name=$name&email=$email";

    http.Response response = await http.get(url);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    setState(() {
      Navigator.pop(_keyLoader.currentContext);
      //set user details
      _userid = decode['user_id'];
      _userName = decode['username'];
      _name = decode['name'];
      _email = decode['email'];
      //_picture = decode['picture'];

      //Navigator
      if (_status == 'success') {
        //set Data
        preferences.setString('userid', _userid);
        preferences.setString('username', _userName);
        preferences.setString('name', _name);
        preferences.setString('email', _email);
        //preferences.setString('profileImg', _picture);
        preferences?.setBool(loginType, true);

        _showDialog();
      } else {
        print('Email already registered..!');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(decode['message']),
        //   duration: Duration(seconds: 3),
        // ));

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

        String message = decode['message'];

        _showErrorDialogue(message);
      }
    });

    print(response.body);
  }

  /*-------------- google facebook Login Api Calling-------------*/
  Future<void> _googleloginApiCalling(String username, String password,
      String name, String email, String loginType) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    print("username ====== $username");
    print("password ====== $password");

    var preferences = await SharedPreferences.getInstance();
    String _userid;
    String _userName;
    String _name;
    String _email;
    String _picture;

    final String url =
        "${Constants.LOG_IN}&username=$username&password=$password";

    http.Response response = await http.get(url);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    //set user details
    _userid = decode['user_id'];
    _userName = decode['username'];
    _name = decode['name'];
    _email = decode['email'];
    //_picture = decode['picture'];

    setState(() {
      //Navigator
      if (_status == 'success') {
        //set Data
        preferences.setString('userid', _userid);
        preferences.setString('username', _userName);
        preferences.setString('name', _name);
        preferences.setString('email', _email);
        //preferences.setString('profileImg', _picture);
        preferences?.setBool(loginType, true);

        print("Google login successfully...!");

        Navigator.pop(_keyLoader.currentContext);
        _showDialog();
      } else {
        Navigator.pop(_keyLoader.currentContext);
        registerApiCall(username, password, name, email, loginType);
      }
    });
  }

  Future<void> _facebookLoginApiCalling(String username, String password,
      String name, String email, String loginType) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    print("username ====== $username");
    print("password ====== $password");

    var preferences = await SharedPreferences.getInstance();
    String _userid;
    String _userName;
    String _name;
    String _email;
    String _picture;

    final String url =
        "${Constants.LOG_IN}&username=$username&password=$password";

    http.Response response = await http.get(url);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    //set user details
    _userid = decode['user_id'];
    _userName = decode['username'];
    _name = decode['name'];
    _email = decode['email'];
    //_picture = decode['picture'];

    setState(() {
      //Navigator
      if (_status == 'success') {
        //set Data
        preferences.setString('userid', _userid);
        preferences.setString('username', _userName);
        preferences.setString('name', _name);
        preferences.setString('email', _email);
        //preferences.setString('profileImg', _picture);
        preferences?.setBool(loginType, true);

        print("Facebook login successfully...!");

        Navigator.pop(_keyLoader.currentContext);
        _showDialog();
      } else {
        Navigator.pop(_keyLoader.currentContext);
        registerApiCall(username, password, name, email, loginType);
      }
    });

    print(response.body);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out");
  }

  Future<bool> signOut() async {
    await fblogin.logOut();
    return true;
  }

  void _showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      'Login Successfully.',
                      style: Palette.title2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: cDarkBlue),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                        child:
                            Text('Get Started..!', style: Palette.themeBtnText),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showErrorDialogue(String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      'Login Faild..!\n$message',
                      style: Palette.title2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                        child: Text('Retry', style: Palette.themeBtnText),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showDealerBuilderDialogue(String loginType, String tokenId) {
    showModalBottomSheet(
      context: context,
      //barrierColor: Colors.greenAccent,
      //backgroundColor: Colors.yellow,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            ListTile(
              leading: new Icon(Icons.business_center_outlined),
              title: new Text('Owner'),
              onTap: () {
                Navigator.pop(context);
                if (loginType == "google") {
                  _handleGoogleSignIn(tokenId, 'Owner');
                } else if (loginType == "facebook") {
                  _handleFacebookSignIn(tokenId, 'Owner');
                }
              },
            ),
            Divider(),
            ListTile(
              leading: new Icon(Icons.business),
              title: new Text('Builder'),
              onTap: () {
                Navigator.pop(context);
                if (loginType == "google") {
                  _handleGoogleSignIn(tokenId, 'Builder');
                } else if (loginType == "facebook") {
                  _handleFacebookSignIn(tokenId, 'Builder');
                }
              },
            ),
            Divider(),
            ListTile(
              leading: new Icon(Icons.person_outline),
              title: new Text('Dealer'),
              onTap: () {
                Navigator.pop(context);
                if (loginType == "google") {
                  _handleGoogleSignIn(tokenId, 'Dealer');
                } else if (loginType == "facebook") {
                  _handleFacebookSignIn(tokenId, 'Dealer');
                }
              },
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
