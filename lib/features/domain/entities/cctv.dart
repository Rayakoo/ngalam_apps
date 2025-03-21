import 'package:google_maps_flutter/google_maps_flutter.dart';

class CCTV {
  final MarkerId markerId;
  final LatLng position;
  final InfoWindow infoWindow;
  final String linkCCTV;

  CCTV({
    required this.markerId,
    required this.position,
    required this.infoWindow,
    required this.linkCCTV,
  });
}
