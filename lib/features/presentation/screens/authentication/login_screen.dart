import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
                          'Login',
                          style: AppTextStyles.heading_2_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Masuk untuk Mulai',
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
                        SizedBox(height: 18),
                        _buildTextField(
                          'Kata Sandi',
                          _passwordController,
                          true,
                          Icons.lock_outline,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                context.go(AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'Lupa kata Sandi?',
                                style: AppTextStyles.paragraph_14_medium
                                    .copyWith(color: Color(0xFFFF0000)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        _buildLoginButton(),

                        SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Belum memiliki akun? '),
                              GestureDetector(
                                onTap: () {
                                  context.go(AppRoutes.register);
                                },
                                child: Text(
                                  'Daftar',
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

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2A6892),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Center(
        child: Text(
          'Masuk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final user = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).login(email, password, context);
      if (mounted) {
        context.go(AppRoutes.navbar);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
