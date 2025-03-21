import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tes_gradle/features/domain/entities/cctv.dart';

class CCTVModel extends CCTV {
  CCTVModel({
    required MarkerId markerId,
    required LatLng position,
    required InfoWindow infoWindow,
    required String linkCCTV,
  }) : super(
         markerId: markerId,
         position: position,
         infoWindow: infoWindow,
         linkCCTV: linkCCTV,
       );

  factory CCTVModel.fromJson(Map<String, dynamic> json, String id) {
    return CCTVModel(
      markerId: MarkerId(id),
      position: LatLng(
        (json['position'] as GeoPoint).latitude,
        (json['position'] as GeoPoint).longitude,
      ),
      infoWindow: InfoWindow(title: json['title']),
      linkCCTV: json['linkCCTV'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': GeoPoint(position.latitude, position.longitude),
      'title': infoWindow.title,
      'linkCCTV': linkCCTV,
    };
  }
}
