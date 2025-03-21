import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class DeskripsiStatusScreen extends StatelessWidget {
  final String imageUrl;
  final DateTime date;
  final String description;
  final String status;

  const DeskripsiStatusScreen({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Menunggu':
        statusColor = Colors.blue;
        break;
      case 'Sedang Diproses':
        statusColor = Colors.orange;
        break;
      case 'Selesai':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
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
            'Detail Laporan',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Text('Failed to load image');
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.paragraph_14_regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.c3585ba),
                const SizedBox(width: 8),
                Text(
                  'Tanggal Pemrosesan: ${DateFormat('d MMMM yyyy').format(date)}',
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.c3585ba),
                const SizedBox(width: 8),
                Text(
                  'Waktu Pemrosesan: ${DateFormat('HH:mm').format(date)}',
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Penanganan :',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
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
}
