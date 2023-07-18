import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/model/Weight.dart';
import 'package:phonepeproperty/screens/AddProducts/AddProductSOne.dart';
import 'package:phonepeproperty/screens/EditProducts/category/editPostCategory.dart';
import 'package:phonepeproperty/screens/EditProducts/editPostAdditionalInfo.dart';
import 'package:phonepeproperty/screens/EditProducts/location/editPostStateSelect.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/customDialog.dart';
import 'package:phonepeproperty/widgets/loadingDialogImg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductOne extends StatefulWidget {
  final String title,
      postId,
      catId,
      catName,
      catImg,
      subCatId,
      subCatName,
      price,
      mobileNo,
      desc,
      stateCode,
      statename,
      cityCode,
      cityName,
      localityName,
      localityCode,
      address,
      additionalList;
  final List images;
  final double latValue;
  final double longValue;
  const EditProductOne(
      {this.title,
      this.postId,
      this.catId,
      this.catName,
      this.catImg,
      this.subCatId,
      this.subCatName,
      this.price,
      this.mobileNo,
      this.desc,
      this.images,
      this.stateCode,
      this.statename,
      this.cityCode,
      this.cityName,
      this.localityName,
      this.localityCode,
      this.latValue,
      this.longValue,
      this.address,
      this.additionalList});

  @override
  _EditProductOneState createState() => _EditProductOneState();
}

