import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      Fluttertoast.showToast(
        msg: "Password reset email sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send password reset email: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: screenHeight,
            decoration: BoxDecoration(
              color: AppColors.white,
            ), // Background putih (full layar)
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight * 0.5,
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/orang-login.png',
                      width: 811,
                      height: 900,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.23,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cce1f0, // Light blue background
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 70),
                            Text(
                              'Reset Password',
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
                              TextEditingController(text: widget.email),
                              false,
                              Icons.email_outlined,
                            ),
                            SizedBox(height: 18),
                            _buildTextField(
                              'New Password',
                              passwordController,
                              true,
                              Icons.lock_outline,
                            ),
                            SizedBox(height: 30),
                            _buildResetButton(),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/bangunan.png',
                    width: 720,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
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
      onPressed: resetPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2A6892),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Center(
        child: Text(
          'Send Password Reset Email',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
