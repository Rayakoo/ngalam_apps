import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/screens/home_screen.dart';
import 'package:tes_gradle/features/presentation/screens/register_screen.dart';

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
          color: Colors.white,
        ), // Background putih (full layar)
        child: Stack(
          children: [
            // Gambar di tengah atas (1/5 layar)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              height: screenHeight * 0.25,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey.withOpacity(0.2),
                  child: Center(
                    child: Text(
                      "Character Image",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // Box biru (untuk login content - 4/5 layar)
            Positioned(
              top: screenHeight * 0.32,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFCCE1F0), // Light blue background
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Login title
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF1F4D6B),
                            fontSize: 31,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.24,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Subtitle
                        Text(
                          'Masuk untuk Mulai',
                          style: TextStyle(
                            color: Color(0xFF1F4D6B),
                            fontSize: 21,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.31,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Email field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Color(0xFF1F4D6B),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.21,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 331,
                              height: 37,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFA4CAE4),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBCBCBC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFFBCBCBC),
                                    size: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),

                        // Password field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kata Sandi',
                              style: TextStyle(
                                color: Color(0xFF1F4D6B),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.21,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 331,
                              height: 37,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFA4CAE4),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Kata sandi',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBCBCBC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFBCBCBC),
                                    size: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Lupa kata Sandi?',
                              style: TextStyle(
                                color: Color(0xFFFF0000),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Login button
                        Container(
                          width: 331,
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: ShapeDecoration(
                            color: Color(0xFF2A6892),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _login,
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                              ), // Adjust padding to fit text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Register link
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Belum memiliki akun? ',
                                style: TextStyle(
                                  color: Color(0xFF1F4D6B),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Color(0xFF2A6892),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20), // Add some space before the image
                       

                        // Tambahkan space untuk memastikan scrolling aman
                        SizedBox(height: 20),
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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Panggil metode login dari AuthProvider
      final user = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).login(email, password, context);

      // Gunakan NIK dan nama dari user
      final nomer_induk_kependudukan = user.nomer_induk_kependudukan;
      final name = user.name;

      // Lanjutkan dengan navigasi atau operasi lainnya
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }

      // Kamu bisa menyimpan NIK dan nama ke shared preferences atau state management lain jika perlu
      // Contoh:
      // await saveUserData(nomerIndukKependudukan, name);
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
