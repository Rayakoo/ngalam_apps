import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/detail_laporan_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchUserReports();
      });
    });
  }

  Future<void> _fetchUserReports() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        print('Fetching user reports for user ID: $userId');
        await Provider.of<LaporProvider>(
          context,
          listen: false,
        ).fetchUserReports(userId);
        print('Fetched user reports successfully.');
      } else {
        print('No user logged in.');
      }
    } catch (e) {
      print('Error fetching user reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: AppColors.cce1f0,
      ),
      body: Consumer<LaporProvider>(
        builder: (context, laporProvider, child) {
          if (laporProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final userReports = laporProvider.userReports ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporanmu (${userReports.length})',
                      style: AppTextStyles.heading_4_bold.copyWith(
                        color: AppColors.c2a6892,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: userReports.length,
                  itemBuilder: (context, index) {
                    final laporan = userReports[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailLaporanScreen(laporan: laporan),
                          ),
                        );
                      },
                      child: _buildLaporanCard(laporan),
                    );
                  },
                ),
              ),
            ],
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  laporan.kategoriLaporan,
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
                const SizedBox(height: 8),
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        laporan.id,
                        style: AppTextStyles.paragraph_10_medium.copyWith(
                          color: AppColors.c2a6892,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(laporan.timeStamp),
                        style: AppTextStyles.paragraph_14_regular.copyWith(
                          color: AppColors.c3585ba,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    laporan.judulLaporan,
                    style: AppTextStyles.heading_3_bold.copyWith(
                      color: AppColors.c2a6892,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.detailStatus, extra: laporan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2a6892,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Lihat Status',
                      style: AppTextStyles.paragraph_14_medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final Duration difference = DateTime.now().difference(date);
    if (difference.inDays > 1) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
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
