import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan {
  final String id;
  final String kategoriLaporan;
  final String judulLaporan;
  final String keteranganLaporan;
  final GeoPoint lokasiKejadian; // Change to GeoPoint
  final String foto;
  final DateTime timeStamp;
  final String status;
  final bool anonymus;
  final String uid;
  final List<Map<String, dynamic>> statusHistory;

  Laporan({
    required this.id,
    required this.kategoriLaporan,
    required this.judulLaporan,
    required this.keteranganLaporan,
    required this.lokasiKejadian, // Change to GeoPoint
    required this.foto,
    required this.timeStamp,
    required this.status,
    required this.anonymus,
    required this.uid,
    required this.statusHistory,
  });

  // Add the fromFirestore method
  factory Laporan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Laporan(
      id: doc.id,
      kategoriLaporan: data['kategoriLaporan'] ?? '',
      judulLaporan: data['judulLaporan'] ?? '',
      keteranganLaporan: data['keteranganLaporan'] ?? '',
      lokasiKejadian: data['lokasiKejadian'] as GeoPoint,
      foto: data['foto'] ?? '',
      timeStamp: (data['timeStamp'] as Timestamp).toDate(),
      status: data['status'] ?? '',
      anonymus: data['anonymus'] ?? false,
      statusHistory: List<Map<String, dynamic>>.from(
        data['statusHistory'] ?? [],
      ),
      uid: data['uid'] ?? '',
    );
  }

  static const List<String> kategoriLaporanOptions = [
    'Layanan Sosial',
    'Pelayanan Umum',
    'Keamanan dan Ketertiban',
    'Infrastruktur',
  ];

  static const List<String> statusOptions = [
    'Menunggu',
    'Sedang Diproses',
    'Selesai',
  ];
}
