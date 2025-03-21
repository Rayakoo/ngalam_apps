import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/data/models/cctv_model.dart';
import 'package:tes_gradle/features/presentation/provider/cctv_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class AdminPantauMalangScreen extends StatefulWidget {
  const AdminPantauMalangScreen({super.key});

  @override
  State<AdminPantauMalangScreen> createState() =>
      _AdminPantauMalangScreenState();
}

class _AdminPantauMalangScreenState extends State<AdminPantauMalangScreen> {
  late GoogleMapController _mapController;

  // Define a fallback center location
  final LatLng _center = const LatLng(-7.983908, 112.621391); // Malang center

  LatLng? _selectedPosition;
  String? _locationName;

  Set<Marker> _markers = {};

  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index if needed
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCCTVs();
    });
  }

  Future<void> _fetchCCTVs() async {
    final cctvProvider = Provider.of<CCTVProvider>(context, listen: false);
    await cctvProvider.fetchAllCCTVs();
    setState(() {
      _markers =
          cctvProvider.cctvList?.map((cctv) {
            return Marker(
              markerId: cctv.markerId,
              position: cctv.position,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            );
          }).toSet() ??
          {};
    });
  }

  Future<void> _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId('selected_position'),
          position: position,
          infoWindow: InfoWindow(title: 'Selected Position'),
        ),
      );
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      setState(() {
        _locationName = placemarks.first.name ?? 'Unknown location';
      });
    } else {
      setState(() {
        _locationName = 'Unknown location';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addCCTV(String title, String link, String locationName) {
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location on the map first.')),
      );
      return;
    }

    final cctvProvider = Provider.of<CCTVProvider>(context, listen: false);
    final newCCTV = CCTVModel(
      markerId: MarkerId('new_cctv_${_selectedPosition.toString()}'),
      position: _selectedPosition!,
      infoWindow: InfoWindow(title: title, snippet: locationName),
      linkCCTV: link,
    );
    cctvProvider.addCCTV(newCCTV);
    setState(() {
      _markers.add(
        Marker(
          markerId: newCCTV.markerId,
          position: newCCTV.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      _selectedPosition = null;
      _locationName = null;
      titleController.clear();
      linkController.clear();
    });
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
            icon: Icon(Icons.arrow_back, color: AppColors.c020608),
            onPressed: () {
              context.go(AppRoutes.admin);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
            markers: _markers,
            onTap: _onMapTapped,
          ),
          if (_selectedPosition != null)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 150,
              left: 20,
              right: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'CCTV Name'),
                      ),
                      TextField(
                        controller: linkController,
                        decoration: InputDecoration(labelText: 'CCTV Link'),
                      ),
                      SizedBox(height: 8),
                      Text('Location: $_locationName'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _addCCTV(
                              titleController.text,
                              linkController.text,
                              _locationName ?? 'Unknown location',
                            );
                          },
                          child: const Text('Add CCTV'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      
    );
  }
}
