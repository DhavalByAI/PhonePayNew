import 'dart:async';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/home.dart';
import 'package:phonepeproperty/screens/searchProducts/dynamicSearchFilter.dart';
import 'package:phonepeproperty/screens/productDetails.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProducts extends StatefulWidget {
  final String catId,
      catName,
      subCatId,
      subCatName,
      additionalInfo,
      priceFrom,
      priceTo,
      stateId,
      stateName,
      cityId,
      cityName,
      localityId,
      localityName;

  CategoryProducts(
      {this.catId,
      this.catName,
      this.subCatId,
      this.subCatName,
      this.additionalInfo,
      this.priceFrom,
      this.priceTo,
      this.stateId,
      this.stateName,
      this.cityId,
      this.cityName,
      this.localityId,
      this.localityName});

  @override
  State<StatefulWidget> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  bool _error;
  bool _loading;
  //List<ProductsModel> _modelProducts = [];

  List productList = [];

  String _status = "active";
  String _countryCode = "in";

  bool _priceVisibility = false;
  bool _featuredVisibility = false;

  //search filter
  List filterlist = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Icon actionIcon = Icon(Icons.search, color: Colors.white);
  Widget appBarTitle;

  ScrollController _scrollController = ScrollController();
  int page = 1;

  var _limit = "10";

  String _stateCode;
  String _state;
  String _cityCode;
  String _city;
  String _localityId;
  String _locality;

  String _keywords;

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _stateCode = widget.stateId;
    _state = widget.stateName;
    _cityCode = widget.cityId;
    _city = widget.cityId;
    _localityId = widget.localityId;
    _locality = widget.localityName;

    _error = false;
    _loading = true;
    _keywords = "";
    appBarTitle = Text("${widget.catName} > ${widget.subCatName}",
        style: Palette.whiteTitle2);
    _searchFilterInitState();
    this.fetchProducts(page, _keywords);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchProducts(page, _keywords);
      }
    });
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    //search function

    // if ((filter.isNotEmpty)) {
    //   List<ProductsModel> tmpList = List<ProductsModel>();
    //   for (int i = 0; i < filterlist.length; i++) {
    //     if (filterlist[i].title.toLowerCase().contains(filter.toLowerCase())) {
    //       tmpList.add(filterlist[i]);
    //     }
    //   }
    //   filterlist = tmpList;
    // }

    //scaffold function
    return WillPopScope(
      onWillPop: _navigatToHomeScreen,
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          backgroundColor: cDarkBlue,
          brightness: Brightness.dark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _navigatToHomeScreen(),
          ),
          actions: [
            _searchiconWidget(),
            IconButton(
              icon: Icon(Icons.filter_list_alt, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DynamicSearchFilter(
                    catId: widget.catId,
                    catName: widget.catName,
                    subCatId: widget.subCatId,
                    subCatName: widget.subCatName,
                    additionalInfo: widget.additionalInfo,
                    priceFrom: widget.priceFrom,
                    priceTo: widget.priceTo,
                    cityId: widget.cityId,
                    cityName: widget.cityName,
                    stateId: widget.stateId,
                    stateName: widget.stateName,
                    localityId: widget.localityId,
                    localityName: widget.localityName,
                  ),
                ),
              ),
            ),
          ],
        ),
        //resizeToAvoidBottomPadding: false,
        /*------------------ body ----------------*/
        body: gridViewProducts(),
      ),
    );
  }

  Future<bool> _navigatToHomeScreen() => Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => Home()), (route) => false);

  //price display
  Widget priceDisplay() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Container(child: Text('Price From - ', style: Palette.subTitle2)),
          Expanded(
              child:
                  Text('${widget.priceFrom}', style: Palette.subTitle3Orange)),
          Container(child: Text('Price To - ', style: Palette.subTitle2)),
          Expanded(
              child: Text('${widget.priceTo}', style: Palette.subTitle3Orange)),
        ],
      ),
    );
  }

  //Grid List View
  Widget gridViewProducts() {
    if (filterlist.isEmpty) {
      if (_loading) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        );
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(
              () {
                _loading = true;
                _error = false;
                fetchProducts(page, _keywords);
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading properties, tap to try again"),
          ),
        ));
      }
    } else {
      return ListView.separated(
        //primary: false,
        //shrinkWrap: true,
        controller: _scrollController,
        itemCount: filterlist.length,
        // Add one more item for progress indicator
        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
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

          if (index == filterlist.length) {
            //progress bar
            return _buildProgressIndicator();
          } else {
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
                          //width: 160.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider("$_picture"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                              decoration: Palette.imageShadow,
                              child: Container(
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5.0),
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
                                                  style: Palette
                                                      .productCategoryStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              5.0,
                                                              2.0,
                                                              5.0,
                                                              2.0),
                                                      child: Text(
                                                        '$_highlightText',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
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
                                      ]))))),
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
                                        size: 12.0, color: Colors.red[900]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                '$_sqFt' +
                                    ' sq.ft' +
                                    ' | ' +
                                    '$_type' +
                                    ' | ' +
                                    '$_bhk' +
                                    'bhk',
                                style: Palette.productSubTittle2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.0),
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
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                                child: Text(
                                  '\u{20B9}' + '$_formatedPrice',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    color: Palette.themeColor,
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
          }
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

  Future<void> fetchProducts(int index, String keyword) async {
    var preferences = await SharedPreferences.getInstance();
    // _stateCode = preferences.getString('state_code');
    // _state = preferences.getString('state_name');
    // _cityCode = preferences.getString('city_code');
    // _cityCode = preferences.getString('city_code');

    setState(() {
      if (_stateCode == null || _stateCode.isEmpty) {
        _stateCode = preferences.getString('state_code');
        _state = preferences.getString('state_name');
      }
      if (_cityCode == null || _cityCode.isEmpty) {
        _cityCode = preferences.getString('city_code');
        _city = preferences.getString('city_name');
      }
      if (_localityId == null || _localityId.isEmpty) {
        _localityId = preferences.getString('locality_code');
        _locality = preferences.getString('locality_name');
      }
    });

    //list
    try {
      var req = {
        'status': _status,
        'country_code': _countryCode,
        'state': _stateCode,
        'city': _cityCode,
        'locality': _localityId,
        'page': index.toString(),
        'limit': _limit,
        'category_id': widget.catId,
        'subcategory_id': widget.subCatId,
        'keywords': keyword,
        'additionalinfo': widget.additionalInfo,
        'price1': widget.priceFrom,
        'price2': widget.priceTo,
      };

      //url
      var url = Constants.CATEGORY_PRODUCTS_URL;

      print(req);

      //response
      final response = await http.post(url, body: req);

      //list
      var decode = json.decode(response.body);
      print(decode);
      setState(() {
        _loading = false;
        productList = decode;
        filterlist.addAll(productList);
        //filterlist.addAll(productList);

      });
    } catch (e) {
      setState(() {
        print(e.toString());
        _loading = false;
        _error = true;
      });
    }
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return '${Constants.BANNER_AD_ID_IOS}';
    } else if (Platform.isAndroid) {
      return '${Constants.BANNER_AD_ID_ANDROID}';
    }
    return null;
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
              onChanged: (val) {
                setState(() {
                  filterlist.clear();
                  if (val.isEmpty) {
                    _keywords = " ";
                    fetchProducts(page, _keywords);
                  } else {
                    _keywords = val;
                    fetchProducts(page, _keywords);
                  }
                  print("Keywords : $_keywords");
                });
              },
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _loading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
