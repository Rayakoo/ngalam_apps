import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PopUpAlamatScreen extends StatefulWidget {
  const PopUpAlamatScreen({super.key});

  @override
  _PopUpAlamatScreenState createState() => _PopUpAlamatScreenState();
}

class _PopUpAlamatScreenState extends State<PopUpAlamatScreen> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('PopUpAlamatScreen initialized'); // Debug print statement
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _updateAddress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newAddress = _addressController.text;

    print('New address: $newAddress'); // Debug print statement

    if (newAddress.isEmpty) {
      Fluttertoast.showToast(
        msg: "Alamat tidak boleh kosong!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final userData = userProvider.userData;
      print(
        'User data before update popupalamat: $userData',
      ); // Debug print statement

      if (userData != null) {
        userData['address'] = newAddress;
        print('Updated user data: $userData'); // Debug print statement
        print('Calling updateUser...');
        print('User ID: ${userProvider.userData!['id']}');
        await userProvider.updateUser(userProvider.userData!['id'], userData);
        print('updateUser called successfully');
        Fluttertoast.showToast(
          msg: "Alamat berhasil diperbarui!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.c2a6892,
          textColor: Colors.white,
        );
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: "Gagal memperbarui alamat: User data tidak ditemukan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal memperbarui alamat: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building PopUpAlamatScreen'); // Debug print statement
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lengkapi Profil',
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c2a6892,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Mohon masukkan alamat anda untuk melengkapi data profil anda dengan benar',
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: AppColors.c3585ba,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Alamat Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  print(
                    'Address input changed: $value',
                  ); // Debug print statement
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2a6892,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Simpan',
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
