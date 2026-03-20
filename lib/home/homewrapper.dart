import 'package:amber_hackathon/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your tab screens here
import '../complaints/complaints_screen.dart';
import '../mess_menu_screen.dart';
import '../notice.dart';
import '../setting.dart';


class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex = 0;


  final List<Widget> _screens = const [
    Dashboard(),      // 0
    MessMenuScreen(),     // 1
    ComplaintsScreen(),   // 2
    SettingsScreen(),     // 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      // 1. YOUR CUSTOM APP BAR (Always visible)
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [

            GestureDetector(
              onTap: () {

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
            const SizedBox(width: 12),
            // Greeting & Room Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello Gujjar',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  'Room 214, Block B',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification Bell
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFF5655D1),
                    size: 28,
                  ),
                  onPressed: () {
                    // Handle notifications
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 2. THE BODY (Swaps between screens without losing scroll position)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // 3. YOUR BOTTOM NAVIGATION BAR (Always visible)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEEF2FF), // Soft indigo for active tab
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.home, color: Color(0xFF4338CA)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.restaurant, color: Color(0xFF4338CA)),
            label: 'Mess',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.cleaning_services, color: Color(0xFF4338CA)),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
            selectedIcon: Icon(Icons.person, color: Color(0xFF4338CA)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}