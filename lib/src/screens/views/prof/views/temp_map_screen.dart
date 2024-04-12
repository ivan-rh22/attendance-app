import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfMap extends StatefulWidget {
  const ProfMap({super.key});

  @override
  State<ProfMap> createState() => _ProfMapState();
}

class _ProfMapState extends State<ProfMap> {
  late GoogleMapController mapController;
  Set<Circle> circles = {};
  TextEditingController txtcontroller = TextEditingController();
  double _radius = 20;
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
          radius: _radius,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap( mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.3046, -98.1729),
              zoom: 6,
            ),
            circles: circles,
            onTap: (LatLng point) {
              _moveToLocation(point);
              _addCircle(point, 20, false);
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
                            hintText: 'Geofence Radius',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          double.parse(txtcontroller.text.toString()) < _radius ? smallercheck = true : smallercheck = false;
                          _radius = double.parse(txtcontroller.text.toString());
                          _addCircle(pointsave!, _radius, smallercheck);
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
  @override
  void dispose() {
    txtcontroller.dispose();
    super.dispose();
  }
}