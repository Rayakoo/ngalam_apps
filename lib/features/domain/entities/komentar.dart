class Komentar {
  final String namaPengirim;
  final String fotoProfilPengirim;
  final String pesan;
  final DateTime timeStamp;
  final String laporanId; // Add this line

  Komentar({
    required this.namaPengirim,
    required this.fotoProfilPengirim,
    required this.pesan,
    required this.timeStamp,
    required this.laporanId, // Add this line
  });
}
