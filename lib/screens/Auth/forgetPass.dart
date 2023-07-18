import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPass extends StatefulWidget {
  ForgetPass({Key key}) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController emailController = TextEditingController();
  bool _validate = false;

  String _status;

  /* ----------------- padding, margin --------------- */
  EdgeInsets _five = EdgeInsets.all(5.0);
  EdgeInsets _standard = EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0);

  /* ----------------- Main Build Function --------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: Palette.authBg,
        child: ListView(
          children: [
            //SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: IconButton(
                  alignment: Alignment.topLeft,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
            ),
            SizedBox(height: 30.0),
            Text(
              'Forget your password?',
              style: Palette.whiteHeader,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Text(
                'Enter your email and we\'ll send you a link to create a new password',
                style: Palette.whiteTitle2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: _standard,
              child: Column(
                children: [
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
                        labelText: 'Registered Email',
                        labelStyle: Palette.textFieldLabelWhite,
                        errorText: _validate ? 'Value Can\'t be empty' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  /*------------- Forget Pass -------------*/
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
                              if (emailController.text.isEmpty) {
                                _validate = true;
                              } else {
                                _validate = false;
                                _forgetPassApiCalling();
                              }
                            });
                          },
                          child: Padding(
                            padding: _five * 3,
                            child: Text('RESET', style: Palette.buttonText),
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*-------------- Forget Api Calling-------------*/
  Future<void> _forgetPassApiCalling() async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    String _email = emailController.text;

    final String url = Constants.FORGET_PASS;

    var req = {'email': _email};

    http.Response response = await http.post(url, body: req);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _status = decode['status'];

    setState(() {
      //Navigator
      if (_status == 'success') {
        Navigator.pop(_keyLoader.currentContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(decode['message']),
          duration: Duration(seconds: 3),
        ));
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
}
