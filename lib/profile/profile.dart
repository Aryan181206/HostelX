import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: AppColors.surface.withOpacity(0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF4F46E5)), // Indigo-600 equivalent
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                ),
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4338CA), // Indigo-700
                  letterSpacing: -0.5,
                ),
              ),
              actions: const [
                // Spacer for centering title exactly as in HTML
                SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 120),
        child: Column(
          children: [
            // Profile Header Section
            _buildProfileHeader(),
            const SizedBox(height: 40),

            // Options List (Unified Fintech-style Card)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    iconBgColor: const Color(0xFFEEF2FF), // indigo-50
                    iconColor: const Color(0xFF4F46E5),   // indigo-600
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildOptionItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'My Complaints',
                    iconBgColor: const Color(0xFFF0FDFA), // teal-50
                    iconColor: AppColors.secondary,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildOptionItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    iconBgColor: const Color(0xFFF1F5F9), // slate-100
                    iconColor: AppColors.onSurfaceVariant,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildOptionItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconBgColor: AppColors.errorContainer.withOpacity(0.5),
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            // Footer Info
            const SizedBox(height: 32),
            Text(
              'App Version 2.4.0',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Avatar Background
            Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ),
            // Verified Badge
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 4),
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Yash Verma',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Roll Number: 2021CS1045',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.home_mini, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Room 214, Block B',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
    Color? textColor,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: isDestructive ? AppColors.errorContainer.withOpacity(0.1) : Colors.black.withOpacity(0.02),
        splashColor: isDestructive ? AppColors.errorContainer.withOpacity(0.2) : Colors.black.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: isDestructive ? AppColors.error.withOpacity(0.3) : AppColors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.outlineVariant.withOpacity(0.15),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home'),
              _buildNavItem(Icons.restaurant, 'Mess'),
              _buildNavItem(Icons.layers_outlined, 'Services'),
              _buildNavItem(Icons.person, 'Profile', isActive: true), // Set Profile to active
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent, // Indigo-50
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF4338CA) : const Color(0xFF94A3B8), // Indigo-700 or Slate-400
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? const Color(0xFF4338CA) : const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}