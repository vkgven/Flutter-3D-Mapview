import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData _startLocation;
  LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
  double zoomVal = 5.0;

  @override
  void initState() {
    super.initState();
    //call below funtion to get current location
    // initPlatformState();
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);
    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();
          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google 3D Mapview "),
        actions: <Widget>[],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
           //call below funtion to get current location Button
          // _currentLocationButton(),
        ],
      ),
    );
  }

  Widget _currentLocationButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0),
          height: 45.0,
          width: 145,
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              'Current Location',
            ),
            onPressed: () {
              initPlatformState();
            },
            color: Color(0xff6200ee),
          ),
        ));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition:
        CameraPosition(target: LatLng(50.4501, 30.5234), zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //call below funtion if you need marker
        markers: {exampleMarker1,exampleMarker2,exampleMarker3,exampleMarker4},
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    //3D building view
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 45.0,
        target: LatLng(lat, long),
        tilt: 50.0,
        zoom: 50.0,
      ),
    ));
    //2D building view
    /* controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 20,tilt: 50.0,
      bearing: 45.0,)));*/
  }
}

Marker exampleMarker1 = Marker(
  markerId: MarkerId('markerId'),
  position: LatLng(50.4501, 30.5234),
  infoWindow: InfoWindow(
    title: 'Marker Title',
    snippet: 'Detail',
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker exampleMarker2 = Marker(
  markerId: MarkerId('markerId1'),
  position: LatLng(50.4511, 30.5244),
  infoWindow: InfoWindow(
    title: 'Marker Title',
    snippet: 'Detail',
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker exampleMarker3 = Marker(
  markerId: MarkerId('markerId3'),
  position: LatLng(50.45101, 30.52334),
  infoWindow: InfoWindow(
    title: 'Marker Title',
    snippet: 'Detail',
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker exampleMarker4 = Marker(
  markerId: MarkerId('markerId4'),
  position: LatLng(50.42511, 30.53244),
  infoWindow: InfoWindow(
    title: 'Marker Title',
    snippet: 'Detail',
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

