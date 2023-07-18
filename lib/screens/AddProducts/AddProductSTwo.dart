import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:phonepeproperty/screens/AddProducts/dynamicAdditionalInfo.dart';
import 'package:phonepeproperty/screens/AddProducts/selectStatePost.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/customDialog.dart';
import 'package:phonepeproperty/widgets/loadingDialogImg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;

class AddProductSTwo extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String subCatId;
  final String subCatName;
  final String adTitle;
  final String price;
  final String mobileNo;
  final String desc;
  final List<String> images;
  final String stateCode;
  final String stateName;
  final String cityCode;
  final String cityName;
  final String localityCode;
  final String localityName;
  final double latitudeValue;
  final double longitudeValue;
  final String address;
  final String additionalList;
  final String uploadedImages;

  AddProductSTwo(
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
      this.additionalList,
      this.uploadedImages);

  @override
  State<StatefulWidget> createState() => _AddProductSTwoState(
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
      this.additionalList,
      this.uploadedImages);
}

class _AddProductSTwoState extends State<AddProductSTwo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String categoryId;
  String categoryName;
  String categoryImg;
  String subCatId;
  String subCatName;
  String adTitle;
  String price;
  String mobileNo;
  String desc;
  List<String> images;
  String stateCode;
  String stateName;
  String cityCode;
  String cityName;
  String localityCode;
  String localityName;
  double latitudeValue;
  double longitudeValue;
  String address;
  String additionalList;
  String uploadedImages;

  _AddProductSTwoState(
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
      this.additionalList,
      this.uploadedImages);

  String countryCode = 'IN';

  bool _locationVisisble = false;
  bool _addressVisisble = false;

  String _postedImgs;
  List _listToPostImg = [];
  List addImagesRepsone = [];
  String _itemScreen;

  //map
  GoogleMapController _gMapController;

  //PickResult selectedPlace;
  String apiKeys = Constants.MAP_API;

  @override
  void initState() {
    super.initState();
    _itemScreen = uploadedImages;
    stateName != '' ? _locationVisisble = true : _locationVisisble = false;
    address != '' ? _addressVisisble = true : _addressVisisble = false;
    if (latitudeValue == 0.0 || latitudeValue == null) {
      _getUserLocation();
    }
    // if (images.length != 0) {
    //   print('Image of Ads uploading..!');
    //   print('upload image lenght : ${images.length}');
    //   for (var i = 0; i < images.length; i++) {
    //     _postedImgs = images[i];
    //     _postImgApi(_postedImgs);
    //   }
    // }
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('$adTitle', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: ListView(
        children: [location(), _selectLocation(), _additinalInfo()],
      ),
      floatingActionButton: _sendBtn(),
    );
  }

  Widget location() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            ListTile(
              title: Text('Location Area', style: Palette.title2),
              trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectStateAddProd(
                            categoryId,
                            categoryName,
                            categoryImg,
                            subCatId,
                            subCatName,
                            adTitle,
                            price,
                            mobileNo,
                            desc,
                            images,
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                          ))),
            ),
            Visibility(
                visible: _locationVisisble,
                child: Column(
                  children: [
                    Divider(height: 5.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 30.0, child: Icon(Icons.my_location)),
                          SizedBox(width: 10.0),
                          Container(
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white24,
                              shape: Palette.cardShape,
                              child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Text('$stateName',
                                      style: Palette.subTitleBold)),
                            ),
                          ),
                          Text(' > ', style: Palette.title),
                          Expanded(
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white24,
                              shape: Palette.cardShape,
                              child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Text('$cityName',
                                      style: Palette.subTitleBold)),
                            ),
                          ),
                          localityName != ''
                              ? Expanded(
                                  child: Card(
                                    elevation: 0.0,
                                    color: Colors.blueGrey[50],
                                    shape: Palette.cardShape,
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5.0, 10.0, 5.0),
                                        child: Text('$localityName',
                                            style: Palette.subTitleBold)),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  //select Location
  Widget _selectLocation() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            ListTile(
              title: Text('Address on Map', style: Palette.title2),
              trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacePicker(
                    apiKey: apiKeys, // Put YOUR OWN KEY here.
                    onPlacePicked: (PickResult result) {
                      setState(() {
                        _addressVisisble = true;
                        address = result.formattedAddress;
                        latitudeValue = result.geometry.location.lat;
                        longitudeValue = result.geometry.location.lng;
                      });
                      Navigator.of(context).pop();
                    },
                    initialPosition: LatLng(latitudeValue, longitudeValue),
                    useCurrentLocation: true,
                    selectInitialPosition: true,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _addressVisisble,
              child: Column(
                children: [
                  Divider(height: 5.0),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '$address',
                      style: Palette.subTitleBold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _additinalInfo() {
    return Container(
      margin: EdgeInsets.only(right: 50.0, left: 50.0, top: 20.0),
      child: MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DynamicAdditionalInfo(
                    categoryId,
                    categoryName,
                    categoryImg,
                    subCatId,
                    subCatName,
                    adTitle,
                    price,
                    mobileNo,
                    desc,
                    images,
                    stateCode,
                    stateName,
                    cityCode,
                    cityName,
                    localityCode,
                    localityName,
                    latitudeValue,
                    longitudeValue,
                    address,
                  ),
                ));
          },
          padding: EdgeInsets.all(12.0),
          color: cDarkBlue,
          shape: Palette.topCardShape,
          child: Text(
            'Add Additonal Information',
            style: Palette.textFieldWhite,
          )),
    );
  }

  Widget _sendBtn() {
    return FloatingActionButton.extended(
      onPressed: () {
        setState(() {
          if (stateName == '' || stateName == null) {
            /* sacffMsg.showSnackBar(SnackBar(
                content: Text('Please select State & City..!'),
                duration: Duration(seconds: 3))); */
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please select State & City..!'),
              duration: Duration(seconds: 3),
            ));
          } else if (additionalList == '' || additionalList == null) {
            /* sacffMsg.showSnackBar(SnackBar(
                content: Text('Please Add Additional Information..!'),
                duration: Duration(seconds: 3))); */
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Add Additional Information..!'),
              duration: Duration(seconds: 3),
            ));
          } else {
            _postAddApi();
            // if (images.length == 0) {
            //   _postAddApi();
            //   _itemScreen = '';
            //   print('Post Ads uploading..!');
            // } else {
            //   LoadingDialogImg.showLoadingDialogImg(context, _keyLoader);
            //   print('Image of Ads uploading..!');
            //   for (var i = 0; i < images.length; i++) {
            //     _postedImgs = images[i];
            //     _postImgApi(_postedImgs);
            //   }
            // }

          }
        });
      },
      //color
      backgroundColor: cDarkBlue,
      //text
      label: Text('Post Ad', style: Palette.textFieldWhite),
      //icon
      icon: Icon(
        Icons.post_add,
        color: Colors.white,
      ),
    );
  }

  /*--------------- Send Image Api Calling -------------*/
  _postImgApi(String _postedImages) async {
    //LoadingDialog.showLoadingDialog(context, _keyLoader);
    //_waitBtn = true;

    final String url = "${Constants.POST_IMG}";

    var request = http.MultipartRequest("POST", Uri.parse(url));

    if (images == null) {
      images = null;
    } else {
      var _postImgs =
          await http.MultipartFile.fromPath("fileToUpload", _postedImages);
      request.files.add(_postImgs);
    }

    var response = await request.send();
    print(response.statusCode);

    //listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> decode = json.decode(value);
      setState(() {
        var responseMsg = decode['status'];
        var responseImg = decode['picture'];
        print(responseImg);

        if (response.statusCode == 200) {
          addImagesRepsone.add(responseImg);
          print('repsone Imgs == $addImagesRepsone');

          _itemScreen = addImagesRepsone
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');

          if (images.length == addImagesRepsone.length) {
            print('ready to send img == $_itemScreen');
            //Navigator.pop(_keyLoader.currentContext);
            //Upload Ads post
            //_postAddApi();
          } else {
            print('images not send, Please try again..!');
          }
        }
        //wrong username and password
        else if (response.statusCode != 200) {
          Navigator.pop(_keyLoader.currentContext);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$responseMsg'),
            duration: Duration(seconds: 3),
          ));
        }
      });
    });
  }

  _postAddApi() async {
    print('Additional List == $additionalList');
    LoadingDialogImg.showLoadingDialogImg(context, _keyLoader);

    var preferences = await SharedPreferences.getInstance();
    var userid = preferences.getString('userid') ?? '';
    String token = preferences.getString('token');

    // String _newItemScreen;
    // if (_itemScreen != null) {
    //   _newItemScreen = _itemScreen.replaceAll(' ', '');
    // } else {
    //   _newItemScreen = '';
    // }

    //url and querey.
    final String url = Constants.POST_AD;

    // var req = {
    //   'user_id': userid,
    //   'title': adTitle,
    //   'category_id': categoryId,
    //   'subcategory_id': subCatId,
    //   'country_code': countryCode,
    //   'state': stateCode,
    //   'city': cityCode,
    //   'locality': localityCode,
    //   'description': desc,
    //   'location': address,
    //   'hide_phone': '0',
    //   'negotiable': '0',
    //   'price': price,
    //   'phone': mobileNo,
    //   'latitude': latitudeValue,
    //   'longitude': longitudeValue,
    //   'additionalinfo': additionalList,
    // };

    // http.Response response = await http.post(url, body: req);

    //object response
    // Map<String, dynamic> decode = json.decode(response.body);
    // var _status = decode['status'];

    // if (_status == 'success') {
    //   Navigator.pop(_keyLoader.currentContext);
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) => CustomDialog(
    //             title: 'Ad Post Successful',
    //             description: 'Please wait for approving your ad..!',
    //             buttonText: 'Home',
    //             buttonText2: 'View Post',
    //           ));
    // } else {
    //   Navigator.pop(_keyLoader.currentContext);
    //   _showErrorDialogue('Error, Please try again..!');
    // }

    // debugPrint(response.body);

    var request = http.MultipartRequest("POST", Uri.parse(url));

    if (images.length != 0) {
      print('upload image lenght : ${images.length}');
      for (var i = 0; i < images.length; i++) {
        _postedImgs = images[i];
        var _postImgs = await http.MultipartFile.fromPath(
            "item_screen[]", _postedImgs); //😍
        request.files.add(_postImgs);
      }
    }

    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    request.fields['user_id'] = userid;
    request.fields['title'] = adTitle;
    request.fields['category_id'] = categoryId;
    request.fields['subcategory_id'] = subCatId;
    request.fields['country_code'] = countryCode;
    request.fields['state'] = stateCode;
    request.fields['city'] = cityCode;
    request.fields['locality'] = localityCode;
    request.fields['description'] = desc;
    request.fields['location'] = address;
    request.fields['hide_phone'] = '0';
    request.fields['negotiable'] = '0';
    request.fields['price'] = price;
    request.fields['phone'] = mobileNo;
    request.fields['latitude'] = latitudeValue.toString();
    request.fields['longitude'] = longitudeValue.toString();
    request.fields['additionalinfo'] = additionalList;

    var response = await request.send();
    print(response.statusCode);

    //listen for response
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
        Map<String, dynamic> decode = json.decode(value);

        print(decode);

        //set response
        if (response.statusCode == 200) {
          Navigator.pop(_keyLoader.currentContext);
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                    title: 'Property Post Successfully',
                    description:
                        'You can show your prorerty on feed and profile.',
                    buttonText: 'Home',
                    buttonText2: 'View Post',
                  ));
        } else {
          Navigator.pop(_keyLoader.currentContext);
          _showErrorDialogue('Error, Please try again..!');
        }
      },
    );
  }

  //Current location from geolocator
  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    latitudeValue = position.latitude;
    longitudeValue = position.longitude;
    print('$latitudeValue, $longitudeValue');
  }

  void _showErrorDialogue(String message) {
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
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      'Login Faild..!\n$message',
                      style: Palette.title2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                        child: Text('Retry', style: Palette.themeBtnText),
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
