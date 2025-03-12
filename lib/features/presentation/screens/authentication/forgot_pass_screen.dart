import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/send_otp_email_screen.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
        ), // Background putih (full layar)

        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              height: screenHeight * 0.5,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/orang-login.png',
                  width: 811,
                  height: 920,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.32,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cce1f0, // Light blue background
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Password',
                          style: AppTextStyles.heading_2_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Enter your email to reset your password',
                          style: AppTextStyles.heading_4_regular.copyWith(
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

                        SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Remember your password? '),
                              GestureDetector(
                                onTap: () {
                                  context.go(AppRoutes.auth);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF2A6892),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/images/bangunan.png',
                          width: 720,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
          height: 37,
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
          'Reset Password',
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Password reset email sent. scrreen')),
      // );
    } on Exception catch (e) {
      if (e.toString().contains('No user found for that email')) {
        // Tampilkan pesan error jika akun tidak ada
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Account not found.')));
      } else {
        // Tampilkan pesan error jika terjadi kesalahan lain
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
