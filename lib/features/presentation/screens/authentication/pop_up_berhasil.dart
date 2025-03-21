import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class PopUpBerhasilScreen extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;

  const PopUpBerhasilScreen({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/orang-berhasil.png',
                height: 150,
              ), // Replace with your image asset
              SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c1f4d6b,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph_18_regular.copyWith(
                  color: AppColors.c2a6892,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cce1f0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 110, vertical: 12),
                ),
                child: Text(
                  buttonText,
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: AppColors.c1f4d6b,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
