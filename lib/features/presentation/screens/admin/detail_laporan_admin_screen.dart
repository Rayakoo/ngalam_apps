import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/provider/status_history_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:tes_gradle/features/data/models/laporan_model.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart'
    as domain;
import 'package:tes_gradle/features/presentation/provider/notification_provider.dart';

class DetailLaporanAdminScreen extends StatefulWidget {
  final Laporan laporan;

  const DetailLaporanAdminScreen({super.key, required this.laporan});

  @override
  _DetailLaporanAdminScreenState createState() =>
      _DetailLaporanAdminScreenState();
}

class _DetailLaporanAdminScreenState extends State<DetailLaporanAdminScreen> {
  final TextEditingController _komentarController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedStatus = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporProvider>(
        context,
        listen: false,
      ).fetchKomentarByLaporanId(widget.laporan.id);
    });
  }

  @override
  void dispose() {
    _komentarController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addKomentar() async {
    final laporProvider = Provider.of<LaporProvider>(context, listen: false);
    final komentar = Komentar(
      namaPengirim: '',
      fotoProfilPengirim: '',
      pesan: _komentarController.text,
      timeStamp: DateTime.now(),
      laporanId: widget.laporan.id,
    );
    await laporProvider.addKomentar(komentar);
    _komentarController.clear();
    await laporProvider.fetchKomentarByLaporanId(widget.laporan.id);
  }

  Future<void> _updateStatus() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Deskripsi Update'),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _imageUrl = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedStatus.isEmpty ? null : _selectedStatus,
                  hint: Text('Select Status'),
                  items:
                      Laporan.statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue ?? '';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedStatus.isNotEmpty) {
                  final laporProvider = Provider.of<LaporProvider>(
                    context,
                    listen: false,
                  );
                  final statusHistoryProvider =
                      Provider.of<StatusHistoryProvider>(
                        context,
                        listen: false,
                      );
                  final notificationProvider =
                      Provider.of<NotificationProvider>(context, listen: false);

                  final newStatusHistory = StatusHistory(
                    id: '',
                    laporanId: widget.laporan.id,
                    status: _selectedStatus,
                    description: _descriptionController.text,
                    imageUrl: _imageUrl,
                    timeStamp: DateTime.now(),
                  );

                  // Create the status history entry
                  final createdStatusHistory = await statusHistoryProvider
                      .addStatusHistory(newStatusHistory);

                  // Add the created status history to the laporan
                  final updatedLaporan = LaporanModel(
                    id: widget.laporan.id,
                    kategoriLaporan: widget.laporan.kategoriLaporan,
                    judulLaporan: widget.laporan.judulLaporan,
                    keteranganLaporan: widget.laporan.keteranganLaporan,
                    lokasiKejadian: widget.laporan.lokasiKejadian,
                    foto: widget.laporan.foto,
                    timeStamp: widget.laporan.timeStamp,
                    status: _selectedStatus, // Ensure status is updated
                    anonymus: widget.laporan.anonymus,
                    uid: widget.laporan.uid, // Add this field
                    statusHistory: [
                      ...widget.laporan.statusHistory,
                      {
                        'status': createdStatusHistory.status,
                        'date': createdStatusHistory.timeStamp,
                        'description': createdStatusHistory.description,
                        'imageUrl': createdStatusHistory.imageUrl,
                      },
                    ],
                  );

                  print('Updating laporan with ID: ${widget.laporan.id}');
                  print('Updated status: $_selectedStatus');
                  print(
                    'Updated status history: ${updatedLaporan.statusHistory}',
                  );

                  await laporProvider.updateLaporan(
                    widget.laporan.id,
                    updatedLaporan,
                  );

                  // Create a notification for the user
                  final notification = domain.Notification(
                    id: '',
                    judul: 'Status Laporan Diperbarui',
                    kategori: 'Pemberitahuan',
                    waktu: DateTime.now(),
                    deskripsi:
                        'Status laporan "${widget.laporan.judulLaporan}" telah diperbarui menjadi $_selectedStatus.',
                    userId: widget.laporan.uid, 
                  );

                  await notificationProvider.addNotification(notification);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status updated to $_selectedStatus'),
                    ),
                  );
                  context.go(AppRoutes.laporanAdmin);
                }
              },
              child: Text('Confirm Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan'),
        backgroundColor: AppColors.cce1f0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.laporanAdmin);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.laporan.kategoriLaporan,
              style: AppTextStyles.heading_3_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.laporan.judulLaporan, // Add the report title
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusChip(widget.laporan.status),
            const SizedBox(height: 16),
            Image.network(
              widget.laporan.foto,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text('Failed to load image');
              },
            ),
            const SizedBox(height: 16),
            _buildLaporanInfo(
              'Lokasi Laporan',
              'Lat: ${widget.laporan.lokasiKejadian.latitude}, Lng: ${widget.laporan.lokasiKejadian.longitude}',
            ), 
            _buildLaporanInfo(
              'Tanggal Pelaporan',
              _formatDate(widget.laporan.timeStamp),
            ),
            _buildLaporanInfo(
              'Waktu Pelaporan',
              _formatTime(widget.laporan.timeStamp),
            ),
            const SizedBox(height: 16),
            Text(
              'Permasalahan :',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.laporan.keteranganLaporan,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Riwayat Laporan',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            _buildRiwayatLaporan(),
            const SizedBox(height: 16),
            _buildKomentarSection(),
            const SizedBox(height: 16),
            _buildStatusUpdateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLaporanInfo(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: AppTextStyles.paragraph_14_bold.copyWith(
              color: AppColors.c2a6892,
            ),
          ),
          Expanded(
            child: Text(
              info,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color textColor;
    Color borderColor;
    switch (status) {
      case 'Menunggu':
        textColor = Colors.blue;
        borderColor = Colors.blue;
        break;
      case 'Sedang Diproses':
        textColor = Colors.orange;
        borderColor = Colors.orange;
        break;
      case 'Selesai':
        textColor = Colors.green;
        borderColor = Colors.green;
        break;
      default:
        textColor = Colors.grey;
        borderColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: AppTextStyles.paragraph_14_regular.copyWith(color: textColor),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
    );
  }

  Widget _buildRiwayatLaporan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          widget.laporan.statusHistory.map((statusEntry) {
            return _buildRiwayatItem(
              statusEntry['status'],
              _formatDate((statusEntry['date'] as Timestamp).toDate()),
              statusEntry['description'] ?? 'Status updated',
            );
          }).toList(),
    );
  }

  Widget _buildRiwayatItem(String status, String date, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          _buildStatusChip(status),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppTextStyles.paragraph_14_bold.copyWith(
                  color: AppColors.c2a6892,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: AppColors.c3585ba,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKomentarSection() {
    return Consumer<LaporProvider>(
      builder: (context, laporProvider, child) {
        final komentarList = laporProvider.komentarList ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discussion',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            if (komentarList.isEmpty)
              Text(
                'Belum ada komentar',
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: Colors.grey,
                ),
              )
            else
              Column(
                children:
                    komentarList.take(10).map((komentar) {
                      return _buildKomentarItem(komentar);
                    }).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _komentarController,
                    decoration: InputDecoration(
                      hintText: 'Ketik diskusi',
                      hintStyle: AppTextStyles.paragraph_14_regular.copyWith(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppColors.c2a6892),
                      ),
                      prefixIcon: Icon(Icons.person, color: AppColors.c2a6892),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.c2a6892),
                  onPressed: _addKomentar,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildKomentarItem(Komentar komentar) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppColors.c2a6892),
                const SizedBox(width: 8),
                Text(
                  komentar.namaPengirim,
                  style: AppTextStyles.paragraph_14_bold.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              komentar.pesan,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusUpdateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Status',
          style: AppTextStyles.heading_4_bold.copyWith(
            color: AppColors.c2a6892,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _updateStatus,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.c2a6892,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'Update Status',
            style: AppTextStyles.paragraph_14_medium.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  String _formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }
}
