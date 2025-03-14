import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

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
      print('Calling fetchUserData'); // Debug print statement
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile Page")),
        body: const Center(child: Text("No user is currently logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the Scaffold
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = userProvider.userData;
          print('User Data: $userData'); // Debug print statement
          print(
            'photoProfile: ${userData?['photoProfile']}',
          ); // Debug print statement

          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Replace AppBar with Container
                    Container(
                      height: 140, // Adjust the height as needed
                      color: AppColors.cce1f0,
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        80.0,
                        16.0,
                        16.0,
                      ), // Adjust top padding to account for the positioned Card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Remove the duplicate Card here
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
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
                          const SizedBox(height: 16),
                          Text(
                            'Layanan Publik',
                            style: AppTextStyles.paragraph_14_medium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildServiceCard(
                                Icons.report,
                                'LaporRek',
                                AppColors.white,
                              ),
                              // Modify the background color for 'Panggilan Darurat'
                              _buildServiceCard(
                                Icons.sos,
                                'Panggilan Darurat',
                                Colors.red,
                                backgroundColor: AppColors.white,
                              ),
                              _buildServiceCard(
                                Icons.camera_alt,
                                'Pantau  Malang',
                                AppColors.white,
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
                            color: AppColors.cce1f0,
                            child: Center(
                              child: Text(
                                'Berita Terkini Placeholder',
                                style: AppTextStyles.paragraph_18_regular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Adjust the position of the Card
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
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.white,
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
                              'Banyak Laporanmu 2',
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
    IconData icon,
    String label,
    Color color, {
    Color backgroundColor = AppColors.c2a6892,
  }) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: 100,
          height: 100,
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
