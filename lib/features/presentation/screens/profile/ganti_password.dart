import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/pop_up_berhasil.dart'; // Import the PopUpBerhasilScreen

class GantiPasswordScreen extends StatefulWidget {
  const GantiPasswordScreen({super.key});

  @override
  _GantiPasswordScreenState createState() => _GantiPasswordScreenState();
}

class _GantiPasswordScreenState extends State<GantiPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

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
            'Ganti Kata Sandi',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/orang-duduk.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Masukkan alamat email yang terhubung dengan akun Anda dan kami akan mengirimkan instruksi untuk mengganti kata sandi Anda',
              textAlign: TextAlign.center,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c1f4d6b,
              ),
            ),
            SizedBox(height: 30),
            _buildTextField(
              'Email',
              _emailController,
              false,
              Icons.email_outlined,
            ),
            SizedBox(height: 30),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isObscure,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1F4D6B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 42,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFA4CAE4)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(icon, color: Color(0xFFBCBCBC)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2A6892),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Center(
        child: Text(
          'Kirim',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;

    try {
      // Panggil fungsi forgotPasswordEmail dari AuthProvider
      await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).forgotPasswordEmail(email, context);
      // Tampilkan pesan sukses jika berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpBerhasilScreen(
            title: 'Email Terkirim!',
            description:
                'Selanjutnya tolong cek Email anda untuk melanjutkan penggantian kata sandi',
            buttonText: 'Tutup',
          );
        },
      );
    } on Exception catch (e) {
      if (e.toString().contains('No user found for that email')) {
        // Tampilkan pesan error jika akun tidak ada
        Fluttertoast.showToast(
          msg: 'Account not found.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        // Tampilkan pesan error jika terjadi kesalahan lain
        Fluttertoast.showToast(
          msg: 'Error: ${e.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
