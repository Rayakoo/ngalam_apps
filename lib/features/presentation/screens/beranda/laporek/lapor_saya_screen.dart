import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/pop_up_berhasil.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Add this import for reverse geocoding

class LaporSayaScreen extends StatefulWidget {
  const LaporSayaScreen({super.key});

  @override
  _LaporSayaScreenState createState() => _LaporSayaScreenState();
}

class _LaporSayaScreenState extends State<LaporSayaScreen> {
  bool _isAnonymityChecked = false;
  bool _isLocationSame = false;
  String _selectedCategory = '';
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();

  Future<void> _setCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _lokasiController.text =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        _lokasiController.text = 'Lokasi tidak ditemukan';
      }
    } catch (e) {
      _lokasiController.text = 'Gagal mendapatkan lokasi';
    }
  }

  Future<String> uploadImage(String filePath) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dpbw0ztwl/upload');

    // Buat request upload
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] =
              'a5tgii2s' // Ganti dengan Upload Preset kamu
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              filePath,
              contentType: MediaType(
                'image',
                'jpeg',
              ), // Pastikan format file benar
            ),
          );

    // Kirim request dan tangani respons
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      print('Upload successful: ${jsonMap['secure_url']}'); // Debug log
      return jsonMap['secure_url']; // Kembalikan URL file yang diunggah
    } else {
      print('Upload failed: ${response.statusCode}'); // Debug log
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _uploadPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        print('Selected file: $filePath'); // Debug log
        final uploadedUrl = await uploadImage(filePath);
        setState(() {
          _fotoController.text =
              uploadedUrl; // Set the uploaded URL to the controller
        });
        print('Uploaded photo URL: $uploadedUrl'); // Debug log
      }
    } catch (e) {
      print('Error uploading photo: $e'); // Debug log
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategori Laporan',
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c2a6892,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(
                    'Layanan Sosial',
                    'assets/images/layanan.png',
                  ),
                  _buildCategoryCard(
                    'Pelayanan Umum',
                    'assets/images/pelayanan.png',
                  ),
                  _buildCategoryCard(
                    'Keamanan & Ketertiban',
                    'assets/images/keamanan.png',
                  ),
                  _buildCategoryCard(
                    'Infrastruktur',
                    'assets/images/infrastruktur.png',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Judul Laporan',
                'Judul Laporan (60 kata)',
                60,
                _judulController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Keterangan Laporan',
                'Keterangan Laporan',
                null,
                _keteranganController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildLocationField(),
              const SizedBox(height: 16),
              _buildUploadPhotoField(),
              const SizedBox(height: 16),
              _buildAnonymityCheckbox(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String label, String assetPath) {
    final bool isSelected = _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Card(
        color: isSelected ? AppColors.c2a6892 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.c2a6892),
        ),
        child: SizedBox(
          width: 85,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetPath, width: 45, height: 45),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph_10_regular.copyWith(
                  color: isSelected ? Colors.white : AppColors.c2a6892,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hintText,
    int? maxLength,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.paragraph_14_medium.copyWith(
            color: AppColors.c2a6892,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.a4cbe5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lokasi Kejadian',
          style: AppTextStyles.paragraph_14_medium.copyWith(
            color: AppColors.c2a6892,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Sama dengan lokasi sekarang',
              style: AppTextStyles.paragraph_10_regular.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: _isLocationSame,
              onChanged: (value) {
                setState(() {
                  _isLocationSame = value;
                  if (value) {
                    _setCurrentLocation();
                  } else {
                    _lokasiController.clear();
                  }
                });
              },
              activeColor: AppColors.c2a6892,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.a4cbe5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: TextField(
                  controller: _lokasiController,
                  decoration: InputDecoration(
                    hintText: 'Lokasi Kejadian Laporan',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unggah Foto Bukti',
          style: AppTextStyles.paragraph_14_medium.copyWith(
            color: AppColors.c2a6892,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 150,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.a4cbe5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: _uploadPhoto,
              icon: const Icon(Icons.upload_file),
              label: const Text('Unggah Foto'),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: AppColors.c2a6892, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Maksimal Ukuran File: 10MB',
          style: AppTextStyles.paragraph_10_regular.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymityCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isAnonymityChecked = !_isAnonymityChecked;
            });
          },
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.c2a6892, width: 2),
              color:
                  _isAnonymityChecked
                      ? AppColors.c2a6892.withOpacity(0.5)
                      : Colors.transparent,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Saya ingin menyamarkan identitas saya',
          style: AppTextStyles.paragraph_14_regular.copyWith(
            color: AppColors.c2a6892,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitLaporan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.c2a6892,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 130),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Laporkan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _submitLaporan() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final geoPoint = GeoPoint(position.latitude, position.longitude);

    final laporan = Laporan(
      id: '',
      kategoriLaporan: _selectedCategory,
      judulLaporan: _judulController.text,
      keteranganLaporan: _keteranganController.text,
      lokasiKejadian: geoPoint, // Use GeoPoint
      foto: _fotoController.text,
      timeStamp: DateTime.now(),
      status: 'Menunggu',
      anonymus: _isAnonymityChecked,
      statusHistory: [],
      uid: '',
    );

    final laporProvider = Provider.of<LaporProvider>(context, listen: false);
    await laporProvider.addLaporan(laporan);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Laporan berhasil dikirim!')));

    // Clear the form
    setState(() {
      _selectedCategory = '';
      _judulController.clear();
      _keteranganController.clear();
      _lokasiController.clear();
      _fotoController.clear();
      _isAnonymityChecked = false;
      _isLocationSame = false;
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpBerhasilScreen(
          title: 'Laporan Anda di Terima!',
          description:
              'Anda bisa cek aktivitas untuk lihat riwayat laporan Anda!',
          buttonText: 'Tutup',
        );
      },
    );
  }
}
