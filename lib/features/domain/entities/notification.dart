class Notification {
  final String id;
  final String judul;
  final String kategori;
  final DateTime waktu;
  final String deskripsi;
  final String userId;

  Notification({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.waktu,
    required this.deskripsi,
    required this.userId,
  });

  static const List<String> categories = [
    'Peringatan',
    'Berita',
    'Pemberitahuan',
    'Komentar',
  ];
}
