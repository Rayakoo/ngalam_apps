import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/data/models/cctv_model.dart';
import 'package:tes_gradle/features/presentation/provider/cctv_provider.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this import is present

class PantauMalangScreen extends StatefulWidget {
  const PantauMalangScreen({super.key});

  @override
  State<PantauMalangScreen> createState() => _PantauMalangScreenState();
}

class _PantauMalangScreenState extends State<PantauMalangScreen> {
  late GoogleMapController _mapController;
  LatLng? _userLocation;
  Set<Marker> _markers = {};
  Circle? _userCircle;

  // Define a fallback center location
  final LatLng _center = const LatLng(-7.983908, 112.621391); // Malang center

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserLocation();
      _fetchCCTVs();
      _trackUserLocation();
    });
  }

  Future<void> _initializeUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _userLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _userCircle = Circle(
        circleId: const CircleId('user_circle'),
        center: _userLocation!,
        radius: 50, // 50 meters radius
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });

    // Center the map on the user's location
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_userLocation!, 16.0),
    );
  }

  Future<void> _fetchCCTVs() async {
    final cctvProvider = Provider.of<CCTVProvider>(context, listen: false);
    await cctvProvider.fetchAllCCTVs();
    setState(() {
      _markers.addAll(
        cctvProvider.cctvList?.map((cctv) {
              return Marker(
                markerId: cctv.markerId,
                position: cctv.position,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              );
            }).toSet() ??
            {},
      );
    });
  }

  Future<void> _trackUserLocation() async {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);

        // Update the user's marker
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'user_location',
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: _userLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );

        // Update the user's circle
        _userCircle = Circle(
          circleId: const CircleId('user_circle'),
          center: _userLocation!,
          radius: 50, // 50 meters radius
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
      });
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  void _launchURL(String url) async {
    print('Launching URL: $url'); // Debug statement
    final Uri uri = Uri.parse(url);
    await launchUrl(uri);
    print('URL launched successfully'); // Debug statement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/top bar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            'Pantau Malang',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(AppRoutes.navbar);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              if (_userLocation != null) {
                _mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    _userLocation!,
                    14.0,
                  ), // Center on user location
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target:
                  _userLocation ??
                  _center, // Use user location if available, fallback to _center
              zoom: 14.0,
            ),
            markers: _markers,
            circles: _userCircle != null ? {_userCircle!} : {},
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Nama Tempat CCTV',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              child: Consumer<CCTVProvider>(
                builder: (context, cctvProvider, child) {
                  final cctvList = cctvProvider.cctvList ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cctvList.length,
                    itemBuilder: (context, index) {
                      final cctv = cctvList[index];
                      return FutureBuilder<List<Placemark>>(
                        future: placemarkFromCoordinates(
                          cctv.position.latitude,
                          cctv.position.longitude,
                        ),
                        builder: (context, snapshot) {
                          String locationName = 'Loading location...';
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            locationName =
                                snapshot.data!.first.name ?? 'Unknown location';
                          }

                          double? distance;
                          if (_userLocation != null) {
                            distance = _calculateDistance(
                              _userLocation!,
                              cctv.position,
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              _mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(cctv.position, 16.0),
                              );
                              _launchURL(cctv.linkCCTV); // Launch the CCTV link
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              elevation: 8,
                              child: Container(
                                width: 250,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/cctv-logo.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cctv.infoWindow.title ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            locationName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (distance != null)
                                            Text(
                                              'Jarak: ${(distance / 1000).toStringAsFixed(2)} km', // Convert meters to kilometers
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
