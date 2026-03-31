import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

///  DRIVER MODEL
class Driver {
  final String name;
  final String image;
  final double rating;
  final int price;
  final String time;

  Driver({
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
    required this.time,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LatLng center = const LatLng(20.9467, 72.9520);

  List<LatLng> drivers = [];
  Timer? timer;
  final Random random = Random();

  final List<Driver> driverData = [
    Driver(name: "Rahul Sharma", image: "https://randomuser.me/api/portraits/men/1.jpg", rating: 4.8, price: 120, time: "2 min"),
    Driver(name: "Amit Patel", image: "https://randomuser.me/api/portraits/men/2.jpg", rating: 4.6, price: 150, time: "4 min"),
    Driver(name: "Vikas Yadav", image: "https://randomuser.me/api/portraits/men/3.jpg", rating: 4.9, price: 110, time: "1 min"),
    Driver(name: "Suresh Kumar", image: "https://randomuser.me/api/portraits/men/4.jpg", rating: 4.5, price: 130, time: "3 min"),
    Driver(name: "Imran Khan", image: "https://randomuser.me/api/portraits/men/5.jpg", rating: 4.7, price: 140, time: "5 min"),
    Driver(name: "Rakesh Singh", image: "https://randomuser.me/api/portraits/men/6.jpg", rating: 4.4, price: 125, time: "6 min"),
  ];

  @override
  void initState() {
    super.initState();

    drivers = List.generate(driverData.length, (index) {
      return LatLng(
        center.latitude + random.nextDouble() / 500,
        center.longitude + random.nextDouble() / 500,
      );
    });

    timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() {
        drivers = drivers.map((d) {
          return LatLng(
            d.latitude + (random.nextDouble() - 0.5) / 2000,
            d.longitude + (random.nextDouble() - 0.5) / 2000,
          );
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  ///  STAR BUILDER (SMALL SIZE)
  Widget buildRatingStars(double rating) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(const Icon(Icons.star, color: Color(0xFFFFC107), size: 14));
      } else if (rating >= i - 0.5) {
        stars.add(const Icon(Icons.star_half, color: Color(0xFFFFC107), size: 14));
      } else {
        stars.add(const Icon(Icons.star_border, color: Color(0xFFFFC107), size: 14));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🗺️ MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c'],
                retinaMode: true,
              ),

              ///  DRIVERS
              MarkerLayer(
                markers: drivers.map((driver) {
                  return Marker(
                    point: driver,
                    width: 70,
                    height: 70,
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Transform.rotate(
                          angle: random.nextDouble(),
                          child: Image.asset(
                            'assets/images/car.png',
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              ///  USER LOCATION
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 28,
                    height: 28,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFD453),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFC107).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          ///  SEARCH BAR
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFC107), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    "Where to?",
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DRIVER LIST
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 10),

                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: driverData.length,
                          itemBuilder: (_, index) =>
                              driverCard(driverData[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// DRIVER CARD (RESPONSIVE FIXED)
  Widget driverCard(Driver driver) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(driver.image),
          ),

          const SizedBox(width: 12),

          ///  FLEXIBLE CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  driver.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                ///  RESPONSIVE RATING
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [

                    buildRatingStars(driver.rating),

                    Text(
                      driver.rating.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    Text(
                      "• ${driver.time}",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          ///  RIGHT SIDE FLEXIBLE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                "₹${driver.price}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              SizedBox(
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Select",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}