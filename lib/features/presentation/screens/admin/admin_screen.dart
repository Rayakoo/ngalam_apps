import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/detail_laporan_screen.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart'; // Import for pie chart

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.go(AppRoutes.auth);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch admin-specific data if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = {
      'name': 'Admin',
      'photoProfile': null, // Replace with actual admin data if available
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Appbar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SizedBox(height: 40),
                      Text(
                        'Admin Tools',
                        style: AppTextStyles.paragraph_18_medium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildServiceCard(
                            Icons.article,
                            'Tambah Berita',
                            AppColors.white,
                            onTap: () {
                              context.go(AppRoutes.beritaAdmin);
                            },
                          ),
                          SizedBox(width: 3),
                          _buildServiceCard(
                            Icons.update,
                            'Update Laporan',
                            AppColors.white,
                            onTap: () {
                              context.go(AppRoutes.laporanAdmin);
                            },
                          ),
                          SizedBox(width: 3),
                          _buildServiceCard(
                            Icons.add_a_photo,
                            'Tambah CCTV',
                            AppColors.white,
                            onTap: () {
                              context.go(AppRoutes.adminPantauMalang);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Data Laporan', style: AppTextStyles.heading_3_bold),
                      const SizedBox(height: 8),
                      Consumer<LaporProvider>(
                        builder: (context, laporProvider, child) {
                          final laporanList = laporProvider.laporanList ?? [];
                          final totalLaporan = laporanList.length;

                          final menunggu =
                              laporanList
                                  .where(
                                    (laporan) => laporan.status == 'Menunggu',
                                  )
                                  .length;
                          final diproses =
                              laporanList
                                  .where(
                                    (laporan) =>
                                        laporan.status == 'Sedang Diproses',
                                  )
                                  .length;
                          final selesai =
                              laporanList
                                  .where(
                                    (laporan) => laporan.status == 'Selesai',
                                  )
                                  .length;

                          final menungguPercentage =
                              totalLaporan > 0 ? (menunggu / totalLaporan) : 0;
                          final diprosesPercentage =
                              totalLaporan > 0 ? (diproses / totalLaporan) : 0;
                          final selesaiPercentage =
                              totalLaporan > 0 ? (selesai / totalLaporan) : 0;

                          return Row(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: menungguPercentage * 100,
                                          color: Colors.blue,
                                          title:
                                              '${(menungguPercentage * 100).toStringAsFixed(0)}%',
                                          titleStyle: AppTextStyles
                                              .paragraph_14_bold
                                              .copyWith(color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: diprosesPercentage * 100,
                                          color: Colors.orange,
                                          title:
                                              '${(diprosesPercentage * 100).toStringAsFixed(0)}%',
                                          titleStyle: AppTextStyles
                                              .paragraph_14_bold
                                              .copyWith(color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: selesaiPercentage * 100,
                                          color: Colors.green,
                                          title:
                                              '${(selesaiPercentage * 100).toStringAsFixed(0)}%',
                                          titleStyle: AppTextStyles
                                              .paragraph_14_bold
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 40,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Laporan',
                                    style: AppTextStyles.paragraph_14_bold,
                                  ),
                                  Text(
                                    '$totalLaporan',
                                    style: AppTextStyles.heading_3_bold,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      Text('Menunggu'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Text('Diproses'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text('Selesai'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 90,
              left: 16,
              right: 16,
              child: Card(
                color: AppColors.c7db4d9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ListTile(
                          leading:
                              userData['photoProfile'] != null
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      userData['photoProfile']!,
                                    ),
                                    onBackgroundImageError: (
                                      exception,
                                      stackTrace,
                                    ) {
                                      print('Error loading image: $exception');
                                    },
                                  )
                                  : CircleAvatar(
                                    backgroundColor: AppColors.white,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.c7db4d9,
                                    ),
                                  ),
                          title: Text(
                            'Hai, ${userData['name'] ?? 'Admin'}',
                            style: AppTextStyles.paragraph_14_regular.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Admin',
                            style: AppTextStyles.heading_4_bold.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 55,
                            decoration: BoxDecoration(
                              color: AppColors.c559dce,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(18.0),
                                bottomLeft: Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.c2a6892,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18.0),
                          bottomRight: Radius.circular(18.0),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.white,
                        ),
                        title: Text(
                          'Selamat Datang di Admin Dashboard',
                          style: AppTextStyles.paragraph_14_bold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      color: AppColors.c2a6892,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 115,
          height: 124,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
