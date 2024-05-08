import 'dart:async';
import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/screens/views/stud/Utils/geofence_help.dart';
import 'package:attendance_app/src/screens/views/stud/blocs/clock_in_bloc/clock_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ClockInScreen extends StatefulWidget {
  final LatLng coordinates;
  final double radius;
  final String courseId;
  final bool attendanceStatus;
  final LatLng? currentPos;
  const ClockInScreen(
      {super.key,
      required this.coordinates,
      required this.radius,
      required this.courseId,
      required this.attendanceStatus,
      required this.currentPos});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>(); 
  final Location locationController = Location();
  LatLng? _currentPos;
  StreamSubscription<LocationData>? _locationSubscription;
  late Color buttonColor;
  late String buttonText;
  late IconData currentIcon;
  int countdown = 30;
  bool timerStarted = false;
  late bool clocked;
  late bool inside;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        buttonText = '$countdown';
        currentIcon = Icons.timer;
        buttonColor = Colors.red;
      });

      getLocation();

      if(inside){
        timer.cancel();
        countdown = 30;
        timerStarted = false;
        setState(() {
          buttonText = 'Clock out';
        });
      } else {
        if(countdown <= 0){
          timer.cancel();
          clocked = false;
          BlocProvider.of<ClockInBloc>(context).add(ClockOutRequest(courseId: widget.courseId, date: DateTime.now(), userId: context.read<AuthenticationBloc>().state.user!.userId, present: clocked) );
          timerStarted = false;
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
    clocked = widget.attendanceStatus;
    _currentPos = widget.currentPos;
    inside = calcDistance(_currentPos!.latitude, _currentPos!.longitude, widget.coordinates.latitude, widget.coordinates.longitude) <= widget.radius;
    btnLogic();
  }
  

  @override
  Widget build(BuildContext context) {
    getLocation();
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
                    Navigator.of(context).pop();
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
            onPressed: () {
              setState(() {
                if(inside){
                  if(clocked){
                    BlocProvider.of<ClockInBloc>(context).add(ClockOutRequest(courseId: widget.courseId, date: DateTime.now(), userId: context.read<AuthenticationBloc>().state.user!.userId, present: !clocked) );
                  } else {
                    BlocProvider.of<ClockInBloc>(context).add(ClockInRequest(courseId: widget.courseId, date: DateTime.now(), userId: context.read<AuthenticationBloc>().state.user!.userId, present: !clocked));
                  }
                  clocked = !clocked;
                }
                btnLogic();
              });
            },
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
        setState(() {
          inside = distance <= widget.radius;
          btnLogic();
        });
      }
    });
  }

  btnLogic(){
    if(inside && !clocked){
      setState(() {
        buttonColor = Colors.green;
        buttonText = "Clock In";
        currentIcon = Icons.play_arrow;
      });
    }
    else if((inside && clocked)){
      setState((){
        buttonColor = Colors.red;
        buttonText = "Clock Out";
        currentIcon = Icons.pause;
      });
    }
    else if(!inside && !clocked){
      setState(() {
        buttonColor = Colors.blueGrey;
        buttonText = "Move Closer";
        currentIcon = Icons.directions_walk;
      });
    } 
    else if(!inside && clocked){
      if(timerStarted){
        setState(() {
          buttonColor = Colors.red;
          buttonText = '$countdown';
          currentIcon = Icons.timer;
        });
      } else {
        setState(() {
          timerStarted = true;
          startTimer();
          buttonColor = Colors.red;
          buttonText = "Clock Out";
          currentIcon = Icons.pause;
        });
      }
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}