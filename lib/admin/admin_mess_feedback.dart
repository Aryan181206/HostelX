import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminMessFeedbackScreen extends StatelessWidget {
  const AdminMessFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4F46E5)), // indigo-600
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
              'Mess Feedback',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Monitor student reviews and ratings',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.onSurfaceVariant),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section (Horizontal Scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildSummaryCard(
                    title: 'Avg. Rating',
                    value: '4.2',
                    icon: Icons.star,
                    iconColor: AppColors.secondary,
                    iconBgColor: AppColors.secondaryContainer.withOpacity(0.3),
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Total Reviews',
                    value: '48',
                    icon: Icons.reviews,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primaryContainer.withOpacity(0.1),
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Positive Trend',
                    value: '+12%',
                    icon: Icons.trending_up,
                    iconColor: AppColors.tertiary,
                    iconBgColor: AppColors.tertiaryFixed.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Filters Section (Horizontal Scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildFilterChip('All', isActive: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('High Rating'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Low Rating'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Recent'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Feedback List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildFeedbackCard(
                    userId: 'ADM2401',
                    date: '24 Oct, 01:20 PM',
                    rating: '4.5',
                    review: 'The lunch was excellent today, but the breakfast was a bit cold. Overall great quality of service!',
                    avatarUrl: 'https://i.pravatar.cc/150?img=19',
                    themeColor: AppColors.secondary,
                    badgeBgColor: AppColors.secondaryContainer.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  _buildFeedbackCard(
                    userId: 'ADM2455',
                    date: '23 Oct, 08:45 AM',
                    rating: '3.0',
                    review: 'The variety in the menu is decreasing. We need more vegetarian options for dinner.',
                    avatarUrl: 'https://i.pravatar.cc/150?img=20',
                    themeColor: AppColors.tertiary,
                    badgeBgColor: AppColors.tertiaryFixed.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  _buildFeedbackCard(
                    userId: 'ADM2389',
                    date: '22 Oct, 09:15 PM',
                    rating: '1.5',
                    review: 'Hygiene standards in the kitchen seem to be slipping. Found plastic in the dal today. Immediate action required.',
                    avatarUrl: 'https://i.pravatar.cc/150?img=21',
                    themeColor: AppColors.error,
                    badgeBgColor: AppColors.errorContainer.withOpacity(0.4),
                    isError: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFeedbackCard(
                    userId: 'ADM2502',
                    date: '22 Oct, 02:30 PM',
                    rating: '5.0',
                    review: 'Special Sunday lunch was absolutely delicious! The paneer butter masala was restaurant quality.',
                    avatarUrl: 'https://i.pravatar.cc/150?img=22',
                    themeColor: AppColors.secondary,
                    badgeBgColor: AppColors.secondaryContainer.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isActive
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({
    required String userId,
    required String date,
    required String rating,
    required String review,
    required String avatarUrl,
    required Color themeColor,
    required Color badgeBgColor,
    bool isError = false,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Color Ribbon
            Container(
              width: 4,
              color: themeColor,
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(avatarUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userId,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  date,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: themeColor.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                rating,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isError ? AppColors.onErrorContainer : themeColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: isError ? AppColors.onErrorContainer : themeColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      review,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
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
}