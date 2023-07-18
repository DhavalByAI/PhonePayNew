import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdditionalFiltter extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String subCatId;
  final String subCatName;
  final String adTitle;
  final String price;
  final String mobileNo;
  final String desc;
  final List images;
  final String stateCode;
  final String stateName;
  final String cityCode;
  final String cityName;
  final String localityCode;
  final String localityName;
  final double latitudeValue;
  final double longitudeValue;
  final String address;
  

  AdditionalFiltter(
    this.categoryId,
    this.categoryName,
    this.categoryImg,
    this.subCatId,
    this.subCatName,
    this.adTitle,
    this.price,
    this.mobileNo,
    this.desc,
    this.images,
    this.stateCode,
    this.stateName,
    this.cityCode,
    this.cityName,
    this.localityCode,
    this.localityName,
    this.latitudeValue,
    this.longitudeValue,
    this.address,
  );

  @override
  State<StatefulWidget> createState() => _AdditionalFiltterState(
        this.categoryId,
        this.categoryName,
        this.categoryImg,
        this.subCatId,
        this.subCatName,
        this.adTitle,
        this.price,
        this.mobileNo,
        this.desc,
        this.images,
        this.stateCode,
        this.stateName,
        this.cityCode,
        this.cityName,
        this.localityCode,
        this.localityName,
        this.latitudeValue,
        this.longitudeValue,
        this.address,
      );
}

class _AdditionalFiltterState extends State<AdditionalFiltter> {
  String categoryId;
  String categoryName;
  String categoryImg;
  String subCatId;
  String subCatName;
  String adTitle;
  String price;
  String mobileNo;
  String desc;
  List images;
  String stateCode;
  String stateName;
  String cityCode;
  String cityName;
  String localityCode;
  String localityName;
  double latitudeValue;
  double longitudeValue;
  String address;
  _AdditionalFiltterState(
    this.categoryId,
    this.categoryName,
    this.categoryImg,
    this.subCatId,
    this.subCatName,
    this.adTitle,
    this.price,
    this.mobileNo,
    this.desc,
    this.images,
    this.stateCode,
    this.stateName,
    this.cityCode,
    this.cityName,
    this.localityCode,
    this.localityName,
    this.latitudeValue,
    this.longitudeValue,
    this.address,
  );

  String _url;

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _url = "https://phonepeproperty.com/api/v1/?action=getCustomFieldByCatID&catid=$categoryId&subcatid=$subCatId&additionalinfo=";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text('Add Filter', style: Palette.whiteTitle2),
      ),
      body: WebView(
        initialUrl: '$_url',
        javascriptMode: JavascriptMode.disabled,
        debuggingEnabled: true,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onPageStarted: (url) async {
          print('Page start url : ' + url);

          // if (url == 'https://phonepeproperty.com/api/v1/?action=send_cusdata_getjson') {
          //   final webScraper = WebScraper('https://phonepeproperty.com/');
          //   if (await webScraper.loadWebPage(
          //       'api/v1/?action=getCustomFieldByCatID&catid=1&subcatid=1&additionalinfo=')) {
          //     String elements = webScraper.getPageContent();
          //     print('data : ' + elements);
          //   }
          // }
        },
        onPageFinished: (url) {
          print('Page finished url : ' + url);
        },
        javascriptChannels: Set.from(
          [
            JavascriptChannel(
              name: 'submit',
              onMessageReceived: (JavascriptMessage message) {
                // alert message = Test alert Message
                print(message.message);
                // TODO popup
              },
            )
          ],
        ),
      ),
    );
  }
}