class _EditProductOneState extends State<EditProductOne> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool _validate = false;
  bool _propertyTypeVisible = false;

  List<Wieght> storeFilePaths = [];
  List<String> storeToDisplayFilePaths = [];

  String _postedImgs;
  List _listToPostImg = [];
  List addImagesRepsone = [];

  bool _imageRemovewTxteVisible = false;

  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions = ['jpg', 'png', 'jpeg'];
  bool isLoadingPath = false;
  bool isMultiPick = true;
  FileType fileType;
  String lstindex;
  String filePath;

  bool _editImgVisibility = true;
  bool _removedImgVisiblity = true;

  List _postedImgList;

  String countryCode = 'IN';
  bool _locationVisisble = false;

  bool _addressVisisble = false;

  //PickResult selectedPlace;
  String apiKeys = Constants.MAP_API;
  String address;
  double latitudeValue;
  double longitudeValue;

  List _pickedImgsList = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    priceController.text = widget.price;
    phoneController.text = widget.mobileNo;
    descController.text = widget.desc;
    _postedImgList = widget.images;
    widget.catName != ''
        ? _propertyTypeVisible = true
        : _propertyTypeVisible = false;
    if (_postedImgList.length == 0) {
      _removedImgVisiblity = false;
    }
    if (widget.statename != null) {
      _locationVisisble = true;
    }
    address = widget.address;
    latitudeValue = widget.latValue;
    longitudeValue = widget.longValue;
    address != '' ? _addressVisisble = true : _addressVisisble = false;
    print('${widget.images}');
  }

  //--------------------- build Function -------------------------//
  //-----------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Property', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      key: _scaffoldKey,
      //------------------- Body -----------------//
      body: ListView(
        children: [
          titleWidget(),
          propertyType(),
          _priceAndMobno(),
          //_descCard(),
          _location(),
          _selectLocation(),
          _additinalInfo(),
          _imageCard(),
          SizedBox(height: 60.0)
        ],
      ),
      floatingActionButton: _editBtn(),
    );
  }

  Widget titleWidget() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 15.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
          child: TextField(
            controller: titleController,
            keyboardType: TextInputType.name,
            style: Palette.textField,
            onChanged: (value) {},
            decoration: InputDecoration(
              labelText: 'Your Ad Title',
              labelStyle: Palette.textFieldLabel,
              errorText: _validate ? 'Value Can\'t be empty' : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget propertyType() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            ListTile(
              title: Text('Property Type', style: Palette.title2),
              trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () {
                _selectcategoryNavigation();
              },
            ),
            Visibility(
              visible: _propertyTypeVisible,
              child: Column(
                children: [
                  Divider(height: 5.0),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Card(
                            elevation: 0.0,
                            color: Colors.white24,
                            shape: Palette.cardShape,
                            child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: Text('${widget.catName}',
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
                                child: Text('${widget.subCatName}',
                                    style: Palette.subTitleBold)),
                          ),
                        ),
                      ],
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

  Widget _priceAndMobno() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 12.0,
              shadowColor: Colors.black26,
              shape: Palette.topCardShape,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: Palette.textField,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    /* enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)), */
                    labelText: 'Price' + ' in ' + '\u{20B9}',
                    labelStyle: Palette.textFieldLabel,
                    //errorText: _validate ? 'Value Can\'t be empty' : null,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 12.0,
              shadowColor: Colors.black26,
              shape: Palette.topCardShape,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: Palette.textField,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    /* enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)), */
                    labelText: 'Mobile No.',
                    labelStyle: Palette.textFieldLabel,
                    //errorText: _validate ? 'Value Can\'t be empty' : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descCard() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
          child: TextField(
            controller: descController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: Palette.textField,
            onChanged: (value) {},
            decoration: InputDecoration(
              /* enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)), */
              labelText: 'Description',
              labelStyle: Palette.textFieldLabel,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageCard() {
    return Visibility(
      visible: _editImgVisibility,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Card(
          elevation: 12.0,
          shadowColor: Colors.black26,
          shape: Palette.topCardShape,
          child: imagePicker(),
        ),
      ),
    );
  }

  Widget imagePicker() {
    for (var i = 0; i < storeToDisplayFilePaths.length; i++) {
      print('storeToDisplayFilePathsUrl : ' + storeToDisplayFilePaths[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Pick Images', style: Palette.title2),
          trailing: Text('Add Image', style: Palette.subTitle4Orange),
          onTap: () {
            _openFileExplorer();
            setState(() {
              _imageRemovewTxteVisible = true;
            });
          },
        ),

        //Divider(height: 5.0),
        Wrap(
          children: [
            Visibility(
              visible: _removedImgVisiblity,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _postedImgList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 150.0,
                      width: 120.0,
                      margin: EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 120.0,
                            width: 120.0,
                            margin: EdgeInsets.only(top: 10.0),
                            child: Image.network(
                              "https://phonepeproperty.com/storage/products/${_postedImgList[index]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _postedImgList.removeAt(index);
                                  if (_postedImgList.length == 0) {
                                    _removedImgVisiblity = false;
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 12.0,
                                backgroundColor: Colors.red[700],
                                child: Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Builder(
              builder: (BuildContext context) => isLoadingPath
                  ? Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0))
                  : path != null || paths != null
                      ? Container(
                          padding: const EdgeInsets.all(5.0),
                          height: 140.0,
                          width: MediaQuery.of(context).size.width,
                          child: Scrollbar(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: storeToDisplayFilePaths != null &&
                                      storeToDisplayFilePaths.isNotEmpty
                                  ? storeToDisplayFilePaths.length
                                  : 1,
                              itemBuilder: (BuildContext context, int index) {
                                final bool isMultiPath =
                                    paths != null && paths.isNotEmpty;

                                print("indexValue " + index.toString());
                                print('new paths : ' +
                                    storeToDisplayFilePaths[index]);

                                filePath = isMultiPath
                                    ? storeToDisplayFilePaths[index]
                                    : path;

                                //set image to post
                                _listToPostImg = paths.values.toList();
                                print('listToPostImg ${_listToPostImg.length}');
                                for (var i = 0;
                                    i < _listToPostImg.length;
                                    i++) {
                                  _postedImgs = paths.values.toList()[i];
                                  _pickedImgsList.add(_postedImgs);
                                  print(_listToPostImg);
                                  print('post images ==' + _postedImgs);
                                }

                                print('displayImg == ${storeFilePaths.length}');
                                //display
                                return Dismissible(
                                  key: Key(storeToDisplayFilePaths[index]
                                      .toString()),
                                  direction: DismissDirection.up,
                                  onDismissed: (direction) {
                                    setState(() {
                                      storeToDisplayFilePaths.removeAt(index);
                                      if (storeToDisplayFilePaths.length ==
                                              null ||
                                          storeToDisplayFilePaths.isEmpty) {
                                        paths = null;
                                        path = null;
                                        _imageRemovewTxteVisible = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 120.0,
                                    width: 120.0,
                                    margin: EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 120.0,
                                          width: 120.0,
                                          child: Image.file(File(filePath),
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
            ),
          ],
        ),

        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'SWIPE UP TO REMOVE IMAGE',
            style: Palette.subTitle4Orange,
          ),
        ),
      ],
    );
  }

  //Open File Picker
  void _openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      if (isMultiPick) {
        path = null;
        paths = await getMultiFilePath();

        print('path === ${paths.values}');
        //storeFilePaths.addAll(paths);

        storeFilePaths =
            paths.entries.map((entry) => Wieght(entry.value)).toList();

        print("storeFilePaths" + storeFilePaths.length.toString());

        if (storeToDisplayFilePaths.length > 0) {
          // lstindex = storeToDisplayFilePaths.last;
          // int index =
          //     storeToDisplayFilePaths.lastIndexOf(storeToDisplayFilePaths.last);
          // int increment = index + 1;
          // print("LastIndex ======" + lstindex);
          // print("LastIndex ======" + index.toString());
          for (var i = 0; i < storeFilePaths.length; i++) {
            Wieght w = storeFilePaths[i];
            print("storeFilePaths : " + w.wPath);
            storeToDisplayFilePaths.add(w.wPath);
            //increment++;
            /* Wieght w2 = storeToDisplayFilePaths[i];
          print("storeToDisplayFilePaths : " + w2.wPath); */
          }
        } else {
          for (var i = 0; i < storeFilePaths.length; i++) {
            Wieght w = storeFilePaths[i];
            print("storeFilePaths : " + w.wPath);
            storeToDisplayFilePaths.add(w.wPath);
            /* Wieght w2 = storeToDisplayFilePaths[i];
          print("storeToDisplayFilePaths : " + w2.wPath); */
          }
        }
      } else {
        FilePickerResult result = await FilePicker.platform.pickFiles();
        if (result != null) {
          PlatformFile file = result.files.first;
          path = file.path;
        }

        paths = null;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoadingPath = false;
      fileName = path != null
          ? path.split('/').last
          : paths != null
              ? paths.keys.toString()
              : '...';
    });
  }

  void _selectcategoryNavigation() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPostCategory(
            postId: widget.postId,
            title: titleController.text,
            catId: widget.catId,
            catName: widget.catName,
            catImg: widget.catImg,
            subCatId: widget.subCatId,
            subCatName: widget.subCatName,
            price: priceController.text,
            mobileNo: phoneController.text,
            desc: descController.text,
            images: widget.images,
            stateCode: widget.stateCode,
            statename: widget.statename,
            cityCode: widget.cityCode,
            cityName: widget.cityName,
            localityName: widget.localityName,
            localityCode: widget.localityCode,
            latValue: widget.latValue,
            longValue: widget.longValue,
            address: widget.address,
          ),
        ));
  }

  Widget _location() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Location Area', style: Palette.title2),
              trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () {
                _locationSelectNavigation();
              },
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
                        Container(height: 30.0, child: Icon(Icons.my_location)),
                        SizedBox(width: 10.0),
                        Container(
                          child: Card(
                            elevation: 0.0,
                            color: Colors.white24,
                            shape: Palette.cardShape,
                            child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: Text('${widget.statename}',
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
                                child: Text('${widget.cityName}',
                                    style: Palette.subTitleBold)),
                          ),
                        ),
                        widget.localityName != ''
                            ? Expanded(
                                child: Card(
                                  elevation: 0.0,
                                  color: Colors.blueGrey[50],
                                  shape: Palette.cardShape,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 5.0, 10.0, 5.0),
                                      child: Text(
                                        '${widget.localityName}',
                                        style: Palette.subTitleBold,
                                      )),
                                ),
                              )
                            : Container(),
                      ],
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

  void _locationSelectNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostStateSelect(
          postId: widget.postId,
          title: titleController.text,
          catId: widget.catId,
          catName: widget.catName,
          catImg: widget.catImg,
          subCatId: widget.subCatId,
          subCatName: widget.subCatName,
          price: priceController.text,
          mobileNo: phoneController.text,
          desc: descController.text,
          images: widget.images,
          stateCode: widget.stateCode,
          statename: widget.statename,
          cityCode: widget.cityCode,
          cityName: widget.cityName,
          localityName: widget.localityName,
          localityCode: widget.localityCode,
          latValue: widget.latValue,
          longValue: widget.longValue,
          address: widget.address,
        ),
      ),
    );
  }

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
      margin: EdgeInsets.all(15.0),
      child: MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPostAdditionalInfo(
                    postId: widget.postId,
                    title: titleController.text,
                    catId: widget.catId,
                    catName: widget.catName,
                    catImg: widget.catImg,
                    subCatId: widget.subCatId,
                    subCatName: widget.subCatName,
                    price: priceController.text,
                    mobileNo: phoneController.text,
                    desc: descController.text,
                    images: widget.images,
                    stateCode: widget.stateCode,
                    statename: widget.statename,
                    cityCode: widget.cityCode,
                    cityName: widget.cityName,
                    localityName: widget.localityName,
                    localityCode: widget.localityCode,
                    latValue: widget.latValue,
                    longValue: widget.longValue,
                    address: widget.address,
                  ),
                ));
          },
          padding: EdgeInsets.all(12.0),
          color: Palette.themeColor,
          shape: Palette.topCardShape,
          child: Text(
            'Add Additonal Information',
            style: Palette.textFieldWhite,
          )),
    );
  }

  _editBtn() {
    return FloatingActionButton.extended(
      label: Text('Edit Ad', style: Palette.textFieldWhite),
      icon: Icon(
        Icons.edit_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        _editPostApi();
      },
    );
  }

  Future<String> _editPostApi() async {
    LoadingDialogImg.showLoadingDialogImg(context, _keyLoader);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('userid');

    print("Post id ====== ${widget.postId}");

    String _title = titleController.text;
    String _price = priceController.text;
    String _mobileNo = phoneController.text;
    //String _desc = descController.text;
    String _desc = widget.desc;

    String _oldImgs = _postedImgList.toString();
    String _sendOldImgs = _oldImgs.replaceAll('[', '').replaceAll(']', '');

    String _catId = widget.catId;
    String _subCateId = widget.subCatId;
    String _stateCode = widget.stateCode;
    String _cityCode = widget.cityCode;
    String _locality = widget.localityCode;
    String _additionalList = widget.additionalList;

    //url and querey.
    String url = Constants.POST_AD;

    var request = http.MultipartRequest("POST", Uri.parse(url));

    //request.fields["action"] = "edit_post";
    request.fields["pro_id"] = widget.postId ?? '';
    request.fields["user_id"] = userId ?? '';
    request.fields["title"] = _title ?? '';
    request.fields["catid"] = _catId ?? '';
    request.fields["subcatid"] = _subCateId ?? '';
    request.fields["country_code"] = countryCode;
    request.fields["state"] = _stateCode;
    request.fields["city"] = _cityCode;
    request.fields["locality"] = _locality;
    request.fields["content"] = _desc;
    request.fields["address"] = address ?? '';
    request.fields["hide_phone"] = "0";
    request.fields["negotiable"] = "0";
    request.fields["price"] = _price ?? '';
    request.fields["phone"] = _mobileNo ?? '';
    request.fields["latitude"] = latitudeValue.toString() ?? '';
    request.fields["longitude"] = longitudeValue.toString() ?? '';
    request.fields["item_screen"] = _sendOldImgs ?? '';
    request.fields["additionalinfo"] = _additionalList ?? '';

    print("Post Image Uri : $_postedImgs");

    for (var j = 0; j < _pickedImgsList.length; j++) {
      if (_pickedImgsList[j] != null) {
        var _postImgs = await http.MultipartFile.fromPath(
            "item_screen[]", _pickedImgsList[j]);
        request.files.add(_postImgs);
      }
    }

    var response = await request.send();
    print(response.statusCode);

    //listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Navigator.pop(_keyLoader.currentContext);
      print(value);

      Map<String, dynamic> decode = json.decode(value);
      if (decode['status'] == "success") {
        //true
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
                  title: 'Ad Edited Successful',
                  description: 'Please wait for approving your ad..!',
                  buttonText: 'Home',
                  buttonText2: 'View Post',
                ));
      } else {
        //false
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(decode['errors'][0]['message']),
          duration: Duration(seconds: 3),
        ));
      }
    });

    return 'Success';
  }
}
