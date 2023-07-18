import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/model/Weight.dart';
import 'package:phonepeproperty/screens/category/selectCategory.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phonepeproperty/widgets/loadingDialog.dart';

import 'AddProductSTwo.dart';

class AddProductSOne extends StatefulWidget {
  final String title;
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String subCatId;
  final String subCategory;
  AddProductSOne(this.title, this.categoryId, this.categoryName,
      this.categoryImg, this.subCatId, this.subCategory);

  @override
  State<StatefulWidget> createState() => _AddProductSOneState(
      this.title,
      this.categoryId,
      this.categoryName,
      this.categoryImg,
      this.subCatId,
      this.subCategory);
}

class _AddProductSOneState extends State<AddProductSOne> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String title;
  String categoryId;
  String categoryName;
  String categoryImg;
  String subCatId;
  String subCatName;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descController = TextEditingController();

  _AddProductSOneState(this.title, this.categoryId, this.categoryName,
      this.categoryImg, this.subCatId, this.subCatName);

  bool _propertyTypeVisible = false;
  bool _imageRemovewTxteVisible = false;
  bool _validate = false;

  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions = ['jpg', 'png', 'jpeg'];
  bool isLoadingPath = false;
  bool isMultiPick = true;
  FileType fileType;
  String lstindex;
  String filePath;

  List<Wieght> storeFilePaths = [];
  List<String> storeToDisplayFilePaths = [];

  String _postedImgs;
  List _listToPostImg = [];
  List addImagesRepsone = [];
  String _itemScreen;

  bool _waitBtn = false;

  int isfirsttime = 0;

  @override
  void initState() {
    super.initState();
    titleController.text = title.toString();
    print('title == $title');
    categoryName != ''
        ? _propertyTypeVisible = true
        : _propertyTypeVisible = false;
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: cDarkBlue,
          title: Text('Sell / Rent Property', style: Palette.whiteTitle2),
          brightness: Brightness.dark,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        /*------------------ body ----------------*/
        body: ListView(
          children: [
            titleWidget(),
            propertyType(),
            _imageCard(),
            _priceAndMobno(),
            _descCard(),
            SizedBox(height: 30.0),
          ],
        ),
      ),
      floatingActionButton: _nextBtn(),
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectCategory(titleController.text))),
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
                              height: 30.0,
                              child: Image.network('$categoryImg')),
                          SizedBox(width: 10.0),
                          Container(
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white24,
                              shape: Palette.cardShape,
                              child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Text('$categoryName',
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
                                  child: Text('$subCatName',
                                      style: Palette.subTitleBold)),
                            ),
                          ),
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
              /* enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)), */
              labelText: 'Your Ad Title',
              labelStyle: Palette.textFieldLabel,
              errorText: _validate ? 'Value Can\'t be empty' : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageCard() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: imagePicker(),
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
          trailing: Text('Add Image', style: Palette.subTitleBlue),
          onTap: () {
            _openFileExplorer();
            setState(() {
              _imageRemovewTxteVisible = true;
            });
          },
        ),

        //Divider(height: 5.0),
        Builder(
          builder: (BuildContext context) => isLoadingPath
              ? Padding(padding: const EdgeInsets.only(top: 0.0, bottom: 0.0))
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
                            for (var i = 0; i < _listToPostImg.length; i++) {
                              _postedImgs = paths.values.toList()[i];
                              print(_listToPostImg);
                              print('post images ==== ' + _postedImgs);
                            }

                            print('displayImg === ${storeFilePaths.length}');

                            //display
                            return Dismissible(
                              key: Key(
                                storeToDisplayFilePaths[index].toString(),
                              ),
                              direction: DismissDirection.up,
                              onDismissed: (direction) {
                                setState(() {
                                  storeToDisplayFilePaths.removeAt(index);
                                  if (storeToDisplayFilePaths.length == null ||
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

        Visibility(
          visible: _imageRemovewTxteVisible,
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'SWIPE UP TO REMOVE IMAGE',
              style: Palette.subTitleBlue,
            ),
          ),
        )
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

  Widget _nextBtn() {
    return FloatingActionButton.extended(
      onPressed: () {
        setState(
          () {
            if (titleController.text.isEmpty) {
              _validate = true;
            } else if (categoryName == null || categoryName == '') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please select property type..!'),
                duration: Duration(seconds: 3),
              ));
            } else if (storeToDisplayFilePaths == []) {
              _validate = false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductSTwo(
                            categoryId,
                            categoryName,
                            categoryImg,
                            subCatId,
                            subCatName,
                            titleController.text,
                            priceController.text,
                            phoneController.text,
                            descController.text,
                            null,
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            0.0,
                            0.0,
                            '',
                            '',
                            '',
                          )));
            } else {
              _validate = false;
              // LoadingDialog.showLoadingDialog(context, _keyLoader);

              // for (var i = 0; i < storeToDisplayFilePaths.length; i++) {
              //   _postedImgs = storeToDisplayFilePaths[i];
              //   _postImgApi();
              // }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductSTwo(
                            categoryId,
                            categoryName,
                            categoryImg,
                            subCatId,
                            subCatName,
                            titleController.text,
                            priceController.text,
                            phoneController.text,
                            descController.text,
                            storeToDisplayFilePaths,
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            0.0,
                            0.0,
                            '',
                            '',
                            '',
                          )));
            }
          },
        );
      },
      //color
      backgroundColor: cDarkBlue,
      //text
      label: Text(_waitBtn == false ? 'Next' : 'Please wait',
          style: Palette.textFieldWhite),
      //icon
      icon: Icon(
        Icons.send_and_archive,
        color: Colors.white,
      ),
    );
  }

  /*--------------- Send Image Api Calling -------------*/
  _postImgApi() async {
    //LoadingDialog.showLoadingDialog(context, _keyLoader);
    _waitBtn = true;

    final String url = "${Constants.POST_IMG}";

    var request = http.MultipartRequest("POST", Uri.parse(url));

    if (storeToDisplayFilePaths == null) {
      storeToDisplayFilePaths = null;
    } else {
      var _postImgs =
          await http.MultipartFile.fromPath("fileToUpload", _postedImgs);
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
          //Navigator.pop(_keyLoader.currentContext);
          /*  sacffMsg.showSnackBar(SnackBar(
              content: Text('$responseMsg'), duration: Duration(seconds: 3))); */
          addImagesRepsone.add(responseImg);
          print('repsone Imgs == $addImagesRepsone');

          _itemScreen = addImagesRepsone
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');

          if (storeToDisplayFilePaths.length == addImagesRepsone.length) {
            print('ready to send img == $_itemScreen');
            _waitBtn = false;
            Navigator.pop(_keyLoader.currentContext);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => AddProductSTwo(
            //           categoryId,
            //           categoryName,
            //           categoryImg,
            //           subCatId,
            //           subCatName,
            //           titleController.text,
            //           priceController.text,
            //           phoneController.text,
            //           descController.text,
            //           _itemScreen,
            //           '',
            //           '',
            //           '',
            //           '',
            //           '',
            //           '',
            //           0.0,
            //           0.0,
            //           '',
            //           '',
            //         )));
          } else {
            _waitBtn = true;
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
}

Future<Map<String, String>> getMultiFilePath() async {
  Map<String, String> filePaths = {};

  // Open the file picker to select multiple files
  FilePickerResult results = await FilePicker.platform.pickFiles(
    allowMultiple: true,
  );

  if (results != null) {
    List<File> files = results.paths.map((path) => File(path)).toList();
    for (File file in files) {
      String fileName = results.files.single.name;
      String filePath = results.files.single.path;

      if (fileName != null && filePath != null) {
        filePaths[fileName] = filePath;
      }
    }
    return filePaths;
  } else {
    return filePaths;
  }
}
