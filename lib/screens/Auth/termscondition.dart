import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsCondition extends StatefulWidget {
  TermsCondition({Key key}) : super(key: key);

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  String _url;

  WebViewController controller;

  @override
  void initState() {
    super.initState();
    _url = "https://phonepeproperty.com/page/terms";
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
        title: Text('Terms & Conditions', style: Palette.whiteTitle2),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: '$_url',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
