import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class KetentuanKebijakanScreen extends StatelessWidget {
  const KetentuanKebijakanScreen({super.key});

  Widget buildKebijakanSection(String title, String description, int tinggi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 32, color: AppColors.c1f4d6b),
        Text(
          title,
          style: AppTextStyles.heading_4_regular.copyWith(
            color: AppColors.c1f4d6b,
          ),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: tinggi.toDouble(),
              color: AppColors.c2a6892,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: AppColors.c1f4d6b,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
            'Syarat dan Ketentuan',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.c1f4d6b),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kebijakan Privasi',
              style: AppTextStyles.heading_2_bold.copyWith(
                color: AppColors.c1f4d6b,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi MalangTanggap adalah aplikasi resmi Kota Malang yang bertujuan untuk mempertemukan masyarakat dalam melaporkan kerusakan infrastruktur, mengakses CCTV di beberapa wilayah untuk melihat lalu lintas dan cuaca, serta menggunakan fitur panggilan darurat (Emergency Call).',
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c1f4d6b,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kami berkomitmen untuk menghormati dan melindungi data pribadi pengguna serta mematuhi segala peraturan perundang-undangan yang berlaku di Republik Indonesia. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, menyimpan, dan melindungi data pengguna.',
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c1f4d6b,
              ),
            ),
            buildKebijakanSection(
              'Perolehan dan Pengumpulan Data',
              'Kami mengumpulkan data pengguna dengan tujuan untuk mengelola layanan, meningkatkan pengalaman pengguna, dan memastikan keamanan serta kerahasiaan layanan. Data yang kami kumpulkan meliputi:\n1. Data yang diberikan oleh pengguna secara langsung:\n- Nama\n- Email\n- Password\n- Nomor Induk Kependudukan (NIK)\n- Alamat\n- Foto profil\n2. Data yang terekam secara otomatis saat pengguna menggunakan aplikasi (Nama Aplikasi), termasuk namun tidak terbatas pada:\n- Alamat IP dan lokasi perkiraan (GPS, Wi-Fi, dll.)\n- Riwayat aktivitas seperti waktu akses, tanggal, pelaporan, atau penggunaan fitur tertentu\n- Informasi perangkat seperti jenis perangkat, sistem operasi, dan browser yang digunakan\n3. Data lainnya yang diperlukan, kami akan meminta izin terlebih dahulu untuk mengumpulkan data tersebut.',
              430,
            ),
            buildKebijakanSection(
              'Penyimpanan Data',
              'Kami menerapkan berbagai langkah pengamanan untuk menjaga data pribadi pengguna dari akses tidak sah, penggunaan yang tidak sah, serta kebocoran data. Data pengguna disimpan dalam sistem yang terlindungi dengan firewall dan hanya dapat diakses oleh pihak berwenang.\n\nKami menyimpan data pengguna selama masih diperlukan untuk mendukung layanan aplikasi ini. Jika pengguna ingin menghapus akun dan datanya, mereka dapat mengajukan permintaan melalui layanan pelanggan kami.\n\nNamun, perlu diketahui bahwa tidak ada sistem yang dapat memberikan jaminan keamanan 100%. Oleh karena itu, pengguna juga bertanggung jawab untuk menjaga keamanan akun mereka, termasuk menjaga kerahasiaan username dan password.',
              350,
            ),
            buildKebijakanSection(
              'Penggunaan Data',
              'Kami menggunakan data yang dikumpulkan untuk tujuan berikut:\n- Memverifikasi identitas pengguna saat login\n- Memproses laporan kerusakan infrastruktur\n- Menampilkan akses CCTV sesuai wilayah pengguna\n- Menyediakan layanan emergency call dengan informasi lokasi pengguna\n- Melakukan pemantauan dan perbaikan sistem aplikasi\n- Meningkatkan pengalaman pengguna dengan analisis data dan pengembangan fitur baru\n\nKami tidak akan menjual, menyewakan, atau membagikan data pengguna kepada pihak ketiga tanpa izin, kecuali diwajibkan oleh hukum atau untuk kepentingan keamanan publik.',
              300,
            ),
            buildKebijakanSection(
              'Perubahan Kebijakan Privasi',
              'Kami dapat mengubah atau memperbarui kebijakan privasi ini kapan saja untuk menyesuaikan dengan perkembangan hukum dan peningkatan layanan. Kami akan memberi tahu pengguna melalui aplikasi jika ada perubahan signifikan pada kebijakan ini. Dengan terus menggunakan layanan kami, pengguna dianggap telah membaca, memahami, dan menyetujui kebijakan privasi yang berlaku.\n\nJika pengguna memiliki pertanyaan atau keluhan terkait kebijakan privasi ini, silakan hubungi kami melalui [kontak/email resmi].\n\nTerima kasih telah menggunakan [Nama Aplikasi] untuk mendukung pembangunan dan kemajuan Kota Malang.',
              290,
            ),
          ],
        ),
      ),
    );
  }
}
