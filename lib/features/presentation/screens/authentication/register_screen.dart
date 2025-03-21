import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'pop_up_berhasil.dart'; // Import the PopUpBerhasilScreen

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColors.white,
            ), // Background putih (full layar)
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
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
                            SizedBox(height: 30),
                            Text(
                              'Daftar',
                              style: AppTextStyles.heading_2_medium.copyWith(
                                color: AppColors.c1f4d6b,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Mari Bergabung!',
                              style: AppTextStyles.heading_4_regular.copyWith(
                                color: AppColors.c1f4d6b,
                              ),
                            ),
                            SizedBox(height: 25),
                            // Nama Pengguna field
                            _buildTextField(
                              'Nama Pengguna',
                              _nameController,
                              false,
                              Icons.person_outline,
                            ),
                            SizedBox(height: 15),
                            // NIK field
                            _buildTextField(
                              'Nomor Induk Kependudukan (NIK)',
                              _nomer_induk_kependudukanController,
                              false,
                              Icons.credit_card,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 15),
                            // Email field
                            _buildTextField(
                              'Email',
                              _emailController,
                              false,
                              Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 15),
                            // Password field
                            _buildTextField(
                              'Kata sandi',
                              _passwordController,
                              true,
                              Icons.lock_outline,
                            ),
                            SizedBox(height: 25),
                            _buildRegisterButton(),
                            SizedBox(height: 16),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah memiliki akun? ',
                                    style: AppTextStyles.paragraph_14_regular
                                        .copyWith(color: AppColors.c1f4d6b),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.go(AppRoutes.auth);
                                    },
                                    child: Text(
                                      'Login',
                                      style: AppTextStyles.paragraph_14_medium
                                          .copyWith(
                                            color: AppColors.c2a6892,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Dengan membuat akun, Anda menyetujui',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.paragraph_10_regular
                                          .copyWith(color: AppColors.c1f4d6b),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                          'Navigating to KetentuanKebijakanScreen',
                                        );
                                        context.push(
                                          AppRoutes.ketentuanKebijakan,
                                        );
                                      },
                                      child: Text(
                                        'Ketentuan dan Kebijakan Privasi kami',
                                        style: AppTextStyles
                                            .paragraph_10_regular
                                            .copyWith(
                                              color: AppColors.secondaryijo,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
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
      print("Error checking NIK: ${e.message}");
      return false;
    }
  }

  Future<void> _register() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final nik = _nomer_induk_kependudukanController.text;

    // Validate NIK
    if (nik.length != 16 || !RegExp(r'^\d{16}$').hasMatch(nik)) {
      if (mounted) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: 'NIK must be a 16-digit number.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      return;
    }

    // Validate name
    if (name.isEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: 'Name cannot be empty.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
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
      address: '-',
      role: 'user',
    );

    try {
      final nikExists = await _nikExists(nik);

      if (nikExists) {
        if (mounted) {
          setState(() => _isLoading = false);
          Fluttertoast.showToast(
            msg: 'NIK already exists.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
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
            'role': user.role, // Save role
          },
        );
      });

      if (mounted) {
        await FirebaseAuth.instance.signOut(); // Sign out the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUpBerhasilScreen(
              title: 'Sukses Membuat Akun',
              description:
                  'Silahkan masuk menggunakan Email dan Password Anda!',
              buttonText: 'Masuk',
            );
          },
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
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Error: ${e.message ?? e.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Error: ${e.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isObscure,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            keyboardType: keyboardType,
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

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2A6892),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Center(
        child: Text(
          'Daftar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
