import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';

class LaporanAdminScreen extends StatefulWidget {
  const LaporanAdminScreen({super.key});

  @override
  _LaporanAdminScreenState createState() => _LaporanAdminScreenState();
}

class _LaporanAdminScreenState extends State<LaporanAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporProvider>(context, listen: false).fetchAllLaporan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Laporan'),
        backgroundColor: AppColors.c2a6892,
      ),
      body: Consumer<LaporProvider>(
        builder: (context, laporProvider, child) {
          if (laporProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final laporanList = laporProvider.laporanList ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporan = laporanList[index];
              return GestureDetector(
                onTap: () {
                  context.go(AppRoutes.detailLaporanAdmin, extra: laporan);
                },
                child: _buildLaporanCard(laporan),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLaporanCard(Laporan laporan) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  laporan.kategoriLaporan,
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
                _buildStatusChip(laporan.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    laporan.judulLaporan,
                    style: AppTextStyles.heading_3_bold.copyWith(
                      color: AppColors.c2a6892,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.network(
                  laporan.foto,
                  height: 100,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              laporan.lokasiKejadian,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(laporan.timeStamp),
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.c3585ba,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.favorite_border, color: Colors.grey),
                    const SizedBox(width: 8),
                    Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 8),
                    Icon(Icons.share, color: Colors.grey),
                  ],
                ),
              ],
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
}
