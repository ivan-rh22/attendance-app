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
  final Location _locationController = Location();
  LatLng? _currentPos;
  StreamSubscription<LocationData>? _locationSubscription;

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
          const Center(child: Text("Loading...", textAlign: TextAlign.center,)) : 
          GoogleMap(
            onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
            initialCameraPosition: CameraPosition(
              target: _currentPos!,
              zoom: 18, tilt: 40),
              zoomControlsEnabled: false, 
              zoomGesturesEnabled: false,
            markers: {
              Marker(markerId: MarkerId("currentLocation"), position: _currentPos!)
            }, 
          )
        ),
        Positioned(
          bottom: 20, right: 20,
          width: 130,
          child: ElevatedButton(onPressed: (){}, style: //<============ Clock-in button added
            ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(13, 153, 0, 1),
            ), 
            child: const Text('Clock in', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
        ),
      ]),
    );
  }
  Future<void> _camToPos (LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos, 
      zoom: 18, tilt: 40,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    } else {
      return Future.error("Location services disabled.");
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return Future.error("Location services disabled.");
      }
    }
    await _locationController.enableBackgroundMode(enable: true);
    _locationSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
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
}