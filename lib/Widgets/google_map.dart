import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  List<LatLng> nearbyCenterLocations = [];
  List<String> nearbyCenterNames = [];
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(0.3671650790253222, 32.614728209398585),
    zoom: 12.0,
  );

  LatLng? get centerLocation => null;

  Set<Polyline> _polylines = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getNearbyCenters();
  }

  void _getNearbyCenters() async {
    QuerySnapshot centerSnapshot = await FirebaseFirestore.instance
        .collection('Centers') // Replace with your collection name
        .get();

    final centers = centerSnapshot.docs;

    for (var center in centers) {
      final name =
          center['centerName']; // Replace with the field name in your document
      final latitude =
          center['latitude']; // Replace with the field name in your document
      final longitude =
          center['longitude']; // Replace with the field name in your document

      final LatLng centerLocation = LatLng(latitude, longitude);

      nearbyCenterNames.add(name);
      nearbyCenterLocations.add(centerLocation);

      final marker = Marker(
        markerId: MarkerId(name),
        position: centerLocation,
        infoWindow: InfoWindow(title: name),
      );
      _markers.add(marker);
    }

    // After adding markers, update the state to rebuild the widget
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _getUserLocation();
  }

void _drawPolyline(LatLng? destination) async {
  final userPosition = await _controller.getLatLng(
    ScreenCoordinate(
      x: MediaQuery.of(context).size.width ~/ 2,
      y: MediaQuery.of(context).size.height ~/ 2,
    ),
  );

  if (userPosition != null && destination != null) {
    PolylinePoints polylinePoints = PolylinePoints();
    String apiKey = 'AIzaSyAmMCXi6bLvGeo84046fMppv4SNV5pDft8'; // Replace with your Google Maps API key
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(userPosition.latitude, userPosition.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();

      final polyline = Polyline(
        polylineId: PolylineId('route'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      );

      setState(() {
        _polylines = {polyline};
      });

      _controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: userPosition,
            northeast: destination,
          ),
          100, // padding value
        ),
      );
    }
  }
}



  void _getUserLocation() async {
    final locationPackage.Location loc = locationPackage.Location();
    Position position = Position(
      latitude: 0.0,
      longitude: 0.0,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: DateTime.now(),
    ); // Default position

    // Request location permission
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      // Location permission granted
      try {
        position = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high,
        );
      } catch (e) {
        // Handle any errors while getting the location
        print('Error getting location: $e');
      }
    } else if (permissionStatus.isDenied) {
      // Location permission denied
      print('Location permission denied');
    } else if (permissionStatus.isPermanentlyDenied) {
      // Location permission permanently denied, open app settings
      print('Location permission permanently denied');
      openAppSettings();
    }

    if (position.latitude != 0.0 && position.longitude != 0.0) {
      final LatLng userPosition = LatLng(position.latitude, position.longitude);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userPosition, zoom: 12.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              markers: _markers,
              polylines: _polylines,
            ),
            SlidingUpPanel(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              onPanelSlide: (value) {},
              header: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                    Text('Finding nearby centers'),
                  ],
                ),
              ),
              panel: ListView.builder(
                itemCount: nearbyCenterNames.length,
                itemBuilder: (context, index) {
                  final centerName = nearbyCenterNames[index];
                  return GestureDetector(
                    onTap: () {
                      if (centerLocation != null) {
                        _drawPolyline(centerLocation);
                      }
                    },
                    child: ListTile(
                      title: Text(centerName),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
            )
          ],
        ),
      ),
    );
  }
}
