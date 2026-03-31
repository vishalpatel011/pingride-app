import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 MAKE STATIC (IMPORTANT)
  static String? _verificationId;

  /// 📲 SEND OTP
  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phone",

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        print("Error: ${e.message}");
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// 🔐 VERIFY OTP
  Future<bool> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        print("Verification ID is null ❌");
        return false;
      }

      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print("OTP Error: $e");
      return false;
    }
  }
}