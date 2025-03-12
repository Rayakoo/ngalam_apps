import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile Page")),
        body: const Center(child: Text("No user is currently logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Logout user
              await firebase_auth.FirebaseAuth.instance.signOut();
              // Navigate to the Login Screen after logout
              context.go('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final name = userData['name'] ?? 'No name';
          final nomerIndukKependudukan =
              userData['nomer_induk_kependudukan'] ?? 'No NIK';
          final email = user.email ?? 'No email';
          final photoProfile =
              userData['photoProfile'] ??
              'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7';
          final address = userData['address'] ?? '-';

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $name", style: const TextStyle(fontSize: 18)),
                Text(
                  "NIK: $nomerIndukKependudukan",
                  style: const TextStyle(fontSize: 18),
                ),
                Text("Email: $email", style: const TextStyle(fontSize: 18)),
                Text("Address: $address", style: const TextStyle(fontSize: 18)),
                Image.network(photoProfile, width: 100, height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
