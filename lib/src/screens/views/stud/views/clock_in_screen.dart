import 'dart:async';
import 'package:attendance_app/src/screens/views/stud/Utils/geofence_help.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

bool clocked = false, allowed = false;

class ClockInScreen extends StatefulWidget {
  LatLng coordinates;
  final double radius;
  ClockInScreen({super.key, required this.coordinates, required this.radius});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>(); 
  final Location locationController = Location();
  LatLng? _currentPos;
  StreamSubscription<LocationData>? _locationSubscription;
  Color buttonColor = Colors.green;
  String buttonText = 'Clock in';
  IconData currentIcon = Icons.play_arrow;
  bool timerExpired = false;
  Timer? timer;
  int secondsRemaining = 10;

  void startTimer() {
    const sec = Duration(seconds: 1);
    timer = Timer.periodic(sec, (timed) {
      if(secondsRemaining == 0){
        timed.cancel();
        setState(() {
          btnLogic();
          timerExpired = true;
        });
      } else {
        setState(() {
          buttonText = "$secondsRemaining";
          secondsRemaining--;
        });
      }
    });
  }

  void stopTimer() {
    if(timer != null) {
      timer!.cancel();
      timer = null;
      setState(() {
        secondsRemaining = 10;
      });
    }
  }


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
            myLocationEnabled: true,
            onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)), mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPos!,
              zoom: 18),
              zoomControlsEnabled: false, 
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
          )
        ),
        Positioned(
          bottom: 20, right: 20,
          width: 130,
          child: FloatingActionButton.extended(
            onPressed: btnLogic,
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
        double distance = calcDistance(currentLocation.latitude!, currentLocation.longitude!, widget.coordinates.latitude, widget.coordinates.longitude);
        if(distance <= widget.radius) {
          setState(() {
            allowed = true;
            if(buttonText == "Move Closer"){
              buttonColor = Colors.green;
              buttonText = "Clock In";
              currentIcon = Icons.play_arrow;
            }
          });
        } else {
          setState(() {
            allowed = false;
            if(!clocked){
              buttonColor = Colors.blueGrey;
              buttonText = "Move Closer";
              currentIcon = Icons.directions_walk;
            } else {
              //Here would go the timer logic.
              setState(() {
                startTimer();
              });
            }
          });
        }
      }
    });
  }

  btnLogic(){
    //If allowed and not clocked in this happens when i push
    if(allowed && !clocked){
      setState((){
        clocked = true;
        buttonColor = Colors.red;
        buttonText = "Clock Out";
        currentIcon = Icons.pause;
      });
    }
    //if allowed and clocked in this happens when i push
    else if(allowed && clocked){
      setState((){
        clocked = false;
        buttonColor = Colors.green;
        buttonText = "Clock In";
        currentIcon = Icons.play_arrow;
      });
    }
    //If not allowed but clocked in this happens when i push
    else if(!allowed && clocked) {
      setState((){
        clocked = false;
        buttonColor = Colors.green;
        buttonText = "Clock in";
        currentIcon = Icons.play_arrow;
      });
    }
    //If not allowed and not clocked in I should see a gray button;
    else if(!allowed && !clocked){
      if(timerExpired) {
        setState(() {
          timerExpired = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have been clocked out!'), backgroundColor: Colors.red,));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not within classroom area. Move closer.')));
      }
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    stopTimer();
    super.dispose();
  }
}