import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<AdminAnnouncementsScreen> createState() => _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  bool _isHighPriority = false;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4338CA), // Indigo-700
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Create and manage hostel notices',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Create Announcement Form
            _buildCreateAnnouncementForm(),
            const SizedBox(height: 40),

            // Section 2: Today's Announcements List
            _buildTodaysAnnouncementsHeader(),
            const SizedBox(height: 16),
            _buildImportantCard(
              title: 'Water Supply Maintenance',
              time: '10:30 AM',
              description: 'Please note that water supply will be suspended for Block B between 2 PM and 4 PM for tank cleaning...',
              badgeText: 'Important',
            ),
            const SizedBox(height: 16),
            _buildRegularCard(
              title: 'Common Room Key Collection',
              time: '09:15 AM',
              description: 'Students who requested late-night study access can collect their digital keys from the front desk.',
              badgeText: 'New',
              icon: Icons.event,
              badgeColor: AppColors.secondary,
              badgeBgColor: AppColors.secondaryContainer.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            _buildRegularCard(
              title: 'Internet Gateway Upgrade',
              time: 'Yesterday',
              description: 'The main router will be upgraded tonight at 11:59 PM. Expect brief disconnections during this time.',
              badgeText: 'High Priority',
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.tertiary,
              badgeColor: AppColors.tertiary,
              badgeBgColor: AppColors.tertiaryFixed,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAnnouncementForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_square, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'New Broadcast',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildInputLabel('Title'),
          _buildTextField(hintText: 'Enter announcement title'),
          const SizedBox(height: 16),

          _buildInputLabel('Description'),
          _buildTextField(hintText: 'Write details...', maxLines: 4),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('Date'),
                    _buildTextField(
                      hintText: 'Today, Oct 24',
                      icon: Icons.calendar_today,
                      isReadOnly: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('Priority'),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isHighPriority = false),
                            child: Container(
                              height: 56, // Match text field height
                              decoration: BoxDecoration(
                                color: !_isHighPriority ? AppColors.surfaceContainerHigh : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: !_isHighPriority ? Colors.transparent : AppColors.outlineVariant.withOpacity(0.3)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Normal',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: !_isHighPriority ? AppColors.onSurface : AppColors.outline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isHighPriority = true),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: _isHighPriority ? AppColors.tertiaryFixed.withOpacity(0.2) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isHighPriority ? AppColors.tertiaryFixed : AppColors.outlineVariant.withOpacity(0.3),
                                  width: _isHighPriority ? 2 : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'High',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _isHighPriority ? AppColors.tertiary : AppColors.outline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(
                'Post Announcement',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysAnnouncementsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Announcements",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF), // indigo-50
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '3 Recent',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4338CA), // indigo-700
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportantCard({
    required String title,
    required String time,
    required String description,
    required String badgeText,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 6, color: AppColors.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF), // indigo-50
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.campaign, color: Color(0xFF4F46E5)), // indigo-600
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badgeText.toUpperCase(),
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5), letterSpacing: 1.0),
                            ),
                          ),
                          Text(time, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.outline)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: AppColors.outline),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularCard({
    required String title,
    required String time,
    required String description,
    required String badgeText,
    required IconData icon,
    Color? iconColor,
    required Color badgeColor,
    required Color badgeBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.outlineVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        badgeText.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor, letterSpacing: 1.0),
                      ),
                    ),
                    Text(time, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.outline)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
                ),
                // Actions omitted in normal state to match HTML's group-hover visibility,
                // but since Flutter doesn't have native CSS hover easily for complex layouts,
                // we'll leave them visible or accessible via trailing. I'll include them.
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: AppColors.outline),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.outline,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    IconData? icon,
    int maxLines = 1,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      maxLines: maxLines,
      readOnly: isReadOnly,
      style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }
}