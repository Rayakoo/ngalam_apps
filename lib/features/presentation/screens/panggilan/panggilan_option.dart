import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class PanggilanOptionScreen extends StatelessWidget {
  const PanggilanOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panggilan Darurat'),
        backgroundColor: AppColors.cce1f0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Layanan Darurat',
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              Icons.local_hospital,
              'Ambulans',
              Colors.red,
              backgroundColor: AppColors.white,
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              Icons.local_police,
              'Polisi',
              Colors.blue,
              backgroundColor: AppColors.white,
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              Icons.fire_truck,
              'Pemadam Kebakaran',
              Colors.orange,
              backgroundColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    IconData icon,
    String title,
    Color iconColor, {
    Color backgroundColor = Colors.white,
  }) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: iconColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 40),
        title: Text(
          title,
          style: AppTextStyles.heading_4_bold.copyWith(color: iconColor),
        ),
        onTap: () {
          // Handle the tap event
        },
      ),
    );
  }
}
