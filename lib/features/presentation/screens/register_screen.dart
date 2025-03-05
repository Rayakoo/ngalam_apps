import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';

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
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _nomer_induk_kependudukanController,
              decoration: const InputDecoration(labelText: "NIK"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _nikExists(String nik) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
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
    setState(() => _isLoading = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final nik = _nomer_induk_kependudukanController.text;

    // Validate NIK
    if (nik.length != 16 || !RegExp(r'^\d{16}$').hasMatch(nik)) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NIK must be a 16-digit number.')));
      return;
    }

    // Validate name
    if (name.isEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name cannot be empty.')));
      return;
    }

    final user = UserEntity(
      nomer_induk_kependudukan: nik,
      name: name,
      email: email,
      password: password,
    );

    try {
      final nikExists = await _nikExists(nik);

      if (nikExists) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('NIK already exists.')));
        return;
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: user.email, password: user.password);

        await transaction.set(
            FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid),
            {
              'nomer_induk_kependudukan': user.nomer_induk_kependudukan,
              'name': user.name,
              'email': user.email,
            });
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')));
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Error creating user: ${e.code}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message ?? e.toString()}')));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
