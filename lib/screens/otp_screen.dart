import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen(this.phone, {super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocus = FocusNode();

  final AuthService auth = AuthService();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    /// 🎬 Animation
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

    otpFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    otpFocus.dispose();
    otpController.dispose();
    super.dispose();
  }

  ///  VERIFY OTP
  Future<void> verifyOTP() async {
    if (otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await auth.verifyOTP(otpController.text);

    setState(() => isLoading = false);

    if (success) {
      ///  GO TO HOME SCREEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
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

                double bottomSheetHeight = 320;

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
                      "Enter OTP",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Sent to +91 ${widget.phone}",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ///  OTP INPUT (SIMPLE)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: otpFocus.hasFocus
                              ? const Color(0xFFFFC107)
                              : Colors.white24,
                        ),
                      ),
                      child: TextField(
                        controller: otpController,
                        focusNode: otpFocus,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter OTP",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ///  VERIFY BUTTON
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

                        onPressed: isLoading ? null : verifyOTP,

                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                            : Text(
                          "Verify",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ///  RESEND
                    Center(
                      child: Text(
                        "Resend OTP",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFC107),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
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