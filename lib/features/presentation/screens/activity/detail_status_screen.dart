import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
            'Status',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).go('/navbar');
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Status Laporan',
                  style: AppTextStyles.heading_4_bold.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppColors.cce1f0,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${laporan.id}',
                    style: AppTextStyles.paragraph_10_medium.copyWith(
                      color: AppColors.c020608,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatusHistory(laporan.statusHistory, context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHistory(
    List<Map<String, dynamic>> statusHistory,
    BuildContext context,
  ) {
    return Column(
      children:
          statusHistory.reversed.map((statusEntry) {
            return _buildStatusCard(
              statusEntry['status'],
              (statusEntry['date'] as Timestamp).toDate(),
              statusEntry['imageUrl'],
              statusEntry['description'],
              context,
            );
          }).toList(),
    );
  }

  Widget _buildStatusCard(
    String status,
    DateTime date,
    String imageUrl,
    String description,
    BuildContext context,
  ) {
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

    return Card(
      color: AppColors.white,
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
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.0),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMMM yyyy').format(date),
                  style: AppTextStyles.paragraph_18_bold.copyWith(
                    color: AppColors.c3585ba,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 95,
                ), // Add this line to shift the container to the right
                Container(width: 2.0, height: 150.0, color: AppColors.cce1f0),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Change alignment to start
                    children: [
                      imageUrl.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl,
                              height: 96,
                              width: 255,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Failed to load image');
                              },
                            ),
                          )
                          : Container(),
                      const SizedBox(height: 8),
                      Text(
                        description.length > 70
                            ? '${description.substring(0, 70)}...'
                            : description,
                        style: AppTextStyles.paragraph_14_regular.copyWith(
                          color: AppColors.c020608,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                            '/deskripsiStatus',
                            extra: {
                              'imageUrl': imageUrl,
                              'date': date,
                              'description': description,
                              'status': status,
                            },
                          );
                        },
                        child: Text(
                          'Baca Selengkapnya',
                          style: AppTextStyles.paragraph_14_regular.copyWith(
                            color: AppColors.c559dce,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
        status == 'Sedang Diproses' ? 'Sedang\nDiproses' : status,
        style: AppTextStyles.paragraph_14_regular.copyWith(color: textColor),
        textAlign:
            status == 'Sedang Diproses' ? TextAlign.center : TextAlign.left,
      ),
    );
  }
}
