import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class PopUpSignOutScreen extends StatelessWidget {
  final String title;
  
  final String buttonTextYes;
  final String buttonTextNo;

  const PopUpSignOutScreen({
    super.key,
    required this.title,
   
    required this.buttonTextYes,
    required this.buttonTextNo,
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
                'assets/images/orang-login.png',
                height: 150,
              ), // Replace with your image asset
              SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c1f4d6b,
                ),
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: BorderSide(
                        color: AppColors.c1f4d6b,
                      ), // Add border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      buttonTextNo,
                      style: AppTextStyles.paragraph_14_medium.copyWith(
                        color: AppColors.c1f4d6b,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add sign out logic here
                      FirebaseAuth.instance.signOut();
                      context.go(AppRoutes.auth);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c7db4d9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      buttonTextYes,
                      style: AppTextStyles.paragraph_14_medium.copyWith(
                        color: AppColors.c1f4d6b,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
