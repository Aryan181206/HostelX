import 'dart:ui';

import 'package:amber_hackathon/lost_and_found/report_item_bottom_sheet.dart';
import 'package:amber_hackathon/widget/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 8),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showReportItemSheet(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Lost & Found',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find or report lost items easily',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Filter & Search Section
            _buildSearchAndFilters(),
            const SizedBox(height: 32),

            // Tabs
            _buildTabs(),
            const SizedBox(height: 24),

            // Grid Content
            _buildItemsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: 'Search for items...',
            hintStyle: GoogleFonts.inter(color: AppColors.outline.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.search, color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filter Chips (Scrollable)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Filter Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: AppColors.onPrimary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Filter',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildFilterChip('Electronics'),
              const SizedBox(width: 8),
              _buildFilterChip('ID Cards'),
              const SizedBox(width: 8),
              _buildFilterChip('Wallets'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTab(title: 'Lost Items', index: 0),
          const SizedBox(width: 32),
          _buildTab(title: 'Found Items', index: 1),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required int index}) {
    final isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsGrid() {
    // For responsive layout, adapting HTML grid behavior into Flutter Columns for mobile
    return Column(
      children: [
        _buildItemCard(
          title: 'Student ID Card',
          imageUrl: 'https://images.unsplash.com/photo-1633265486064-086b219458ce?q=80&w=600&auto=format&fit=crop', // ID Placeholder
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          location: 'Near Central Mess Hall',
          date: 'Oct 24, 2023 • 10:30 AM',
          status: 'Lost',
          isUrgent: true,
        ),
        const SizedBox(height: 24),
        _buildItemCard(
          title: 'Black Wallet',
          imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=600&auto=format&fit=crop', // Wallet Placeholder
          avatarUrl: 'https://i.pravatar.cc/150?img=7',
          location: 'Reading Room B',
          date: 'Oct 23, 2023 • 04:15 PM',
          status: 'Lost',
        ),
        const SizedBox(height: 24),
        _buildItemCard(
          title: 'Silver Keys',
          imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?q=80&w=600&auto=format&fit=crop', // Keys Placeholder
          avatarUrl: 'https://i.pravatar.cc/150?img=9',
          location: 'Gym Area',
          date: 'Oct 22, 2023 • 08:00 AM',
          status: 'Found',
        ),
        const SizedBox(height: 24),
        _buildItemCard(
          title: 'AirPods Pro',
          imageUrl: 'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?q=80&w=600&auto=format&fit=crop', // AirPods Placeholder
          avatarUrl: 'https://i.pravatar.cc/150?img=11',
          location: 'Lobby Lounge',
          date: 'Oct 21, 2023 • 11:20 PM',
          status: 'Lost',
        ),
      ],
    );
  }

  Widget _buildItemCard({
    required String title,
    required String imageUrl,
    required String avatarUrl,
    required String location,
    required String date,
    required String status,
    bool isUrgent = false,
  }) {
    final bool isLost = status.toLowerCase() == 'lost';
    // Exact colors from your custom CSS block
    final Color ribbonColor = isLost ? const Color(0xFFFFB74D) : const Color(0xFF00BFA6);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: isUrgent ? Border.all(color: AppColors.tertiaryFixed, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left Side Status Ribbon
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: ribbonColor,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              SizedBox(
                height: 192, // h-48 equivalent
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                    if (isUrgent)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              color: AppColors.tertiaryContainer.withOpacity(0.9),
                              child: Text(
                                'URGENT',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onTertiaryContainer,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Card Details
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Footer Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          status.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLost ? AppColors.tertiary : AppColors.secondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'View Details',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}