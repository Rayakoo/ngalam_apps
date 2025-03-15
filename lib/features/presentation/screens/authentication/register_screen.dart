import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _nomer_induk_kependudukanController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cce1f0, // Light blue background
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top wavy shape
              Container(
                width: double.infinity,
                height: 150,
                color: AppColors.white, // Light blue background
              ),

              // Register content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Daftar',
                      style: AppTextStyles.heading_2_medium.copyWith(
                        color: AppColors.c1f4d6b,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Mari Bergabung!',
                      style: AppTextStyles.heading_4_regular.copyWith(
                        color: AppColors.c1f4d6b,
                      ),
                    ),
                    SizedBox(height: 25),

                    // Nama Pengguna field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Pengguna',
                          style: AppTextStyles.paragraph_14_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 331,
                          height: 37,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.a4cbe5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Nama Panjang',
                              hintStyle: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: Color(0xFFBCBCBC)),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Color(0xFFBCBCBC),
                                size: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // NIK field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Induk Kependudukan (NIK)',
                          style: AppTextStyles.paragraph_14_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 331,
                          height: 37,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.a4cbe5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: TextField(
                            controller: _nomer_induk_kependudukanController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Nomor Induk Kependudukan',
                              hintStyle: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: Color(0xFFBCBCBC)),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              prefixIcon: Icon(
                                Icons.credit_card,
                                color: Color(0xFFBCBCBC),
                                size: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Email field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: AppTextStyles.paragraph_14_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 331,
                          height: 37,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.a4cbe5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: Color(0xFFBCBCBC)),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
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
                    SizedBox(height: 15),

                    // Password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kata sandi',
                          style: AppTextStyles.paragraph_14_medium.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 331,
                          height: 37,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.a4cbe5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Kata sandi',
                              hintStyle: AppTextStyles.paragraph_14_regular
                                  .copyWith(color: Color(0xFFBCBCBC)),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
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
                    SizedBox(height: 25),

                    // Register button
                    Container(
                      width: 331,
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        color: AppColors.c2a6892,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _register,
                        child: Text(
                          'Daftar',
                          style: AppTextStyles.paragraph_14_medium.copyWith(
                            color: AppColors.white,
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
                    SizedBox(height: 16),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah memiliki akun? ',
                            style: AppTextStyles.paragraph_14_regular.copyWith(
                              color: AppColors.c1f4d6b,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go(AppRoutes.auth);
                            },
                            child: Text(
                              'Login',
                              style: AppTextStyles.paragraph_14_medium.copyWith(
                                color: AppColors.c2a6892,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),

                    // Terms and privacy policy
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Dengan membuat akun, Anda menyetujui Ketentuan dan Kebijakan Privasi kami',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.paragraph_10_regular.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Bottom city skyline placeholder
                    Container(
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: Text(
                          "City Skyline Image",
                          style: AppTextStyles.paragraph_14_regular.copyWith(
                            color: AppColors.c1f4d6b,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _nikExists(String nik) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('nomer_induk_kependudukan', isEqualTo: nik)
              .limit(1)
              .get();
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions (e.g., network issues) appropriately
      print("Error checking NIK: ${e.message}");
      return false; // Or throw the exception, depending on your error handling strategy
    }
  }

  Future<void> _register() async {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() => _isLoading = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final nik = _nomer_induk_kependudukanController.text;

    // Validate NIK
    if (nik.length != 16 || !RegExp(r'^\d{16}$').hasMatch(nik)) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NIK must be a 16-digit number.')),
        );
      }
      return;
    }

    // Validate name
    if (name.isEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Name cannot be empty.')));
      }
      return;
    }

    final user = UserEntity(
      nomer_induk_kependudukan: nik,
      name: name,
      email: email,
      password: password,
      photoProfile:
          'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7', // Default photo profile path
      address: '-', // Default address
    );

    try {
      final nikExists = await _nikExists(nik);

      if (nikExists) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('NIK already exists.')));
        }
        return;
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: user.email,
              password: user.password,
            );

        await transaction.set(
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid),
          {
            'nomer_induk_kependudukan': user.nomer_induk_kependudukan,
            'name': user.name,
            'email': user.email,
            'photoProfile': user.photoProfile, // Save photoProfile
            'address': user.address, // Save address
          },
        );
      });

      if (mounted) {
        await FirebaseAuth.instance.signOut(); // Sign out the user
        context.go(AppRoutes.auth); // Navigate to login screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! ')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Error creating user: ${e.code}';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message ?? e.toString()}')),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}