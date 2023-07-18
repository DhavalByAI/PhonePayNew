import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phonepeproperty/model/ProductsModel.dart';
import 'package:phonepeproperty/screens/EditProducts/editProductOne.dart';
import 'package:phonepeproperty/screens/userPosts.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/utils/callMessageService.dart';
import 'package:phonepeproperty/utils/servicelocator.dart';
import 'dart:convert';

import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:phonepeproperty/widgets/ProductImgGallery.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  ProductDetails(this.productId);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState(this.productId);
  }
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  //map
  GoogleMapController _gMapController;

  //loading
  bool _loading;
  String productId;
  _ProductDetailsState(this.productId);

  //values define
  String _productName = "";
  String _productImg = "";
  String _productPrice = "-";
  String _category = "-";
  String _categoryId = "1";
  String _subCategory = "-";
  String _subCategoryId = "1";
  String _postedTime = "-";
  String _location = "-";

  String _city = "-";
  String _cityCode = '-';
  String _state = "-";
  String _stateCode = '-';
  String _locality = '-';
  String _loacalityCode = '-';
  String _country = "-";

  String _description = "-";

  //location
  double _latitudeValue;
  double _longitudeValue;

  //Contact
  String _phone = "7405558550";
  String _email = "phonepeproperty@gmail.com";
  String _username = "";
  String _userAvatar = "";
  String _sellerId = "";

  List additionInfoList;
  List amenitiesList;
  List waterSourceList;
  String imagesBaseURL;
  List imagesArray;

  //share
  String _productURL = "";

  //delete post
  bool _checkYourPost = false;
  String _userId;

  String _productOriginalPrice;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  String _delerRadio;

  bool _emailValidate = false;
  bool _phoneValidate = false;
  var _enquireySuccess;

  List productList = [];

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return '${Constants.BANNER_AD_ID_IOS}';
    } else if (Platform.isAndroid) {
      return '${Constants.BANNER_AD_ID_ANDROID}';
    }
    return null;
  }

  bool _error;
  bool _loading2;

  bool _priceVisibility = false;
  bool _featuredVisibility = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    additionInfoList = [];
    imagesArray = [];
    fetchProductDetails(productId);
    print(productId);
    _delerRadio = 'no';
    _error = false;
    _loading2 = true;
    //fetchProducts();
  }

  /*--------------- call, message, email service -------------*/
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  /*------------------ Build Fucation ----------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: _bottomAppbar(),
      floatingActionButton: _floatingCall(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      /*------------------ body ----------------*/
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: cDarkBlue,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              brightness: Brightness.dark,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    _share();
                  },
                ),
                Visibility(
                  visible: _checkYourPost,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _onDeleteDialogue();
                    },
                  ),
                ),
                Visibility(
                  visible: _checkYourPost,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _editPostNavigation();
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.width - 328,
                    maxWidth: MediaQuery.of(context).size.width - 140,
                  ),
                  child:
                      Text('$_productName', style: Palette.prductDetailsTitle),
                ),
                background: _loading == true
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : _imgesSlider(),
              ),
            )
          ];
        },
        /*------------------ body - List View ----------------*/
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*------------- Price -----------*/
              _priceContainer(),
              SizedBox(height: 5.0),
              /*------------- Details -----------*/
              _productDetails(),
              /*------------- Additional Details -----------*/
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Additional Details', style: Palette.title),
              ),
              _additionDetails(),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Product Description', style: Palette.title),
              ),
              _productDescription(),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Amenities', style: Palette.title),
              ),
              _amenitiesDetails(),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Water Source', style: Palette.title),
              ),
              _waterSourceDetails(),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Row(
                  children: [
                    Text('Location', style: Palette.title),
                    SizedBox(width: 8.0),
                    Text('( Tap marker to open Maps )', style: Palette.subTitle)
                  ],
                ),
              ),
              _googleMapController(),
              _bannerAd(),
              /*------------- Enquiry -----------*/
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Get in touch with Seller', style: Palette.title),
              ),
              _sellerContainer(),
              /*------------- Similar -----------*/
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Text('Similar Properties', style: Palette.title),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                child: gridViewProducts(),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  //$imagesBaseURL$i
  Widget _imgesSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 1500),
        scrollDirection: Axis.horizontal,
      ),
      items: imagesArray.map((index) {
        int indexVal = 0;
        return Builder(
          builder: (BuildContext context) {
            print("$imagesBaseURL/$index");
            return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductImgGallery(
                          indexVal, imagesBaseURL, imagesArray))),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      imagesBaseURL + '/' + index,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: Palette.imageShadow,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _priceContainer() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 15.0),
          Text('New Booking Price', style: Palette.subTitle),
          SizedBox(height: 2.0),
          Text(
              _productPrice == "0.00"
                  ? 'On Request'
                  : '\u{20B9}' + '$_productPrice',
              style: Palette.priceHeader),
          SizedBox(height: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Text('$_bhk BHK', style: Palette.subTitle2),
              SizedBox(width: 5.0),
              Icon(Icons.radio_button_checked_rounded,
                  size: 10.0, color: Colors.grey), */
              SizedBox(width: 5.0),
              Text('$_category', style: Palette.subTitle2),
              SizedBox(width: 5.0),
              Icon(Icons.radio_button_checked_rounded,
                  size: 10.0, color: Colors.grey),
              SizedBox(width: 5.0),
              Text('$_subCategory', style: Palette.subTitle2),
            ],
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

  Widget _productDetails() {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: Palette.cardShape,
      //color: Colors.grey,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                /*Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Carpet Area',
                        style: Palette.subTitle,
                      ),
                      Text(
                        '$_carpetArea sq.ft.',
                        style: Palette.subTitle2,
                      ),
                    ],
                  ),
                ),*/
                Expanded(
                  child: Column(
                    children: [
                      /*Text(
                        'Posted By',
                        style: Palette.subTitle,
                      ),*/
                      Text(
                        '($_postedTime)',
                        style: Palette.subTitle2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //SizedBox(height: 12.0),
            Divider(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Area - Society',
                    style: Palette.subTitle,
                  ),
                  Text(
                    '$_location',
                    style: Palette.subTitle2Orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _additionDetails() {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: Palette.cardShape,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: _loading == false
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemCount:
                    additionInfoList != null || additionInfoList.isNotEmpty
                        ? additionInfoList.length
                        : 0,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${additionInfoList[index]['title']}',
                              style: Palette.subTitle),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              '${additionInfoList[index]['value']}',
                              style: Palette.subTitle2,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              )
            : Container(),
      ),
    );
  }

  Widget _amenitiesDetails() {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: Palette.cardShape,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: _loading == false
            ? amenitiesList != null
                ? GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (2 / 1),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(5.0),
                    shrinkWrap: true,
                    primary: false,
                    children: amenitiesList
                        .map(
                          (data) => Container(
                            padding: const EdgeInsets.all(10),

                            //  margin:EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            //color:data.color,
                            //color: RandomColorModel().getColor(),
                            child: Row(
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.network('${data['icon']}'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text('${data['value']}',
                                      style: Palette.subTitle2,
                                      textAlign: TextAlign.start),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'No Data',
                      style: Palette.subTitle2,
                      textAlign: TextAlign.center,
                    ),
                  )
            : Container(),
      ),
    );
  }

  Widget _waterSourceDetails() {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: Palette.cardShape,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: _loading == false
            ? waterSourceList != null
                ? GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (2 / 1),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(5.0),
                    shrinkWrap: true,
                    primary: false,
                    children: waterSourceList
                        .map(
                          (data) => Container(
                            padding: const EdgeInsets.all(10),

                            //  margin:EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            //color:data.color,
                            //color: RandomColorModel().getColor(),
                            child: Row(
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.network('${data['icon']}'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text('${data['value']}',
                                      style: Palette.subTitle2,
                                      textAlign: TextAlign.start),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'No Data',
                      style: Palette.subTitle2,
                      textAlign: TextAlign.center,
                    ),
                  )
            : Container(),
      ),
    );
  }

  Widget _productDescription() {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: Palette.cardShape,
      //color: Colors.blueGrey[50],
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Html(data: "$_description"),
      ),
    );
  }

  Widget _googleMapController() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 280.0,
      child: _latitudeValue != null
          ? GoogleMap(
              mapType: MapType.normal,
              markers: _createMarker(),
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitudeValue, _longitudeValue),
                zoom: 15.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _gMapController = controller;
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _bottomAppbar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*--------------------- Email -------------------*/
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 2.0, bottom: 2.0),
            child: IconButton(
              onPressed: () {
                _service.sendEmail(_email);
              },
              icon: Icon(Icons.email, color: cDarkBlue),
            ),
          ),

          /*--------------------- Message -------------------*/
          Padding(
            padding: EdgeInsets.only(right: 30.0, top: 2.0, bottom: 2.0),
            child: IconButton(
              onPressed: () {
                _service.sendSms(_phone);
              },
              icon: Icon(Icons.message, color: cDarkBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingCall() {
    return FloatingActionButton(
      backgroundColor: cDarkBlue,
      onPressed: () {
        _service.call(_phone);
      },
      child: Icon(
        Icons.call,
        color: Colors.white,
      ),
      //backgroundColor: Color.fromRGBO(6, 150, 160, 1),
      mini: true,
    );
  }

  Widget _sellerContainer() {
    return Card(
      elevation: 0.0,
      shape: Palette.cardShape,
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(height: 5.0),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserPosts(_sellerId, _username))),
            title: Text(
              '$_username',
              style: Palette.title2,
            ),
            leading: CircleAvatar(
              radius: 24.0,
              backgroundImage: NetworkImage(
                'https://www.phonepeproperty.com/storage/profile/small_$_userAvatar',
              ),
            ),
            trailing: Text('More Ads', style: Palette.subTitle2Orange),
          ),
          SizedBox(height: 5.0),
          Divider(),

          /*------------- Name -------------*/
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              style: Palette.textField,
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: Palette.textFieldLabel,
                //errorText: _validate ? 'Value Can\'t be empty' : null,
              ),
            ),
          ),

          /*------------- Email Address -------------*/
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: Palette.textField,
              onChanged: (value) {
                setState(() {
                  _emailValidate = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: Palette.textFieldLabel,
                errorText: _emailValidate ? 'Enter Valid Email' : null,
              ),
            ),
          ),

          /*------------- Mobile Number -------------*/
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
            child: TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              style: Palette.textField,
              onChanged: (value) {
                setState(() {
                  _phoneValidate = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                labelStyle: Palette.textFieldLabel,
                errorText: _phoneValidate ? 'Enter 10 Digit Number' : null,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          /*------------- Deler Radio -------------*/

          Row(
            children: [
              SizedBox(width: 15.0),
              Expanded(
                  child: Text(
                'Are you proprty dealer?',
                style: Palette.textField,
              )),
              Container(
                child: Radio(
                  activeColor: cDarkBlue,
                  value: 'yes',
                  groupValue: _delerRadio,
                  onChanged: (val) {
                    setState(() {
                      _delerRadio = val;
                    });
                  },
                ),
              ),
              Container(
                child: Text(
                  'Yes',
                  style: Palette.textFieldLabel,
                ),
              ),
              SizedBox(width: 5.0),
              Container(
                child: Radio(
                  activeColor: cDarkBlue,
                  value: 'no',
                  groupValue: _delerRadio,
                  onChanged: (val) {
                    setState(() {
                      _delerRadio = val;
                    });
                  },
                ),
              ),
              Container(
                child: Text(
                  'No',
                  style: Palette.textFieldLabel,
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
          SizedBox(height: 10.0),
          MaterialButton(
            onPressed: () {
              //sendEnquirey();
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = RegExp(pattern);
              setState(() {
                numberController.text.length != 10
                    ? _phoneValidate = true
                    : _phoneValidate = false;

                if (!regex.hasMatch(emailController.text)) {
                  _emailValidate = true;
                } else {
                  _emailValidate = false;
                }

                if (_phoneValidate == false && _emailValidate == false) {
                  sendEnquirey();
                  print('Enquiry sent successfully...!');
                }
              });
            },
            shape: Palette.cardShape,
            minWidth: 200.0,
            color: cDarkBlue,
            child: Text(
              'Enquiry',
              style: Palette.btnText,
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  //set google map Location Marker
  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Location"),
        position: LatLng(_latitudeValue, _longitudeValue),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "$_location"),
      )
    ].toSet();
  }

  //fetch Product Details Api
  Future<void> fetchProductDetails(String productId) async {
    var pref = await SharedPreferences.getInstance();
    _userId = pref.getString('userid');

    var req = {'item_id': productId};

    print(req);

    //url
    final String url = Constants.PRODUCT_DETAILS;

    http.Response response = await http.post(url, body: req);

    //object response
    var responseData = json.decode(response.body);

    print(responseData);

    var decode = responseData;

    setState(() {
      fetchProducts();
      imagesArray = decode['images'];

      //set values
      _productName = decode['title'];
      _category = decode['category_name'];
      _categoryId = decode['category_id'];
      _subCategory = decode['sub_category_name'];
      _subCategoryId = decode['sub_category_id'];
      _postedTime = decode['created_at'];
      _location = decode['location'];
      _city = decode['city'];
      _state = decode['state'];
      _country = decode['country'];
      _description = decode['description'];

      //set Contact
      _phone = decode['phone'];
      _email = decode['seller_email'];
      _username = decode['seller_name'];
      _userAvatar = decode['seller_image'];
      _sellerId = decode['seller_id'];

      //set Image
      imagesBaseURL = decode['original_images_path'];
      _productImg = imagesBaseURL + imagesArray[0];

      //set Price
      var _price = decode['price'];
      var _formatePrice;
      _price == null ? _formatePrice = "0" : _formatePrice = _price;
      _productPrice = NumberFormatter.formatter('$_formatePrice');
      _productOriginalPrice = _price;

      additionInfoList = decode['additional_info'];
      amenitiesList = decode['Amenities'];
      waterSourceList = decode['Water Source'];

      //set LatLng for map
      var _lat = decode['map_latitude'];
      var _lng = decode['map_longitude'];

      _latitudeValue = double.parse('$_lat');
      _longitudeValue = double.parse('$_lng');

      //share
      _productURL = decode['product_url'];

      //set additional info

      //delete visible
      if (_sellerId == _userId) {
        _checkYourPost = true;
      } else {
        _checkYourPost = false;
      }

      //set Loader
      if (_productImg != "") {
        _loading = false;
      } else {
        _loading = true;
      }
      //fetch related products
      //fetchProducts();
    });
  }

  //Send enqiurey
  sendEnquirey() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog(context, _keyLoader);
    var userid = pref.getString("userid");
    String token = pref.getString('token');
    final String url = "${Constants.SEND_INQUIREY}";

    var requestBody = {
      'user_id': userid,
      'auther_id': "$_sellerId",
      'deler': "$_delerRadio",
      'name': nameController.text.toString(),
      'email': emailController.text.toString(),
      'mobile': numberController.text.toString(),
      'pid': productId
    };

    http.Response response = await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      body: requestBody,
    );

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    _enquireySuccess = decode['status'];

    setState(() {
      if (_enquireySuccess == "success") {
        nameController.text = "";
        emailController.text = "";
        numberController.text = "";
        Navigator.pop(_keyLoader.currentContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enquiry sent successfully...!"),
          duration: Duration(seconds: 3),
        ));
      } else {
        Navigator.pop(_keyLoader.currentContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${decode['msg']}"),
          duration: Duration(seconds: 3),
        ));
      }
    });
  }

  Future<void> fetchProducts() async {
    var preferences = await SharedPreferences.getInstance();

    _stateCode = preferences.getString('state_code');
    _state = preferences.getString('state_name');
    _cityCode = preferences.getString('city_code');
    _city = preferences.getString('city_name');
    _loacalityCode = preferences.getString('locality_code');
    _locality = preferences.getString('locality_name');

    //list
    try {
      var req = {
        'status': 'active',
        'country_code': 'in',
        'state': _stateCode,
        'city': _cityCode,
        'page': '2',
        'limit': '20',
        'category_id': _categoryId,
        'subcategory_id': _subCategoryId,
      };

      final response = await http.post(
        Constants.CATEGORY_PRODUCTS_URL,
        body: req,
      );
      print(response);

      var decode = json.decode(response.body);

      setState(() {
        _loading2 = false;
        productList = decode;
      });
    } catch (e) {
      setState(() {
        _loading2 = false;
        _error = true;
      });
    }
  }

  Future<void> _share() async {
    await FlutterShare.share(
      title: 'PhonePe Property',
      text: 'Have a look of this on PhonePe Property',
      linkUrl: '$_productURL',
      chooserTitle: 'PhonePe Property',
    );
  }

  Future<bool> _onDeleteDialogue() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //title: Text('Do you want to exit an App', style: _subTitle,),
            content: Text(
              'Do you want to Delete Post?',
              style: Palette.title,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletePost();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deletePost() async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);
    SharedPreferences pref = await SharedPreferences.getInstance();

    String token = pref.getString('token');

    final String url = Constants.DELETE_AD;

    var req = {'pro_id': productId};

    http.Response response = await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      body: req,
    );

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(_keyLoader.currentContext);
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pop(_keyLoader.currentContext);
    }
    print(response.body);
  }

  Widget _bannerAd() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.BANNER,
    );
  }

  //Grid List View
  Widget gridViewProducts() {
    if (productList.isEmpty) {
      if (_loading2) {
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
              _loading2 = true;
              _error = false;
              fetchProducts();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading properties, tap to try agin"),
          ),
        ));
      }
    } else {
      return ListView.builder(
          itemCount: productList.length,
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            if (index == productList.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading2 = true;
                      _error = false;
                      fetchProducts();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child:
                        Text("Error while loading properties, Tap to try agin"),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    color: cDarkBlue,
                  ),
                ));
              }
            }

            //Data From Model
            var modelProducts = productList[index];
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
                                              top: 5.0,
                                              left: 10.0,
                                              right: 10.0),
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
                                ]),
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
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, 2.0, 5.0, 2.0),
                                      child:
                                          Text('\u{20B9}' + '$_formatedPrice',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                                color: Palette.themeColor,
                                              ))))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            );
          });
    }
    return Container();
  }

  void _editPostNavigation() {
    print(widget.productId);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductOne(
            title: _productName,
            postId: widget.productId,
            catId: _categoryId,
            catName: _category,
            subCatId: _subCategoryId,
            subCatName: _subCategory,
            price: _productOriginalPrice,
            mobileNo: _phone,
            desc: _description,
            images: imagesArray,
            stateCode: _stateCode,
            statename: _state,
            cityCode: _cityCode,
            cityName: _city,
            localityName: _locality,
            localityCode: _loacalityCode,
            latValue: _latitudeValue,
            longValue: _longitudeValue,
            address: _location,
          ),
        ));
  }
}
