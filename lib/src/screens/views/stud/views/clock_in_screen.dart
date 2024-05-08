import 'dart:async';
import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/screens/views/stud/Utils/geofence_help.dart';
import 'package:attendance_app/src/screens/views/stud/blocs/clock_in_bloc/clock_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

bool clocked = false, inside = false;

class ClockInScreen extends StatefulWidget {
  final LatLng coordinates;
  final double radius;
  final String courseId;
  const ClockInScreen({super.key, required this.coordinates, required this.radius, required this.courseId});

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
  int countdown = 30;
  bool timerStated = false;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        buttonText = '$countdown';
      });

      if(inside){
        timer.cancel();
        countdown = 30;
        timerStated = false;
        setState(() {
          buttonText = 'Clock out';
        });
      } else {
        if(countdown <= 0){
          timer.cancel();
          clocked = false;
          timerStated = false;
          countdown = 30;
        } else {
          countdown--;
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClockInBloc, ClockInState>(
      listener: (context, state) {
        if(state is ClockInSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Marked as present'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is ClockInFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.error),
              actions: <Widget> [
                TextButton(
                  onPressed: () {
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Stack( children: <Widget> [
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
            inside = true;
            if(buttonText == "Move Closer"){
              buttonColor = Colors.green;
              buttonText = "Clock In";
              currentIcon = Icons.play_arrow;
            }
          });
        } else {
          setState(() {
            inside = false;
            if(!clocked){
              buttonColor = Colors.blueGrey;
              buttonText = "Move Closer";
              currentIcon = Icons.directions_walk;
            } else {
              //Here would go the timer logic.
              if(!timerStated){
                timerStated = true;
                startTimer();
              }
            }
          });
        }
      }
    });
  }

  btnLogic(){
    //If inside and not clocked in this happens when i push
    if(inside && !clocked){
      setState((){
        DateTime now = DateTime.now();
        context.read<ClockInBloc>().add(
          ClockInRequest(
            courseId: widget.courseId, 
            date: now, 
            userId: context.read<AuthenticationBloc>().state.user!.userId, 
            present: true)
        );
        clocked = true;
        buttonColor = Colors.red;
        buttonText = "Clock Out";
        currentIcon = Icons.pause;
      });
    }
    //if inside and clocked in this happens when i push or If not inside but clocked in this happens when i push
    else if((inside && clocked) || (!inside && clocked)){
      setState((){
        clocked = false;
        buttonColor = Colors.green;
        buttonText = "Clock In";
        currentIcon = Icons.play_arrow;
      });
    }
    //If not inside and not clocked in I should see a gray button;
    else if(!inside && !clocked){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not within classroom area. Move closer.')));
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}