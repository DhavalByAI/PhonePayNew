import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _url;

  @override
  void initState() {
    super.initState();
    _url = "https://phonepeproperty.com/page/privacy-policy";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Privacy Policy', style: Palette.whiteTitle2),
        leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: '$_url',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
