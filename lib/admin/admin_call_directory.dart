import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminStudentDirectoryScreen extends StatelessWidget {
  const AdminStudentDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4F46E5)), // Indigo-600
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.3),
            ),
          ),
        ),
        title: Text(
          'Student Directory',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4338CA), // Indigo-700
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Editorial Header Section
            Text(
              'MANAGEMENT CONSOLE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Student Directory',
              style: GoogleFonts.manrope(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -1.0,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Call students quickly',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 16, color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search by name, room, or admission...',
                  hintStyle: GoogleFonts.inter(color: AppColors.outline),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 12),
                    child: Icon(Icons.search, color: AppColors.outline),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Group A
            _buildGroupHeader('A'),
            const SizedBox(height: 16),
            _buildStudentCard(
              name: 'Aaron Mitchell',
              adminNo: 'ADM2401',
              roomNo: 'Room 102',
              avatarUrl: 'https://i.pravatar.cc/150?img=11',
              stripColor: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            _buildStudentCard(
              name: 'Alice Henderson',
              adminNo: 'ADM2412',
              roomNo: 'Room 205',
              avatarUrl: 'https://i.pravatar.cc/150?img=5',
              stripColor: AppColors.secondary,
            ),
            const SizedBox(height: 32),

            // Group B
            _buildGroupHeader('B'),
            const SizedBox(height: 16),
            _buildStudentCard(
              name: "Benjamin O'Connor",
              adminNo: 'ADM2445',
              roomNo: 'Room 108',
              avatarUrl: 'https://i.pravatar.cc/150?img=8',
              stripColor: AppColors.tertiaryContainer,
            ),
            const SizedBox(height: 32),

            // Group C
            _buildGroupHeader('C'),
            const SizedBox(height: 16),
            _buildStudentCard(
              name: 'Cathy Richards',
              adminNo: 'ADM2489',
              roomNo: 'Room 301',
              avatarUrl: 'https://i.pravatar.cc/150?img=9',
              stripColor: AppColors.secondary,
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Slightly rounded square matching HTML
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String letter) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              letter,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onPrimaryFixed,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Students',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard({
    required String name,
    required String adminNo,
    required String roomNo,
    required String avatarUrl,
    required Color stripColor,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color strip
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),

            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surfaceContainerHigh, width: 4),
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildInfoChip(Icons.badge, adminNo, AppColors.surfaceContainer, AppColors.onSurfaceVariant),
                              _buildInfoChip(Icons.meeting_room, roomNo, AppColors.secondaryContainer.withOpacity(0.3), AppColors.onSecondaryContainer),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Call Button
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: const Icon(Icons.call, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}