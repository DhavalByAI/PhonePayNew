import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:phonepeproperty/screens/allLatestAds.dart';
import 'package:phonepeproperty/screens/category/mainCategory.dart';
import 'package:phonepeproperty/screens/category/selectSubCategory.dart';
import 'package:phonepeproperty/screens/productDetails.dart';
import 'package:phonepeproperty/screens/location/selectLocation.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController searchController = TextEditingController();

  bool _error;
  bool _loading;
  //List<ProductsModel> _modelProducts;
  //List<FeaturedProductsModel> _modelFeaturedProducts;
  List featuredProductList = [];
  List productList = [];
  List topProjectList = [];
  //List<CategoryModel> _modelCateory;
  List catList = [];

  String _status = "active";
  String _countryCode = "in";
  String _state = "";
  String _stateCode = "";
  String _city = "";
  String _cityCode = "";
  String _locality = "";
  String _localityCode = "";
  String _limit = "20";

  bool _priceVisibility = false;
  bool _featuredVisibility = false;

  String _name = 'there';
  String _displayName;

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _name = pref.getString('name');
    setState(() {
      if (_name == null || _name == '') {
        _displayName = 'there';
      } else {
        _displayName = _name;
      }
    });
  }

  final GlobalKey<dynamic> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;
    selectedCity();
    fetchFeaturedProducts();
    fetchProducts();
    fetchAppConfigData();
    userData();
    fetchTopProjects();

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(kOneSingleAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setExternalUserId(kOneSingleUserId);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    //------------------- Scaffold -------------//
    return Scaffold(
      backgroundColor: cDarkBlue,
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        //shape: Palette.seachBoxCardShape,
        elevation: 0.0,
        toolbarHeight: 55.0,
        title: searchCard(),
        brightness: Brightness.dark,
      ),
      /*------------------ body ----------------*/
      body: SingleChildScrollView(
        //margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topContainerWidget(),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(30.0),
              //     topRight: Radius.circular(30.0),
              //   ),
              // ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Text('Feature Properties', style: Palette.header),
                  ),
                  SizedBox(height: 15.0),
                  horizontalFeturedProducts(),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Text('Top Projects', style: Palette.header),
                  ),
                  SizedBox(height: 15.0),
                  horizontalTopProjects(),
                  _bannerAd(),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                    child: Text(
                      'Latest Properties',
                      style: Palette.header,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
                    child: gridViewProducts(),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    alignment: Alignment.center,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllLatestAds()));
                      },
                      child: Text(
                        'See All Latest Ads ..!',
                        style: Palette.btnTextOrange2,
                      ),
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

  Widget topAppBar() {
    return Container(
      margin: EdgeInsets.only(top: 32.0, right: 15.0, left: 15.0, bottom: 5.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(child: Icon(Icons.add_location_alt_outlined)),
              SizedBox(width: 2.0),
              Expanded(child: Text('India')),
              Container(child: Icon(Icons.remove_red_eye_outlined)),
            ],
          ),
          SizedBox(height: 8.0),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0.0,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: Palette.seachBoxCardShape,
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.name,
              autocorrect: true,
              style: TextStyle(fontSize: 14.0, decoration: TextDecoration.none),
              onChanged: (value) {
                debugPrint('Something changed in Lead Name Text Field');
                //updateLeadName();
              },
              decoration: InputDecoration(
                //labelText: 'Lead Name',
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: InputBorder.none,
                hintText: 'Search Projects, Localities, Cities etc.',
                hintStyle:
                    TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topContainerWidget() {
    String greetingMes = greetingMessage();
    return Container(
      height: 230.0,
      decoration: BoxDecoration(
        color: cDarkBlue,
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(60.0),
        // ),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Hi $_displayName', style: Palette.whiteHeader),
                subtitle: Text('$greetingMes', style: Palette.nameSubTitle),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
              child: Row(
                children: [
                  Container(
                      child: Text('Finding in',
                          style: Palette.dashbordLocationStyle)),
                  SizedBox(width: 3.0),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectLocation())),
                    child: Container(
                      child: Card(
                          elevation: 0.0,
                          color: Colors.white38,
                          shape: Palette.CommonCardShape,
                          child: Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Center(
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(
                                            _city == "" && _state != ""
                                                ? '$_state'
                                                : _state == ""
                                                    ? 'India'
                                                    : '$_city',
                                            style: Palette
                                                .dashbordLocationNameStyle,
                                          ),
                                        ),
                                        _locality == ""
                                            ? Container()
                                            : Container(
                                                child: Text(
                                                  ', $_locality',
                                                  style: Palette
                                                      .dashbordLocationNameStyle,
                                                ),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Container(
                                      child: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        size: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              child: Text('Choose to start new search',
                  style: Palette.dashbordLocationStyle),
            ),
            categoryList()
          ],
        ),
      ),
    );
  }

  Widget categoryList() {
    return Container(
      height: 40.0,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 18.0),
        itemCount: catList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String categoryId = catList[index]['cat_id'];
          String categoryImg = catList[index]['picture'];
          String categoryName = catList[index]['cat_name'];
          return InkWell(
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectSubCategory(
                            categoryId, categoryName, categoryImg)));
              });
            },
            child: Card(
              elevation: 0.0,
              color: Colors.white38,
              shape: Palette.cardShape,
              child: Row(
                children: [
                  SizedBox(width: 5.0),
                  Container(
                    height: 30.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage('$categoryImg')),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Center(
                      child: Text(
                        '$categoryName',
                        style: Palette.dashbordCategoryNameStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget feturedProductsList() {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Text('Premium Properties', style: Palette.header),
          ),
          SizedBox(height: 15.0),
          horizontalFeturedProducts()
        ],
      ),
    );
  }

  Widget gridViewProducts() {
    if (productList.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(
            color: cDarkBlue,
          ),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchProducts();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Tap to try agin"),
          ),
        ));
      }
    } else {
      var size = MediaQuery.of(context).size;
      /*24 is for notification bar on Android*/
      final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
      final double itemWidth = size.width / 2;
      return GridView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: productList.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight),
            //childAspectRatio: MediaQuery.of(context).size.height/1200,
            //mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            //Data From Model
            String _productId = productList[index]['id'];
            String _productName = productList[index]['product_name'];
            String _location = productList[index]['location'];
            String _createdAt = productList[index]['created_at'];
            String _category = productList[index]['category'];
            String _username = productList[index]['username'];
            String _picture = productList[index]['picture'];

            String _featured = productList[index]['featured'];
            String _urgent = productList[index]['urgent'];

            String _highlightText;
            Color _highlightColor;

            String _price = productList[index]['price'];
            _price == null
                ? _price = "0"
                : _price = productList[index]['price'];

            String _formatedPrice = NumberFormatter.formatter('$_price');

            _formatedPrice != "0.00"
                ? _priceVisibility = true
                : _priceVisibility = false;

            _featured == "1" || _urgent == "1"
                ? _featuredVisibility = true
                : _featuredVisibility = false;

            if (_featured == "1") {
              _highlightColor = Colors.green[700];
              _highlightText = "Featured";
            } else if (_urgent == "1") {
              _highlightColor = Colors.blue[900];
              _highlightText = "Urgent";
            } else {
              _highlightColor = Colors.transparent;
              _highlightText = "";
            }

            //Card UI
            return InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(_productId),
                  ),
                ),
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 0.0,
                    shape: Palette.cardShape,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 160.0,
                      //width: 160.0,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              // width: 160.0,
                              width: MediaQuery.of(context).size.width,
                              height: 140.0,
                              imageUrl: "$_picture",
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                            decoration: Palette.imageShadow,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.0),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5.0, left: 10.0, right: 10.0),
                                        child: Text(
                                          '$_category',
                                          style: Palette.productCategoryStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        child: Visibility(
                                          visible: _featuredVisibility,
                                          child: Card(
                                            //margin: EdgeInsets.all(6.0),
                                            color: _highlightColor,
                                            elevation: 0.0,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 2.0, 5.0, 2.0),
                                              child: Text(
                                                '$_highlightText',
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Visibility(
                                    visible: _priceVisibility,
                                    child: Card(
                                      margin: EdgeInsets.all(6.0),
                                      color: Colors.white,
                                      elevation: 0.0,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 2.0, 5.0, 2.0),
                                        child: Text(
                                          '\u{20B9}' + '$_formatedPrice',
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                            color: cDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_productName',
                      style: Palette.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Container(
                    margin: Palette.productNameMargin,
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '$_location',
                            style: Palette.productSubTittle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Container(
                          child: Icon(Icons.location_on_outlined,
                              size: 12.0, color: cDarkBlue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Container(
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_createdAt  - by $_username',
                      style: Palette.productSubTittle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          });
    }
    return Container();
  }

  Widget horizontalFeturedProducts() {
    if (featuredProductList.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(
            color: cDarkBlue,
          ),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchProducts();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Tap to try agin", style: Palette.subTitle2),
          ),
        ));
      }
    } else {
      return Container(
        height: 250.0,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 15.0),
          itemCount: featuredProductList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            //Data From Model

            String _productId = featuredProductList[index]['id'];
            String _productName = featuredProductList[index]['product_name'];
            String _location =
                featuredProductList[index]['location']['asciiname'];
            String _createdAt = featuredProductList[index]['created_at'];
            String _category = featuredProductList[index]['category'];
            String _username = featuredProductList[index]['username'];
            String _picture = featuredProductList[index]['picture'];

            String _featured = featuredProductList[index]['featured'];
            String _urgent = featuredProductList[index]['urgent'];

            String bedRooms = featuredProductList[index]['No. Of Bedrooms'];
            String bathRooms = featuredProductList[index]['No. Of Bathroom'];
            String balCony = featuredProductList[index]['No. Of Balconies'];

            String _highlightText;
            Color _highlightColor;

            String _price = featuredProductList[index]['price'];

            _price == null
                ? _price = "0"
                : _price = featuredProductList[index]['price'];

            String _formatedPrice = NumberFormatter.formatter('$_price');

            _formatedPrice != "0.00"
                ? _priceVisibility = true
                : _priceVisibility = false;

            _featured == "1" || _urgent == "1"
                ? _featuredVisibility = true
                : _featuredVisibility = false;

            if (_featured == "1") {
              _highlightColor = Colors.green[700];
              _highlightText = "Featured";
            } else if (_urgent == "1") {
              _highlightColor = Colors.blue[900];
              _highlightText = "Urgent";
            } else {
              _highlightColor = Colors.transparent;
              _highlightText = "";
            }

            //Card UI
            return InkWell(
              //Navigat to product detail screen
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(_productId),
                  ),
                ),
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 0.0,
                    shape: Palette.cardShape,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                        height: 160.0,
                        width: 180.0,
                        child: Stack(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                width: 180.0,
                                height: 160.0,
                                imageUrl: "$_picture",
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Container(
                              decoration: Palette.imageShadow,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Text(
                                              '$_category',
                                              style:
                                                  Palette.productCategoryStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            child: Visibility(
                                              visible: _featuredVisibility,
                                              child: Card(
                                                //margin: EdgeInsets.all(6.0),
                                                color: _highlightColor,
                                                elevation: 0.0,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5.0, 2.0, 5.0, 2.0),
                                                  child: Text(
                                                    '$_highlightText',
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Visibility(
                                        visible: _priceVisibility,
                                        child: Card(
                                          margin: EdgeInsets.all(6.0),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 2.0, 5.0, 2.0),
                                            child: Text(
                                              '\u{20B9}' + '$_formatedPrice',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                                color: cDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    width: 180.0,
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_productName',
                      style: Palette.productTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Container(
                      width: 180.0,
                      margin: Palette.productNameMargin,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            child: Icon(
                              Icons.bed,
                              size: 15,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                              child: Text(
                            '$bedRooms',
                            textAlign: TextAlign.start,
                          )),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              child: Icon(
                                Icons.bathtub_outlined,
                                size: 15,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                              child: Text(
                            '$bathRooms',
                            textAlign: TextAlign.start,
                          )),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              child: Icon(
                                Icons.square_foot,
                                size: 15,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text('$balCony'),
                          )
                        ],
                      )),
                  SizedBox(height: 2.0),
                  Container(
                    margin: Palette.productNameMargin,
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '$_location',
                            style: Palette.productSubTittle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 3.0),
                        Container(
                          child: Icon(Icons.location_on_outlined,
                              size: 12.0, color: cDarkBlue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180.0,
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_createdAt  - by $_username',
                      style: Palette.productSubTittle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          },
        ),
      );
    }
    return Container();
  }

  Widget horizontalTopProjects() {
    if (topProjectList.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(
            color: cDarkBlue,
          ),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchProducts();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Tap to try agin", style: Palette.subTitle2),
          ),
        ));
      }
    } else {
      return Container(
        height: 250.0,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 15.0),
          itemCount: topProjectList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            //Data From Model

            String _productId = topProjectList[index]['id'];
            String _productName = topProjectList[index]['product_name'];
            String _location = topProjectList[index]['location']['asciiname'];
            String _createdAt = topProjectList[index]['created_at'];
            String _category = topProjectList[index]['category'];
            String _username = topProjectList[index]['username'];
            String _picture = topProjectList[index]['picture'];

            String _featured = topProjectList[index]['featured'];
            String _urgent = topProjectList[index]['urgent'];

            String bedRooms = topProjectList[index]['No. Of Bedrooms'];
            String bathRooms = topProjectList[index]['No. Of Bathroom'];
            String balCony = topProjectList[index]['No. Of Balconies'];

            String _highlightText;
            Color _highlightColor;

            String _price = topProjectList[index]['price'];

            _price == null
                ? _price = "0"
                : _price = topProjectList[index]['price'];

            String _formatedPrice = NumberFormatter.formatter('$_price');

            _formatedPrice != "0.00"
                ? _priceVisibility = true
                : _priceVisibility = false;

            _featured == "1" || _urgent == "1"
                ? _featuredVisibility = true
                : _featuredVisibility = false;

            if (_featured == "1") {
              _highlightColor = Colors.green[700];
              _highlightText = "Featured";
            } else if (_urgent == "1") {
              _highlightColor = Colors.blue[900];
              _highlightText = "Urgent";
            } else {
              _highlightColor = Colors.transparent;
              _highlightText = "";
            }

            //Card UI
            return InkWell(
              //Navigat to product detail screen
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(_productId),
                  ),
                ),
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 0.0,
                    shape: Palette.cardShape,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                        height: 160.0,
                        width: 180.0,
                        child: Stack(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                width: 180.0,
                                height: 160.0,
                                imageUrl: "$_picture",
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Container(
                              decoration: Palette.imageShadow,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Text(
                                              '$_category',
                                              style:
                                                  Palette.productCategoryStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            child: Visibility(
                                              visible: _featuredVisibility,
                                              child: Card(
                                                //margin: EdgeInsets.all(6.0),
                                                color: _highlightColor,
                                                elevation: 0.0,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5.0, 2.0, 5.0, 2.0),
                                                  child: Text(
                                                    '$_highlightText',
                                                    style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Visibility(
                                        visible: _priceVisibility,
                                        child: Card(
                                          margin: EdgeInsets.all(6.0),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 2.0, 5.0, 2.0),
                                            child: Text(
                                              '\u{20B9}' + '$_formatedPrice',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                                color: cDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    width: 180.0,
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_productName',
                      style: Palette.productTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Container(
                      width: 180.0,
                      margin: Palette.productNameMargin,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            child: Icon(
                              Icons.bed,
                              size: 15,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                              child: Text(
                            '$bedRooms',
                            textAlign: TextAlign.start,
                          )),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              child: Icon(
                                Icons.bathtub_outlined,
                                size: 15,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                              child: Text(
                            '$bathRooms',
                            textAlign: TextAlign.start,
                          )),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              child: Icon(
                                Icons.square_foot,
                                size: 15,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text('$balCony'),
                          )
                        ],
                      )),
                  SizedBox(height: 2.0),
                  Container(
                    margin: Palette.productNameMargin,
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '$_location',
                            style: Palette.productSubTittle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 3.0),
                        Container(
                          child: Icon(Icons.location_on_outlined,
                              size: 12.0, color: cDarkBlue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180.0,
                    margin: Palette.productNameMargin,
                    child: Text(
                      '$_createdAt  - by $_username',
                      style: Palette.productSubTittle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          },
        ),
      );
    }
    return Container();
  }

  Widget searchCard() {
    return Card(
      elevation: 0.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white30,
      shape: Palette.seachBoxCardShape,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainCategory(),
            )),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ' Search Projects, Localities, Cities etc.',
                  style: Palette.subTitle3ItalicWhite,
                ),
              ),
              Container(
                child: Icon(Icons.search, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchProducts() async {
    var preferences = await SharedPreferences.getInstance();
    _stateCode = preferences.getString('state_code');
    _state = preferences.getString('state_name');
    _cityCode = preferences.getString('city_code');
    _city = preferences.getString('city_name');
    _localityCode = preferences.getString('locality_code');
    _locality = preferences.getString('locality_name');

    var req = {
      'status': _status,
      'country_code': _countryCode,
      'state': _stateCode,
      'city': _cityCode,
      'locality': _localityCode,
      'page': "1",
      'limit': _limit.toString(),
    };

    try {
      final response = await http.post(
        Constants.DASHBORAD_PRODUCTS_URL,
        body: req,
      );

      var decode = json.decode(response.body);
      print(decode);

      setState(() {
        productList = decode;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> fetchFeaturedProducts() async {
    var preferences = await SharedPreferences.getInstance();
    _stateCode = preferences.getString('state_code');
    _state = preferences.getString('state_name');
    _cityCode = preferences.getString('city_code');
    _city = preferences.getString('city_name');

    try {
      var req = {
        'action': 'featured_urgent_ads',
        'status': _status,
        'country_code': _countryCode,
        'state': _stateCode,
        'city': _cityCode,
      };

      final response = await http.post(
        Constants.DASHBORAD_FEATURED_PRODUCTS_URL,
        body: req,
      );

      var decode = json.decode(response.body);
      print(decode);
      // List<FeaturedProductsModel> fetchedPhotos =
      //     FeaturedProductsModel.parseList(decode);
      setState(() {
        _loading = false;
        featuredProductList = decode;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> fetchTopProjects() async {
    // var preferences = await SharedPreferences.getInstance();
    // _stateCode = preferences.getString('state_code');
    // _state = preferences.getString('state_name');
    // _cityCode = preferences.getString('city_code');
    // _city = preferences.getString('city_name');

    try {
      // var req = {
      //   'action': 'featured_urgent_ads',
      //   'status': _status,
      //   'country_code': _countryCode,
      //   'state': _stateCode,
      //   'city': _cityCode,
      // };

      final response = await http.post(
        Constants.TOP_PROJECTS,
      );

      var decode = json.decode(response.body)['property_details'];
      print(decode);
      // List<FeaturedProductsModel> fetchedPhotos =
      //     FeaturedProductsModel.parseList(decode);
      setState(() {
        _loading = false;
        topProjectList = decode;
        print('topProjectResponse::::::::::::::::::$topProjectList');
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> fetchAppConfigData() async {
    final String url = Constants.CATEGORY_LIST;

    http.Response response = await http.get(url);

    //object response
    var decode = json.decode(response.body);

    //var _status = decode['status'];
    //List<CategoryModel> setCategory = CategoryModel.parseList(categoryData);

    setState(() {
      //_modelCateory.addAll(setCategory);
      //print(categoryData);
      catList = decode;
      if (_status == "Success") {
        _loading = false;
      } else {
        _loading = true;
      }
    });
  }

  Future<void> selectedCity() async {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      _stateCode = preferences.getString('state_code');
      _state = preferences.getString('state_name');
      _cityCode = preferences.getString('city_code');
      _city = preferences.getString('city_name');

      //print
      print('state = $_stateCode, $_state');
      print('city = $_cityCode, $_city');
    });
  }

  Widget _bannerAd() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.FULL_BANNER,
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return '${Constants.BANNER_AD_ID_IOS}';
    } else if (Platform.isAndroid) {
      return '${Constants.BANNER_AD_ID_ANDROID}';
    }
    return null;
  }
}

//
//
//
//
//
// End of Dashborad...!
