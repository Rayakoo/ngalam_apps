import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _addressController = TextEditingController();
  String? _uploadedPhotoUrl;
  bool _isUploading = false; // Add a flag for loading state

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _addressController.text = userProvider.userData?['address'] ?? '';
  }

  Future<String> uploadImage(String filePath) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dpbw0ztwl/upload');
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'a5tgii2s'
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              filePath,
              contentType: MediaType('image', 'jpeg'),
            ),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['secure_url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _uploadPhoto() async {
    setState(() {
      _isUploading = true; // Set loading state to true
    });

    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        print('Selected file path: $filePath'); // Debug log
        final uploadedUrl = await uploadImage(filePath);
        if (uploadedUrl.isNotEmpty) {
          print('Uploaded photo URL: $uploadedUrl'); // Debug log
          setState(() {
            _uploadedPhotoUrl = uploadedUrl;
            print('Updated _uploadedPhotoUrl: $_uploadedPhotoUrl'); // Debug log
          });
        } else {
          print('Uploaded URL is empty'); // Debug log
        }
      } else {
        print('No file selected or file path is null'); // Debug log
      }
    } catch (e) {
      print('Error uploading photo: $e'); // Debug log
    } finally {
      setState(() {
        _isUploading = false; // Set loading state to false
      });
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userData?['id'];
    final newAddress = _addressController.text;

    if (userId == null) {
      print('User ID not found'); // Debug log
      return;
    }

    try {
      if (newAddress.isNotEmpty) {
        print('Updating address to: $newAddress'); // Debug log
        await userProvider.updateAddress(userId, newAddress);
      }
      if (_uploadedPhotoUrl != null) {
        print(
          'Updating photo profile with URL: $_uploadedPhotoUrl',
        ); // Debug log
        await userProvider.updatePhotoProfile(userId, _uploadedPhotoUrl!);
      }
      Fluttertoast.showToast(
        msg: "Perubahan tersimpan!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      await userProvider.fetchUserData(); // Re-fetch user data to update UI
      setState(() {}); // Rebuild the UI
      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile: $e'); // Debug log
      Fluttertoast.showToast(
        msg: "Gagal memperbarui profil: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
            'Edit Profile',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment:
                    Alignment
                        .bottomRight, // Align the edit button to the bottom-right
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _uploadedPhotoUrl != null
                            ? NetworkImage(_uploadedPhotoUrl!)
                            : NetworkImage(
                              Provider.of<UserProvider>(
                                    context,
                                  ).userData?['photoProfile'] ??
                                  '',
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _uploadPhoto,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              Colors
                                  .white, // Background color for the edit button
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.c3585ba, // Icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Alamat',
              style: AppTextStyles.paragraph_14_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2a6892,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
