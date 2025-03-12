import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/reset_password_screen.dart';


class VerifyOTPEmailScreen extends StatefulWidget {
  final String email;
  VerifyOTPEmailScreen({required this.email});

  @override
  _VerifyOTPEmailScreenState createState() => _VerifyOTPEmailScreenState();
}

class _VerifyOTPEmailScreenState extends State<VerifyOTPEmailScreen> {
  final TextEditingController otpController = TextEditingController();
  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    emailAuth = EmailAuth(sessionName: "Reset Password OTP");
  }

  void verifyOTP() {
    bool verified = emailAuth.validateOtp(
      recipientMail: widget.email,
      userOtp: otpController.text,
    );

    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP benar, lanjut reset password")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP salah")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: "Masukkan OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: verifyOTP, child: Text("Verifikasi")),
          ],
        ),
      ),
    );
  }
}
