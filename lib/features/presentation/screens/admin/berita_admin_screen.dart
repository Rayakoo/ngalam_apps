import 'package:flutter/material.dart';

class BeritaAdminScreen extends StatelessWidget {
  const BeritaAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Berita'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Tambah Berita Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
