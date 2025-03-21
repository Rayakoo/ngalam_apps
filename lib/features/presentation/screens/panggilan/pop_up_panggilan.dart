import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class PopUpPanggilan extends StatelessWidget {
  final String imagePath;
  final String title;
  final String phoneNumber;

  const PopUpPanggilan({
    super.key,
    required this.imagePath,
    required this.title,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, height: 100, width: 100, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text(
            'Apakah anda yakin ingin menghubungi',
            style: AppTextStyles.paragraph_14_regular.copyWith(
              color: AppColors.c020608,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: AppTextStyles.heading_4_bold.copyWith(
              color: AppColors.c020608,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cce1f0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final url = 'tel:$phoneNumber';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c7db4d9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Ya',
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: AppColors.c1f4d6b,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
