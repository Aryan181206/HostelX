import 'package:amber_hackathon/api/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import 'admin_amenities.dart';
import 'admin_announcements.dart';
import 'admin_complaints.dart';
import 'admin_mess_feedback.dart';


class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // remove back arrow
        leading: const SizedBox(width: 0,),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4338CA),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hostel Management',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage hostel operations efficiently with real-time tracking.',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 32),

            _buildAnnouncementsCard(context),
            const SizedBox(height: 20),

            _buildMessFeedbackCard(context),
            const SizedBox(height: 20),

            _buildComplaintsCard(context),
            const SizedBox(height: 20),

            _buildAmenitiesCard(context),

          ],
        ),
      ),
    );
  }

  // Common Box Decoration for the cards to keep shadows consistent
  BoxDecoration _cardDecoration({Border? border}) {
    return BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      border: border ?? Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsCard(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminAnnouncementsScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.campaign, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Announcements',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Post and manage notices for the entire hostel community.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessFeedbackCard(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminMessFeedbackScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixedDim.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.restaurant, color: AppColors.secondary, size: 32),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mess Feedback',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'View student feedback on daily meals and cafeteria services.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintsCard(BuildContext context) {
    return Container(
      decoration: _cardDecoration(
        border: const Border(left: BorderSide(color: AppColors.tertiary, width: 4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminComplaintsScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixedDim.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.report_problem, color: AppColors.tertiaryContainer, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'See Complaints',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track and resolve issues reported by residents.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenitiesCard(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminAmenitiesScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixedDim.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.event_available, color: AppColors.secondary, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Amenities',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage bookings for gym, laundry, and common rooms.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 12),

              ],
            ),
          ),
        ),
      ),
    );
  }
}