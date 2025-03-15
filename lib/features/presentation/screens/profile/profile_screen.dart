import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // Add this line
import 'package:tes_gradle/features/presentation/router/approutes.dart'; // Add this line

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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cce1f0,
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
                    Container(height: 60, color: AppColors.white),
                    const SizedBox(height: 50),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
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
                    _buildProfileOption(
                      context,
                      icon: Icons.rate_review,
                      title: 'Ulasan',
                      subtitle: 'Tinggalkan ulasan Anda!',
                      onTap: () {
                        // Navigate to review screen
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.description,
                      title: 'Syarat dan Ketentuan',
                      subtitle: 'Lihat ketentuan layanan kami.',
                      onTap: () {
                        // Navigate to terms and conditions screen
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.logout,
                      title: 'Keluar',
                      subtitle: 'Keluar dari akun dengan aman.',
                      onTap: () {
                        _logout();
                      },
                    ),
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
    context.go(AppRoutes.auth); // Use context.go with the defined route
  }
}
