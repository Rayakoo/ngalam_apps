import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart'
    as domain;
import 'package:tes_gradle/features/presentation/provider/notification_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get the current user

class DetailLaporanScreen extends StatefulWidget {
  final Laporan laporan;

  const DetailLaporanScreen({super.key, required this.laporan});

  @override
  _DetailLaporanScreenState createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  final TextEditingController _komentarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporProvider>(
        context,
        listen: false,
      ).fetchKomentarByLaporanId(widget.laporan.id); // Use the id field
    });
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  Future<void> _addKomentar() async {
    final laporProvider = Provider.of<LaporProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    final komentar = Komentar(
      namaPengirim: '', // This will be set automatically
      fotoProfilPengirim: '', // Add appropriate value if needed
      pesan: _komentarController.text,
      timeStamp: DateTime.now(),
      laporanId: widget.laporan.id, // Use the id field
    );

    print('Adding komentar: $komentar'); // Debug log
    await laporProvider.addKomentar(komentar);
    print('Komentar added successfully'); // Debug log

    final currentUser = FirebaseAuth.instance.currentUser;
    // Check if the commenter is not the owner of the report
    if (widget.laporan.uid != currentUser?.uid) {
      String userName = 'Pengguna';
      if (currentUser != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();
        userName = userDoc.data()?['name'] ?? 'Pengguna';
      }

      final notification = domain.Notification(
        id: '',
        judul: '$userName telah berkomentar',
        kategori: 'Komentar',
        waktu: DateTime.now(),
        deskripsi: komentar.pesan,
        userId: widget.laporan.uid,
      );

      print('Notification Details:');
      print('ID: ${notification.id}');
      print('Judul: ${notification.judul}');
      print('Kategori: ${notification.kategori}');
      print('Waktu: ${notification.waktu}');
      print('Deskripsi: ${notification.deskripsi}');
      print('User ID: ${notification.userId}');

      await notificationProvider.addNotification(notification);
      print('Notification added successfully'); // Debug log
    }

    _komentarController.clear();
    await laporProvider.fetchKomentarByLaporanId(widget.laporan.id);
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
            'LaporRek',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.laporan.judulLaporan,
              style: AppTextStyles.heading_3_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.laporan.kategoriLaporan,
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                _buildStatusChip(widget.laporan.status),
              ],
            ),
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
    Color textColor = Colors.white;
    Color backgroundColor;
    switch (status) {
      case 'Menunggu':
        backgroundColor = Colors.blue;
        break;
      case 'Sedang Diproses':
        backgroundColor = Colors.orange;
        break;
      case 'Selesai':
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        status == 'Sedang Diproses' ? 'Sedang Diproses' : status,
        style: AppTextStyles.paragraph_14_regular.copyWith(color: textColor),
        textAlign:
            status == 'Sedang Diproses' ? TextAlign.center : TextAlign.left,
      ),
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
              'Status updated',
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
              'Diskusi',
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
      color: AppColors.cce1f0,
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

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  String _formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }
}
