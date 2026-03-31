import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    ///  Bottom sheet animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });

    phoneFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    phoneFocus.dispose();
    phoneController.dispose();
    super.dispose();
  }

  ///  SEND OTP FUNCTION
  Future<void> sendOTP() async {
    if (phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService().sendOTP(phoneController.text);

      /// 🔁 Navigate to OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPScreen(phoneController.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD54F),

      body: Stack(
        children: [

          ///  CENTER BRANDING
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {

                double bottomSheetHeight = 300;

                return Column(
                  children: [
                    SizedBox(
                      height:
                      (constraints.maxHeight - bottomSheetHeight) / 2 - 80,
                    ),

                    Column(
                      children: [
                        Text(
                          "PingRide",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Move smarter, faster",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          ///  BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Enter your phone number",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ///  INPUT
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: phoneFocus.hasFocus
                              ? const Color(0xFFFFC107)
                              : Colors.white24,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: phoneController,
                        focusNode: phoneFocus,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: "+91 ",
                          prefixStyle: TextStyle(color: Colors.white),
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔘 BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : sendOTP,
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                            : Text(
                          "Continue",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "We’ll send you an OTP to verify",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}