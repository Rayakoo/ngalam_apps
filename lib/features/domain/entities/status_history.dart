class StatusHistory {
  final String id;
  final String laporanId;
  final String status;
  final String description;
  final String imageUrl;
  final DateTime timeStamp;

  StatusHistory({
    required this.id,
    required this.laporanId,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.timeStamp,
  });
}
