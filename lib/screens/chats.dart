import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/screens/productDetails.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/utils/callMessageService.dart';
import 'package:phonepeproperty/utils/servicelocator.dart';
import 'dart:convert';
import 'package:phonepeproperty/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  Chats({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List data;

  @override
  void initState() {
    super.initState();
    checkUserLoginProfile();
  }

  /*--------------- call, message, email service -------------*/
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  final GlobalKey<dynamic> _refreshIndicatorKey = GlobalKey();

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Inquire', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      /*-------------------- body --------------------*/
      body: Container(
        child: data == null
            ? Center(
                child: CircularProgressIndicator(
                  color: cDarkBlue,
                ),
              )
            : data.length != 0
                ? RefreshIndicator(
                    child: _lisTileContainer(),
                    onRefresh: () {
                      return fetchData();
                    })
                : Center(
                    child: Text(
                      'No Inquires..!',
                      style: Palette.header,
                    ),
                  ),
      ),
    );
  }

  Widget _lisTileContainer() {
    return ListView.builder(
      key: _refreshIndicatorKey,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      itemCount: data.length,
      itemBuilder: (context, i) {
        var _mobile = data[i]['mobile'];
        var _email = data[i]['email'];
        var _pid = data[i]['pid'];
        return Card(
          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
          elevation: 12.0,
          shadowColor: Colors.black26,
          shape: Palette.seachBoxCardShape,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _bottomModelSheet(_mobile, _email, _pid),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                          child: Text(
                            '${data[i]['name']}',
                            style: Palette.title2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                          child: Text('${data[i]['email']}',
                              style: Palette.subTitle2),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                          child: Text('${data[i]['mobile']}',
                              style: Palette.subTitle2),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                          child: Text('${data[i]['created_at']}',
                              style: Palette.subTitle2Orange),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                    child: Column(
                      children: [
                        Text('Dealer', style: Palette.subTitle),
                        SizedBox(height: 2.0),
                        Text('${data[i]['is_deler']}',
                            style: Palette.subTitle2Orange)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _bottomModelSheet(String mobile, String email, String pid) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: Text('View Ad'),
              leading: Icon(Icons.photo_size_select_large),
              onTap: () {
                if (pid != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetails(pid)));
                }
              },
            ),
            ListTile(
              title: Text('$mobile'),
              leading: Icon(Icons.phone),
              onTap: () => _service.call(mobile),
            ),
            ListTile(
              title: Text('$email'),
              leading: Icon(Icons.email_outlined),
              onTap: () => _service.sendEmail(email),
            ),
          ],
        );
      },
    );
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
      fetchData();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  //fetch data
  Future<String> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.getString('userid');
    String token = pref.getString('token');
    final String url = Constants.GET_INQUIREY;

    var requestBody = {
      'user_id': userid,
    };

    http.Response response = await http.post(
      url,
      body: requestBody,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    //object response
    Map<String, dynamic> decode = json.decode(response.body);

    setState(() {
      data = decode['data'];
    });

    return 'success';
  }
}
