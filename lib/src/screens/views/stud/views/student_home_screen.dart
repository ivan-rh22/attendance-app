import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>(); 
  final Location locationController = Location();
  LatLng? _currentPos;
  StreamSubscription<LocationData>? _locationSubscription;
  Color buttonColor = Colors.green;
  String buttonText = 'Clock in';
  IconData currentIcon = Icons.play_arrow;


  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( children: <Widget> [
        Center( 
          child: _currentPos == null ? 
          const Center(child: CircularProgressIndicator()) : 
          GoogleMap(
            onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)), mapType: MapType.satellite,
            initialCameraPosition: CameraPosition(
              target: _currentPos!,
              zoom: 18),
              zoomControlsEnabled: false, 
              zoomGesturesEnabled: false,
            circles: {
              if (_currentPos != null)
                Circle(circleId: const CircleId("userCircle"),
                center: _currentPos!,
                radius: 5,
                strokeColor: Colors.white,
                fillColor: Colors.blue,
                strokeWidth: 3,
                )
            } 
          )
        ),
        Positioned(
          bottom: 20, right: 20,
          width: 130,
          child: FloatingActionButton.extended(
            onPressed: updateButton,
            label: Text(buttonText), 
            icon: Icon(currentIcon), 
            foregroundColor: Colors.white, 
            backgroundColor: buttonColor,),
        ),
      ]),
    );
  }
  Future<void> _camToPos (LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos, 
      zoom: 18,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled){
      serviceEnabled = await locationController.requestService();
    } else {
      return Future.error("Location services disabled.");
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if(permissionGranted != PermissionStatus.granted){
        return Future.error("Location services disabled.");
      }
    }
    await locationController.enableBackgroundMode(enable: true);
    _locationSubscription = locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() {
          _currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _camToPos(_currentPos!);
        });
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void updateButton() {
    setState(() {
      if(buttonColor == Colors.green){
        buttonColor = Colors.red;
        buttonText = 'Clock Out';
        currentIcon = Icons.pause;
      }
      else{
        buttonColor = Colors.green;
        buttonText = 'Clock In';
        currentIcon = Icons.play_arrow;
      }
    });
  }
}