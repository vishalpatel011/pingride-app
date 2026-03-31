import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// 🎬 Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    ///  Slide from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    ///  Fade in
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    ///  Start animation slightly delayed
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });


    ///  Navigation (enable later)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFD54F),
              Color(0xFFFFB300),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// 🚕 TAXI LOTTIE
              Expanded(
                child: Align(
                  alignment: const Alignment(0, 0.15),
                  child: Lottie.asset(
                    'assets/lottie/taxi.json',
                    width: 280, // balanced size
                    repeat: true,
                  ),
                ),
              ),

              ///  ANIMATED TEXT SECTION
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [

                      ///  APP NAME
                      Text(
                        "PingRide",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFECB3),
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// 🟡 ACCENT LINE
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ///  TAGLINE
                      Text(
                        "Move smarter, faster, better",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFECB3).withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}