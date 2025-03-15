class Laporan {
  final String id;
  final String kategoriLaporan;
  final String judulLaporan;
  final String keteranganLaporan;
  final String lokasiKejadian;
  final String foto;
  final DateTime timeStamp;
  final String status;
  final bool anonymus;
  final List<Map<String, dynamic>> statusHistory; // Add this line

  Laporan({
    required this.id,
    required this.kategoriLaporan,
    required this.judulLaporan,
    required this.keteranganLaporan,
    required this.lokasiKejadian,
    required this.foto,
    required this.timeStamp,
    required this.status,
    required this.anonymus,
    required this.statusHistory, // Add this line
  });

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
