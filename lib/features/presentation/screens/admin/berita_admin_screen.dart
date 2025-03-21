import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/presentation/provider/berita_provider.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class BeritaAdminScreen extends StatefulWidget {
  const BeritaAdminScreen({super.key});

  @override
  _BeritaAdminScreenState createState() => _BeritaAdminScreenState();
}

class _BeritaAdminScreenState extends State<BeritaAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  void _addBerita() async {
    if (_formKey.currentState!.validate()) {
      final beritaProvider = Provider.of<BeritaProvider>(
        context,
        listen: false,
      );
      final newBerita = Berita(
        id: '', // ID will be generated by Firestore
        gambar: _gambarController.text,
        judul: _judulController.text,
        isi: _isiController.text,
      );
      await beritaProvider.addBerita(newBerita);
      _judulController.clear();
      _isiController.clear();
      _gambarController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita berhasil ditambahkan!')),
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
            'Tambah Berita',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.c020608),
            onPressed: () {
              context.go(AppRoutes.admin);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Berita Baru',
                    style: AppTextStyles.heading_4_bold.copyWith(
                      color: AppColors.c2a6892,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Berita',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _isiController,
                    decoration: const InputDecoration(
                      labelText: 'Isi Berita',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi berita tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gambarController,
                    decoration: const InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'URL gambar tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addBerita,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2a6892,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Tambah Berita',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Consumer<BeritaProvider>(
                builder: (context, beritaProvider, child) {
                  if (beritaProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final beritaList = beritaProvider.beritaList ?? [];
                  return ListView.builder(
                    itemCount: beritaList.length,
                    itemBuilder: (context, index) {
                      final berita = beritaList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Image.network(
                            berita.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image);
                            },
                          ),
                          title: Text(berita.judul),
                          subtitle: Text(
                            berita.isi,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await beritaProvider.removeBerita(berita.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berita berhasil dihapus!'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
