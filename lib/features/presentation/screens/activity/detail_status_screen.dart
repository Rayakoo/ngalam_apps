import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class DetailStatusScreen extends StatelessWidget {
  final Laporan laporan;

  const DetailStatusScreen({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Laporan'),
        backgroundColor: AppColors.cce1f0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              laporan.judulLaporan,
              style: AppTextStyles.heading_3_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              laporan.keteranganLaporan,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Riwayat Status',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusHistory(laporan.statusHistory),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHistory(List<Map<String, dynamic>> statusHistory) {
    return Column(
      children:
          statusHistory.map((statusEntry) {
            return _buildStatusCard(
              statusEntry['status'],
              (statusEntry['date'] as Timestamp).toDate(),
              statusEntry['imageUrl'],
              statusEntry['description'],
            );
          }).toList(),
    );
  }

  Widget _buildStatusCard(
    String status,
    DateTime date,
    String imageUrl,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusChip(status),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMMM yyyy').format(date),
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.c3585ba,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image');
                  },
                )
                : Container(),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
          ],
        ),
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
}
