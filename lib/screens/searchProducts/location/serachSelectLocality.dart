import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/searchProducts/categoryProducts.dart';
import 'package:phonepeproperty/screens/searchProducts/dynamicSearchFilter.dart';
import 'package:phonepeproperty/style/palette.dart';

class SearchSelectLocality extends StatefulWidget {
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
      cityName;

  SearchSelectLocality(
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
      this.cityName});

  @override
  _SearchSelectLocalityState createState() => _SearchSelectLocalityState();
}

class _SearchSelectLocalityState extends State<SearchSelectLocality> {
  List<dynamic> data = [];
  List<dynamic> filterlist = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Widget appBarTitle = Text("Select Locality", style: Palette.whiteTitle2);
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('cityid::::::::::::::::::::::::${widget.cityId}');
    List<dynamic> tmpList = List<dynamic>();
    for (int i = 0; i < data.length; i++) {
      tmpList.add(data[i]);
    }
    setState(() {
      data = tmpList;
      filterlist = data;

      controller.addListener(() {
        if (controller.text.isEmpty) {
          setState(() {
            filter = "";
            filterlist = data;
          });
        } else {
          setState(() {
            filter = controller.text;
          });
        }
      });
    });

    super.initState();
    fetchLocality();
  }

  //------------------------ Build Funaction -----------------//
  @override
  Widget build(BuildContext context) {
    //search function
    if ((filter.isNotEmpty)) {
      List<dynamic> tmpList = List<dynamic>();
      for (int i = 0; i < filterlist.length; i++) {
        if (filterlist[i]['name']
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          tmpList.add(filterlist[i]);
        }
      }
      filterlist = tmpList;
    }

    //
    /*------------------ scaffold ----------------*/
    return Scaffold(
      appBar: AppBar(
        //shape: Palette.seachBoxCardShape,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: appBarTitle,
        brightness: Brightness.dark,
        actions: [
          //search icon....
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close, color: Colors.white);
                  this.appBarTitle = TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search Locality...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                    cursorColor: Colors.white,
                  );
                } else {
                  this.actionIcon = Icon(Icons.search, color: Colors.white);
                  this.appBarTitle =
                      Text("Select Locality", style: Palette.whiteTitle2);
                  filterlist = data;
                  controller.clear();
                }
              });
            },
          ),

          //select city state icon
          IconButton(
            icon: Icon(Icons.done, color: Colors.white),
            onPressed: () {
              _withoutSelectLocalitynavigation();
            },
          ),
        ],
      ),

      //
      /*------------------ body ----------------*/
      //
      body: ListView(
        children: [
          _topContainer(),
          isLoading == false
              ? filterlist.length != 0
                  ? _getLocalityList()
                  : Container(
                      margin:
                          EdgeInsets.only(top: 100.0, right: 20.0, left: 20.0),
                      child: Center(
                          child: Text('No Locality are Available..!',
                              style: Palette.header)),
                    )
              : Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.my_location, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Expanded(
              child: Card(
                elevation: 0.0,
                color: Colors.white24,
                shape: Palette.cardShape,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Text('${widget.stateName}',
                        style: Palette.whiteTitle2)),
              ),
            ),
            Text('>', style: Palette.whiteTitle2),
            Expanded(
                child: Card(
              elevation: 0.0,
              color: Colors.white24,
              shape: Palette.cardShape,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child:
                      Text('${widget.cityName}', style: Palette.whiteTitle2)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _getLocalityList() {
    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: data == null ? 0 : filterlist.length,
      itemBuilder: (context, index) {
        String localCode = filterlist[index]['id'];
        String localName = filterlist[index]['name'];

        return ListTile(
          onTap: () {
            setState(() {
              var localityCode = localCode;
              var localityName = localName;
              _localitySelectNavigation(localityCode, localityName);
            });
          },
          title: Text(
            '$localName',
            style: Palette.title2,
          ),
        );
      },
    );
  }

  Future<void> fetchLocality() async {
    final String url =
        "${Constants.SELECT_LOCALITY}&city_code=${widget.cityId}";



    http.Response response = await http.post(url);

    //object response
    //Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      data = json.decode(response.body);
      filterlist = data;
      isLoading = false;
    });
  }

  void _localitySelectNavigation(String localityCode, String localityName) {
    Navigator.push(
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
          stateId: widget.stateId,
          stateName: widget.stateName,
          cityId: widget.cityId,
          cityName: widget.cityName,
          localityId: localityCode,
          localityName: localityName,
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void _withoutSelectLocalitynavigation() {
    Navigator.push(
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
          stateId: widget.stateId,
          stateName: widget.stateName,
          cityId: widget.cityId,
          cityName: widget.cityName,
          localityId: '',
          localityName: '',
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
