import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phonepeproperty/style/palette.dart';

class MapLocation extends StatefulWidget {
  double _lat;
  double _lng;

  MapLocation(this._lat, this._lng);

  @override
  State<StatefulWidget> createState() =>
      _MapLocationState(this._lat, this._lng);
}

class _MapLocationState extends State<MapLocation> {
  double _lat;
  double _lng;

  _MapLocationState(this._lat, this._lng);

  String apiKeys = "AIzaSyAy95S4BRjRbliWGB1MjYm8zqdbz5P4yfY";
  TextEditingController controller = TextEditingController();

  //map
  GoogleMapController _gMapController;

  final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  void initState() {
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        /* actions: [
          /* IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacePicker(
                      apiKey: apiKeys, // Put YOUR OWN KEY here.
                      onPlacePicked: (result) {
                        print(result);
                        Navigator.of(context).pop();
                      },
                      initialPosition: kInitialPosition,
                      useCurrentLocation: true,
                    ),
                  ),
                );
              }) */
        ], */
      ),
      /*------------------ body ----------------*/
      body: Center(
        child: _googleMapController(),
      ),
    );
  }

  //GoogleMapView
  Widget _googleMapController() {
    return Container(
      //margin: EdgeInsets.all(15.0),
      //height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _createMarker(),
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat, _lng),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _gMapController = controller;
          });
        },
      ),
    );
  }

  //set google map Location Marker
  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Location"),
        position: LatLng(_lat, _lng),
        icon: BitmapDescriptor.defaultMarker,
      )
    ].toSet();
  }
}
