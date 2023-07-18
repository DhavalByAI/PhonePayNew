import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _status;

  bool _validate = false;
  bool _obsecurePass = true;

  /* ----------------- padding, margin --------------- */
  EdgeInsets _five = EdgeInsets.all(5.0);
  EdgeInsets _standard = EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0);

  /* ----------------- Main Build Function --------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*------------- Body -------------*/
      body: Container(
        decoration: Palette.authBg,
        child: ListView(
          children: [
            SizedBox(height: 50.0),
            Text(
              'Creat new account',
              style: Palette.whiteHeader,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            Container(
              margin: _standard,
              child: Column(
                children: [
                  /*------------- Name -------------*/
                  Padding(
                    padding: _standard * 2,
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: Palette.textFieldWhite,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Name',
                        labelStyle: Palette.textFieldLabelWhite,
                        errorText: _validate ? 'Value Can\'t be empty' : null,
                      ),
                    ),
                  ),

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
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Username',
                        labelStyle: Palette.textFieldLabelWhite,
                        errorText: _validate ? 'Value Can\'t be empty' : null,
                      ),
                    ),
                  ),

                  /*------------- Email -------------*/
                  Padding(
                    padding: _standard * 2,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: Palette.textFieldWhite,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Email',
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
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Password',
                          labelStyle: Palette.textFieldLabelWhite,
                          errorText: _validate ? 'Value Can\'t be empty' : null,
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
                  SizedBox(height: 5.0),

                  /*------------- Sign up -------------*/
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
                              setState(
                                () {
                                  if (userNameController.text.isEmpty &&
                                      passwordController.text.isEmpty) {
                                    _validate = true;
                                  } else {
                                    _validate = false;
                                    registerApiCall();
                                  }
                                },
                              );
                            },
                            child: Padding(
                              padding: _five * 3,
                              child:
                                  Text('REGISTER', style: Palette.buttonText),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  /*------------------- Login  ----------------*/
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
                                  builder: (context) => Login(),
                                ));
                          },
                          child: Text(
                            'Already have account? Login',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                            child:
                                Divider(thickness: 2.0, color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*-------------- Signup Api Calling-------------*/
  Future<void> registerApiCall() async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);
    var preferences = await SharedPreferences.getInstance();
    String userid;
    String userName;
    String name;
    String email;

    String _username = userNameController.text;
    String _password = passwordController.text;
    String _name = nameController.text;
    String _email = emailController.text;

    final String url = Constants.REGISTER;

    var req = {
      'username': _username,
      'password': _password,
      'name': _name,
      'email': _email,
    };

    http.Response response = await http.post(url, body: req);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    setState(() {
      //Navigator
      if (_status == 'success') {
        //set Data
        Navigator.pop(_keyLoader.currentContext);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(decode['message']),
        //   duration: Duration(seconds: 3),
        // ));
        _showDialog();
      } else {
        Navigator.pop(_keyLoader.currentContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(decode['message']),
          duration: Duration(seconds: 3),
        ));
      }
    });

    print(response.body);
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
                      'Register Successfully.',
                      style: Palette.title2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                        child: Text('Please Login..!',
                            style: Palette.themeBtnText),
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
}
