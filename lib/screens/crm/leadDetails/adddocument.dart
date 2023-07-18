import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/widgets/error_dialouge.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDocument extends StatefulWidget {
  final String leadId;

  AddDocument({@required this.leadId});

  @override
  _AddDocumentState createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyError = new GlobalKey<State>();

  /*------------ Add transaction   ------------*/
  String _txnExtension;
  String _txnFilePath;
  String _txnFileName;
  String _txnFileFormate;
  TextEditingController _txnFileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _txnFileController
        .addListener(() => _txnExtension = _txnFileController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        //brightness: Brightness.dark,
        backgroundColor: cDarkBlue,
        title: Text('Add Document', style: Palette.tabTitle),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              _panCardImgWidget(),
              SizedBox(height: 40.0),
              _addButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return Center(
      child: InkWell(
        onTap: () {
          _postDocumentAddApi();
        },
        child: Container(
          width: 200,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: cDarkBlue,
          ),
          child: Center(
            child: Text(
              'Save',
              style: Palette.addButton,
            ),
          ),
        ),
      ),
    );
  }

  Widget _panCardImgWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 3.0),
                elevation: 0.0,
                color: Colors.indigo.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  //margin: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          child: _txnFilePath == null
                              ? Text(
                                  'Select files to upload.',
                                  style: Palette.title2,
                                )
                              : Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 200.0,
                                  width: 200.0,
                                  child: Image.file(
                                    File(_txnFilePath),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.attach_file,
                          ),
                          onTap: () => getTxnFilePath(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  /*------------------ Add txn ----------------*/
  void getTxnFilePath() async {
    String filePath;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        String filePath = file.path;
      }

      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      setState(() {
        this._txnFilePath = filePath;

        final _extension = p.extension(filePath, 2);
        this._txnFileFormate = _extension;

        _txnFileName = filePath.split('/').last;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  _postDocumentAddApi() async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    var preferences = await SharedPreferences.getInstance();
    var userid = preferences.getString('userid') ?? '';
    String token = preferences.getString('token');

    final String url = Constants.ADD_LEAD_BY_TYPE;

    var request = http.MultipartRequest("POST", Uri.parse(url));

    if (_txnFilePath == null) {
      _txnFilePath = null;
    } else {
      var image =
          await http.MultipartFile.fromPath("document_file[]", _txnFilePath);
      request.files.add(image);
    }

    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    request.fields['user_id'] = userid;
    request.fields['type'] = 'document';
    request.fields['lead_id'] = widget.leadId;

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
          if (decode['status'] == "error") {
            ErrorDialouge.showErrorDialogue(
                context, _keyError, decode['message']);
          } else {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(_keyLoader.currentContext);
          ErrorDialouge.showErrorDialogue(
              context, _keyError, "Something went wrong");
        }
      },
    );
  }
}
