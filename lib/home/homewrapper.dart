import 'dart:convert';

import 'package:amber_hackathon/amenity_list_screen.dart';
import 'package:amber_hackathon/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../complaints/complaints_screen.dart';
import '../lost_and_found/lost_and_found_screen.dart';


import '../profile/profile.dart';



class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex = 0;

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        _userData = jsonDecode(userJson);
      });
    }
  }

  final List<Widget> _screens = const [
    Dashboard(),
    LostAndFoundScreen(),
    ComplaintsScreen(),
    AmenitiesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [

            GestureDetector(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );

              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData != null ? (_userData!['Name'] ?? 'Student') : 'Loading...',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                 _userData !=null ? ('Room ${_userData!['Room Number'] ?? 'N/A'}, Block ${_userData!['Hostel Block'] ?? 'N/A'}') : 'Room Loading...',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEEF2FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.home, color: Color(0xFF4338CA)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_search_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.manage_search, color: Color(0xFF4338CA)),
            label: 'Lost/Found',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.cleaning_services, color: Color(0xFF4338CA)),
            label: 'Complaints',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF4338CA)),
            label: 'Amenities',
          ),
        ],
      ),
    );
  }
}