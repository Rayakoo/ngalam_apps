import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class DetailBeritaScreen extends StatelessWidget {
  final Berita berita;

  const DetailBeritaScreen({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/top bar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            berita.judul,
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                berita.gambar,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              berita.judul,
              style: AppTextStyles.heading_3_bold.copyWith(
                color: AppColors.c020608,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dipublikasikan pada: ${DateFormat('d MMMM yyyy').format(DateTime.now())}',
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              berita.isi,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c020608,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
