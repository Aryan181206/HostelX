import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widget/app_theme.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pinned Section
            _buildSectionLabel('PINNED'),
            const SizedBox(height: 16),
            _buildPinnedNoticeCard(),
            const SizedBox(height: 32),

            // Recent Updates Section
            _buildSectionLabel('RECENT UPDATES'),
            const SizedBox(height: 16),

            // Maintenance Notice
            _buildStandardNoticeCard(
              category: 'Maintenance',
              date: 'Oct 23, 2024',
              title: 'Water Tank Cleaning',
              description: 'Scheduled cleaning for the overhead tanks will take place this Saturday between 10:00 AM and 2:00 PM. Expect water interruption.',
              categoryColor: AppColors.tertiary,
              borderColor: AppColors.tertiaryContainer,
              bgColor: AppColors.surfaceContainerLow,
              icon: Icons.warning_rounded,
            ),
            const SizedBox(height: 16),

            // Events Notice
            _buildStandardNoticeCard(
              category: 'Events',
              date: 'Oct 20, 2024',
              title: 'Holiday Announcement',
              description: 'The management office will remain closed on the occasion of Diwali from Nov 10th to Nov 15th. Emergency contacts available.',
              categoryColor: AppColors.secondary,
              borderColor: Colors.transparent,
            ),
            const SizedBox(height: 16),

            // General Notice
            _buildStandardNoticeCard(
              category: 'General',
              date: 'Oct 18, 2024',
              title: 'New Menu Launch',
              description: "Check out the revised mess menu for the upcoming month. We've added more protein-rich options based on student feedback.",
              categoryColor: AppColors.onSurfaceVariant,
              borderColor: Colors.transparent,
            ),
            const SizedBox(height: 16),

            // Facility Notice
            _buildStandardNoticeCard(
              category: 'Facility',
              date: 'Oct 15, 2024',
              title: 'Wi-Fi Upgrade',
              description: 'Router maintenance completed in Wing B. Students can now experience higher bandwidth speeds in common areas.',
              categoryColor: AppColors.onSurfaceVariant,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildPinnedNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Important',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimaryFixedVariant,
                  ),
                ),
              ),
              Text(
                'Oct 24, 2024',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Late Entry Policy Update',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Effective immediately, the main gate will be closed at 10:30 PM. Any late entry requests must be submitted through the app at least 2 hours in advance.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'READ FULL NOTICE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStandardNoticeCard({
    required String category,
    required String date,
    required String title,
    required String description,
    required Color categoryColor,
    required Color borderColor,
    Color bgColor = AppColors.surfaceContainerLowest,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: borderColor, width: borderColor == Colors.transparent ? 0 : 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: categoryColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    category.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

}