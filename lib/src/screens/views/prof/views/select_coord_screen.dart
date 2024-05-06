import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ProfMap extends StatefulWidget {
  const ProfMap({super.key});

  @override
  State<ProfMap> createState() => _ProfMapState();
}

class _ProfMapState extends State<ProfMap> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>(); 
  final Location locationController = Location();
  LatLng? _currentPosp;
  StreamSubscription<LocationData>? _locationSubscription;
  late GoogleMapController mapController;
  Set<Circle> circles = {};
  TextEditingController txtcontroller = TextEditingController();
  double _radius = 10;
  late LatLng? pointsave;
  bool showcircle = false;
  bool smallercheck = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addCircle(LatLng point, double radius, bool smaller) {
    setState(() {
      showcircle = true;
      pointsave = point;
      if(smaller){circles.clear();}
      circles.add(
        Circle(
          circleId: const CircleId('geofence'),
          center: point,
          radius: radius,
          fillColor: Colors.amber.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.amber,
        ),
      );
    });
  }

  void _moveToLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[ 
        _currentPosp == null ? 
          const Center(child: CircularProgressIndicator()) : 
          GoogleMap( mapType: MapType.hybrid,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosp!,
              zoom: 18,
            ),
            circles: circles,
            onTap: (LatLng point) {
              _moveToLocation(point);
              _addCircle(point,10, false);
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 55.0, 20.0, 20.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[200],
                ),
                child: showcircle ? Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: txtcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Geofence Radius (10-100)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          if(txtcontroller.text.toString().isNotEmpty){
                            double tempRad = double.parse(txtcontroller.text.toString());
                            if(tempRad < 10 || tempRad > 100) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Radius must be between 10 and 100')));
                            } else {
                              tempRad <= _radius ? smallercheck = true : smallercheck = false;
                              _radius = tempRad;
                              _addCircle(pointsave!, _radius, smallercheck);
                            }
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Input')));
                          }
                        });
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ) : const Text('Tap the map to create a geofence!')
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left:0,
            right:0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: showcircle ? Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                    ),
                    child: const Text('Finish', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.pop(context, [pointsave, _radius]);
                    },
                  ),
                ),
              ): const Text(''), 
            ),
          ),

        ],
      ),
    );
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
          _currentPosp = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _camToPos(_currentPosp!);
        });
      }
    });
  }

  Future<void> _camToPos (LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos, 
      zoom: 18,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    txtcontroller.dispose();
    super.dispose();
  }
}