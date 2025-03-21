import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
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
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenHeight = constraints.maxHeight;
            double screenWidth = constraints.maxWidth;

            return SingleChildScrollView(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(color: AppColors.white),
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
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.4,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.28,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cce1f0,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.02,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.05),
                                Text(
                                  'Masuk',
                                  style: AppTextStyles.heading_2_medium
                                      .copyWith(color: AppColors.c1f4d6b),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Masuk untuk Mulai',
                                  style: AppTextStyles.heading_4_regular
                                      .copyWith(color: AppColors.c1f4d6b),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                _buildTextField(
                                  'Email',
                                  _emailController,
                                  false,
                                  Icons.email_outlined,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildTextField(
                                  'Kata Sandi',
                                  _passwordController,
                                  true,
                                  Icons.lock_outline,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.01,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push(AppRoutes.forgotPassword);
                                      },
                                      child: Text(
                                        'Lupa kata Sandi?',
                                        style: AppTextStyles.paragraph_14_medium
                                            .copyWith(color: Color(0xFFFF0000)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                _buildLoginButton(),
                                SizedBox(height: screenHeight * 0.02),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Belum memiliki akun? ',
                                        style: AppTextStyles
                                            .paragraph_14_regular
                                            .copyWith(color: AppColors.c2a6892),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.go(AppRoutes.register);
                                        },
                                        child: Text(
                                          'Daftar',
                                          style: TextStyle(
                                            color: AppColors.c1f4d6b,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
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
                        width: screenWidth,
                        height: screenHeight * 0.1,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await authProvider.login(
        _emailController.text,
        _passwordController.text,
        context,
      );

      await userProvider.fetchUserData();

      if (userProvider.userRole == 'admin') {
        context.go(AppRoutes.admin);
      } else {
        context.go(AppRoutes.navbar);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Login failed: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
