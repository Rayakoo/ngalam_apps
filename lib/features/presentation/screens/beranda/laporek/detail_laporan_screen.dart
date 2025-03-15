import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

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
    final komentar = Komentar(
      namaPengirim: '', // This will be set automatically
      fotoProfilPengirim: '', // Add appropriate value if needed
      pesan: _komentarController.text,
      timeStamp: DateTime.now(),
      laporanId: widget.laporan.id, // Use the id field
    );
    await laporProvider.addKomentar(komentar);
    _komentarController.clear();
    await laporProvider.fetchKomentarByLaporanId(
      widget.laporan.id,
    ); // Use the id field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan'),
        backgroundColor: AppColors.cce1f0,
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
            _buildLaporanInfo('Lokasi Laporan', widget.laporan.lokasiKejadian),
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

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  String _formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }
}
