import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/verify_otp_email_screen.dart';

class SendOTPEmailScreen extends StatefulWidget {
  @override
  _SendOTPEmailScreenState createState() => _SendOTPEmailScreenState();
}

class _SendOTPEmailScreenState extends State<SendOTPEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    emailAuth = EmailAuth(sessionName: "Reset Password OTP");
  }

  void sendOTP() async {
    bool result = await emailAuth.sendOtp(recipientMail: emailController.text);
    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP telah dikirim ke email")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => VerifyOTPEmailScreen(email: emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kirim OTP ke Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Masukkan Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: sendOTP, child: Text("Kirim OTP")),
          ],
        ),
      ),
    );
  }
}
