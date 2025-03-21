import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart'; // Import LaporProvider
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/presentation/provider/berita_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  get userData => null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Calling fetchUserData'); // Debug print statement
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
      _fetchUserReports(); // Fetch user reports
      Provider.of<BeritaProvider>(context, listen: false).fetchBerita();
    });
  }

  Future<void> _fetchUserReports() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
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
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        body: const Center(child: Text("No user is currently logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the Scaffold
      body: Consumer3<UserProvider, LaporProvider, BeritaProvider>(
        builder: (context, userProvider, laporProvider, beritaProvider, child) {
          if (userProvider.isLoading ||
              laporProvider.isLoading ||
              beritaProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = userProvider.userData;
          final userReports = laporProvider.userReports ?? [];
          final beritaList = beritaProvider.beritaList ?? [];
          print('User Data: $userData');
          print('photoProfile: ${userData?['photoProfile']}');
          print('Berita List: ${beritaProvider.beritaList}');
          print('Is Loading: ${beritaProvider.isLoading}');
          print('Error Message: ${beritaProvider.errorMessage}');

          return SingleChildScrollView(
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
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        80.0,
                        16.0,
                        16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              Container(
                                width: double.infinity,
                                height: 42, // Set the height to 42
                                padding: const EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Color(0xFFA4CAE4),
                                    ),
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Cari Layanan',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Color(0xFFBCBCBC),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'Layanan Publik',
                            style: AppTextStyles.paragraph_18_medium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildServiceCard(
                                'assets/images/megaphone-logo.png',
                                'LaporRek',
                                AppColors.white,
                                onTap: () {
                                  context.go(AppRoutes.laporekBar);
                                },
                              ),
                              SizedBox(width: 3),
                              _buildServiceCard(
                                Icons.sos,
                                'Panggilan Darurat',
                                Colors.red,
                                backgroundColor: AppColors.white,
                                onTap: () {
                                  context.go(AppRoutes.panggilanOption);
                                },
                              ),
                              SizedBox(width: 3),
                              _buildServiceCard(
                                'assets/images/cctv-logo.png',
                                'Pantau Malang',
                                AppColors.white,
                                onTap: () {
                                  context.go(AppRoutes.pantauMalang);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Berita Terkini',
                            style: AppTextStyles.heading_3_bold,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 150,
                            child: Builder(
                              builder: (context) {
                                if (beritaProvider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (beritaProvider.errorMessage != null) {
                                  return Center(
                                    child: Text(
                                      beritaProvider.errorMessage!,
                                      style: AppTextStyles.paragraph_14_regular
                                          .copyWith(color: Colors.red),
                                    ),
                                  );
                                }
                                final beritaList =
                                    beritaProvider.beritaList ?? [];
                                print(
                                  'Berita List Length: ${beritaList.length}',
                                ); // Debug log
                                if (beritaList.isEmpty) {
                                  print('No berita available'); // Debug log
                                  return Center(
                                    child: Text(
                                      'Tidak ada berita terbaru',
                                      style: AppTextStyles.paragraph_18_regular,
                                    ),
                                  );
                                }
                                return PageView.builder(
                                  itemCount:
                                      beritaList.length > 5
                                          ? 5
                                          : beritaList.length,
                                  itemBuilder: (context, index) {
                                    final berita = beritaList[index];
                                    print(
                                      'Rendering berita: ${berita.judul}',
                                    ); // Debug log
                                    return GestureDetector(
                                      onTap: () {
                                        print(
                                          'Navigating to detail for: ${berita.judul}',
                                        ); // Debug log
                                        context.push(
                                          AppRoutes.detailBerita,
                                          extra: berita,
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(berita.gambar),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                        bottomRight: Radius.circular(18.0),
                      ), // Set the border radius
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ListTile(
                              leading:
                                  userData?['photoProfile'] != null
                                      ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          userData!['photoProfile'],
                                        ),
                                        onBackgroundImageError: (
                                          exception,
                                          stackTrace,
                                        ) {
                                          // Handle image loading error
                                          print(
                                            'Error loading image: $exception',
                                          );
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
                                'Hai, ${userData?['name'] ?? 'Warga'}',
                                style: AppTextStyles.paragraph_14_regular
                                    .copyWith(color: AppColors.white),
                              ),
                              subtitle: Text(
                                'Warga',
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
                                  color:
                                      AppColors
                                          .c559dce, // Background color for trailing
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
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.report, color: AppColors.white),
                            title: Text(
                              'Banyak Laporanmu : ${userReports.length}',
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(
    dynamic icon,
    String label,
    Color color, {
    Color backgroundColor = AppColors.c2a6892,
    VoidCallback? onTap,
  }) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 115,
          height: 124,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon is IconData
                  ? Icon(icon, size: 40, color: color)
                  : Image.asset(icon, width: 40, height: 40),
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
