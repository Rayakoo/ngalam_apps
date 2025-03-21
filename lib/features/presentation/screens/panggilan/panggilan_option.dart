import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:tes_gradle/features/presentation/screens/panggilan/pop_up_panggilan.dart';

class PanggilanOptionScreen extends StatelessWidget {
  const PanggilanOptionScreen({super.key});

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
            'Panggilan Darurat',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(AppRoutes.navbar);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildServiceCard(
              context,
              'assets/images/ambulans.png',
              'Ambulans',
              '112', // Ambulance phone number
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'assets/images/pemadam.png',
              'Pemadam Kebakaran',
              '113', // Fire department phone number
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'assets/images/polisi.png',
              'Polisi',
              '110', // Police phone number
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String imagePath,
    String title,
    String phoneNumber,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => PopUpPanggilan(
                imagePath: imagePath,
                title: title,
                phoneNumber: phoneNumber,
              ),
        );
      },
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 155,
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c020608,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
