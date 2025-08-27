// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savenest/user_provider.dart';
import 'package:savenest/main_screen.dart';
import 'package:savenest/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _verificationId = '';
  bool _isOtpSent = false;

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || !RegExp(r'^\+\d{10,15}$').hasMatch(phone)) {
      Fluttertoast.showToast(
        msg: 'Enter valid phone number (e.g., +1234567890)',
      );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        setState(() => _isOtpSent = true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      Fluttertoast.showToast(msg: 'Enter 6-digit OTP');
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    await _signIn(credential);
  }

  Future<void> _signIn(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final isNew = userCredential.additionalUserInfo!.isNewUser;
      if (isNew) {
        if (context.mounted) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Authentication failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (e.g., +1234567890)',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
