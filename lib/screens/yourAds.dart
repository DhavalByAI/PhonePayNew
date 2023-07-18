import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phonepeproperty/screens/productDetails.dart';

class YourAds extends StatefulWidget {
  YourAds({Key key}) : super(key: key);

  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  bool _error;
  bool _loading;
  String _limit = "10";

  ScrollController _scrollController = ScrollController();
  int page = 1;

  bool _priceVisibility = false;
  bool _featuredVisibility = false;

  //search filter
  List filterlist = [];
  List productList = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Widget appBarTitle = Text("Your Ads", style: Palette.whiteTitle2);
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchFilterInitState();
    _error = false;
    _loading = true;
    this.fetchProducts(page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchProducts(page);
      }
    });
  }

  /*---------------------- Build Funcation --------------------*/
  @override
  Widget build(BuildContext context) {
    //search function
    if ((filter.isNotEmpty)) {
      List tmpList = [];
      for (int i = 0; i < filterlist.length; i++) {
        if (filterlist[i].title.toLowerCase().contains(filter.toLowerCase())) {
          tmpList.add(filterlist[i]);
        }
      }
      filterlist = tmpList;
    }

    //scaffold function
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: appBarTitle,
        brightness: Brightness.dark,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [_searchiconWidget()],
      ),
      /*------------------ body ----------------*/
      body: Container(
        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
        child: listViewProducts(),
      ),
    );
  }

  //Grid List View
  Widget listViewProducts() {
    if (filterlist.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(
              () {
                _loading = true;
                _error = false;
                fetchProducts(page);
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading properties, tap to try agin"),
          ),
        ));
      }
    } else {
      //Listview Api calling
      return ListView.separated(
        itemCount: filterlist.length,
        padding: EdgeInsets.zero,
        controller: _scrollController,
        itemBuilder: (context, index) {
          //Data From Model
          var modelProducts = filterlist[index];
          String _productId = modelProducts['id'];
          String _productName = modelProducts['product_name'];
          String _location = modelProducts['location'];
          String _createdAt = modelProducts['created_at'];
          String _category = modelProducts['category'];
          String _username = modelProducts['username'];
          String _picture = modelProducts['picture'];

          String _featured = modelProducts['featured'];
          String _urgent = modelProducts['urgent'];

          String _sqFt = modelProducts['Super Build Up Area (Sq.ft)'] ?? '-';
          String _type = modelProducts['Property Type'] ?? '-';
          String _bhk = modelProducts['No. Of Bedrooms'] ?? '-';

          String _highlightText;
          Color _highlightColor;

          String _price = modelProducts['price'];

          _price == null ? _price = "0" : _price = modelProducts['price'];

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 0.0,
                  shape: Palette.cardShape,
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: 160.0,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Container(
                          child: CachedNetworkImage(
                            height: 160.0,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: "$_picture",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: Palette.productNameMargin,
                  child: Text(
                    '$_productName',
                    style: Palette.productTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 2.0),
                Container(
                  margin: Palette.productNameMargin,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            Text(
                              '$_createdAt  - by $_username',
                              style: Palette.productSubTittle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Visibility(
                          visible: _priceVisibility,
                          child: Card(
                            margin: EdgeInsets.all(6.0),
                            color: Colors.blueGrey[50],
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
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
                SizedBox(height: 15.0),
              ],
            ),
          );
        },
        //admob like native
        separatorBuilder: (context, index) {
          return Container(
              child: (index != 0 && index % 5 == 0)
                  ? Container(
                      margin: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 12.0),
                      child: AdmobBanner(
                          adUnitId: getBannerAdUnitId(),
                          adSize: AdmobBannerSize.LARGE_BANNER),
                    )
                  : Container());
        },
      );
    }
    return Container();
  }

  Future<void> fetchProducts(int index) async {
    var preferences = await SharedPreferences.getInstance();
    var userid = preferences.getString('userid');
    print(userid);

    var req = {'user_id': userid, 'page': index.toString(), 'limit': _limit};

    //list
    try {
      final response = await http.post(Constants.YOUR_PRODUCTS_URL, body: req);
      var decode = json.decode(response.body);

      setState(() {
        _loading = false;
        productList = decode;
        filterlist.addAll(productList);
        //filterlist.addAll(productList);
        page++;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _searchFilterInitState() {
    List tmpList = [];
    for (int i = 0; i < productList.length; i++) {
      tmpList.add(productList[i]);
    }
    setState(() {
      productList = tmpList;
      filterlist = productList;

      controller.addListener(() {
        if (controller.text.isEmpty) {
          setState(() {
            filter = "";
            filterlist = productList;
          });
        } else {
          setState(() {
            filter = controller.text;
          });
        }
      });
    });
  }

  Widget _searchiconWidget() {
    return IconButton(
      icon: actionIcon,
      onPressed: () {
        setState(() {
          if (this.actionIcon.icon == Icons.search) {
            this.actionIcon = Icon(Icons.close, color: Colors.white);
            this.appBarTitle = TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Search ...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              autofocus: true,
              cursorColor: Colors.white,
            );
          } else {
            this.actionIcon = Icon(Icons.search, color: Colors.white);
            this.appBarTitle = Text("Your Ads", style: Palette.whiteTitle2);
            filterlist = productList;
            controller.clear();
          }
        });
      },
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
