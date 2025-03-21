import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_signout.dart'; // Import PopUpSignOutScreen
import 'package:tes_gradle/features/presentation/screens/profile/ganti_password.dart'; // Import GantiPasswordScreen
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_ulasan.dart'; // Import PopUpUlasanScreen
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_alamat.dart'; // Import PopUpAlamatScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFD), // Set the background color
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
            'Profil',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userProvider.userData;

          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(height: 60, color: Color(0xFFF7FAFD)),
                    const SizedBox(height: 50),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50), // Space for the avatar
                            Center(
                              child: Text(
                                user?['name'] ?? 'User Name',
                                style: AppTextStyles.heading_3_bold.copyWith(
                                  color: AppColors.c2a6892,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Alamat Email',
                              style: AppTextStyles.paragraph_14_bold.copyWith(
                                color: AppColors.c2a6892,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?['email'] ?? 'xxxxxx@gmail.com',
                              style: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: AppColors.c3585ba),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'NIK',
                              style: AppTextStyles.paragraph_14_bold.copyWith(
                                color: AppColors.c2a6892,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?['nik'] ?? '1234567890',
                              style: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: AppColors.c3585ba),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Alamat',
                              style: AppTextStyles.paragraph_14_bold.copyWith(
                                color: AppColors.c2a6892,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?['address'] ?? '-',
                              style: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: AppColors.c3585ba),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to edit profile screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.c2a6892,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0,
                                  ), // Add padding to increase button width
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ), // Set text color to white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: AppColors.white,
                      child: Column(
                        children: [
                          _buildProfileOption(
                            context,
                            icon: Icons.lock,
                            title: 'Ubah Kata Sandi',
                            subtitle: 'Ubah kata sandi Anda.',
                            onTap: () {
                              context.push(AppRoutes.gantiPassword);
                            },
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.rate_review,
                            title: 'Ulasan',
                            subtitle: 'Tinggalkan ulasan Anda!',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const PopUpUlasanScreen();
                                },
                              );
                            },
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.description,
                            title: 'Syarat dan Ketentuan',
                            subtitle: 'Lihat ketentuan layanan kami.',
                            onTap: () {
                              print('Navigating to KetentuanKebijakanScreen');
                              context.push(AppRoutes.ketentuanKebijakan);
                            },
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.logout,
                            title: 'Keluar',
                            subtitle: 'Keluar dari akun dengan aman.',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PopUpSignOutScreen(
                                    title: 'Anda yakin ingin keluar?',
                                    buttonTextYes: 'Ya',
                                    buttonTextNo: 'Tidak',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        user?['photoProfile'] != null
                            ? NetworkImage(user!['photoProfile'])
                            : const AssetImage(
                                  'assets/images/profile_default.jpg',
                                )
                                as ImageProvider,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.c2a6892),
      title: Text(
        title,
        style: AppTextStyles.heading_4_bold.copyWith(color: AppColors.c2a6892),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.paragraph_14_regular.copyWith(
          color: AppColors.c3585ba,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    context.go(AppRoutes.auth);
  }
}
