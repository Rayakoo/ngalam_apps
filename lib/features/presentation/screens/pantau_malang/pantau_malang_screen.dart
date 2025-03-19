import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/data/models/cctv_model.dart';
import 'package:tes_gradle/features/presentation/provider/cctv_provider.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this import is present

class PantauMalangScreen extends StatefulWidget {
  const PantauMalangScreen({super.key});

  @override
  State<PantauMalangScreen> createState() => _PantauMalangScreenState();
}

class _PantauMalangScreenState extends State<PantauMalangScreen> {
  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(-7.983908, 112.621391);

  String? _selectedTitle;
  String? _selectedDescription;
  String? _selectedLinkCCTV;
  LatLng? _selectedPosition;
  String? _locationName;

  Set<Marker> _markers = {};

  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

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
              infoWindow: cctv.infoWindow,
              onTap: () {
                _onMarkerTapped(
                  cctv.infoWindow.title ?? '',
                  'Description for ${cctv.infoWindow.title}',
                  cctv.linkCCTV,
                );
              },
            );
          }).toSet() ??
          {};
    });
  }

  void _onMarkerTapped(String title, String description, String linkCCTV) {
    setState(() {
      _selectedTitle = title;
      _selectedDescription = description;
      _selectedLinkCCTV = linkCCTV;
    });
  }

  Future<void> _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _selectedTitle = null;
      _selectedDescription = null;
      _selectedLinkCCTV = null;
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
          infoWindow: newCCTV.infoWindow,
          onTap: () {
            _onMarkerTapped(
              newCCTV.infoWindow.title ?? '',
              'Description for ${newCCTV.infoWindow.title} at $locationName',
              newCCTV.linkCCTV,
            );
          },
        ),
      );
      _selectedPosition = null; // Clear the selected position after adding
      _locationName = null; // Clear the location name after adding
      titleController.clear(); // Clear the title controller
      linkController.clear(); // Clear the link controller
    });
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
      appBar: AppBar(
        title: const Text('Pantau Malang'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.homepage); // Navigate to a valid route
          },
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
          if (_selectedTitle != null && _selectedDescription != null)
            Positioned(
              bottom: 20,
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
                      Text(
                        _selectedTitle!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedDescription!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedLinkCCTV != null)
                        Text(
                          'Link CCTV: $_selectedLinkCCTV',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedTitle = null;
                              _selectedDescription = null;
                              _selectedLinkCCTV = null;
                            });
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
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
                      return GestureDetector(
                        onTap: () {
                          _launchURL(cctv.linkCCTV);
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cctv.infoWindow.title ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Link: ${cctv.linkCCTV}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
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
