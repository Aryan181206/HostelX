import 'dart:ui';

import 'package:amber_hackathon/book_amenity_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AmenitiesListScreen extends StatelessWidget {
  const AmenitiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Uses HomeWrapper's background
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for amenities...',
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

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', isActive: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Available'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Booked'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Popular'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Available Today
            Text(
              'Available Today',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            _buildAmenityCard(
              context,
              title: 'Fitness Center',
              subtitle: '4 slots available for the next hour',
              imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800&auto=format&fit=crop',
              tagText: 'Available',
              tagColor: AppColors.secondary,
              tagBg: AppColors.secondaryContainer,
              tagTextColor: AppColors.onSecondaryContainer,
            ),
            const SizedBox(height: 16),
            _buildAmenityCard(
              context,
              title: 'Executive Laundry',
              subtitle: 'Next slot: 4:30 PM (20 mins away)',
              imageUrl: 'https://images.unsplash.com/photo-1517677129300-07b130802f46?q=80&w=800&auto=format&fit=crop',
              tagText: 'Limited',
              tagColor: AppColors.tertiaryFixed,
              tagBg: AppColors.tertiaryContainer,
              tagTextColor: AppColors.onTertiaryContainer,
            ),
            const SizedBox(height: 32),

            // My Bookings Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Bookings',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  'View History',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal Bookings List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildBookingCard(
                    title: 'Private Cinema',
                    time: 'Today • 7:00 PM - 9:00 PM',
                    status: 'Confirmed',
                    icon: Icons.event_available,
                    bgColor: AppColors.primaryContainer,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  _buildBookingCard(
                    title: 'Music Studio',
                    time: 'Tomorrow • 10:00 AM',
                    status: 'Scheduled',
                    icon: Icons.local_library,
                    bgColor: AppColors.surfaceContainerHigh,
                    textColor: AppColors.onSurface,
                    statusColor: AppColors.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? Colors.white : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildAmenityCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String imageUrl,
        required String tagText,
        required Color tagColor,
        required Color tagBg,
        required Color tagTextColor,
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
      child: Column(
        children: [
          // Image Header
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned(
                  top: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        color: tagBg.withOpacity(0.9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                              tagText,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: tagTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content & Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Expanded to prevent overflow if title is too long
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Book Now Button pushing to the detail screen
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookAmenityDetailScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text('Book Now', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required String title,
    required String time,
    required String status,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    Color? statusColor,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: textColor, size: 20),
              ),
              Text(
                status.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor ?? textColor.withOpacity(0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(time, style: GoogleFonts.inter(fontSize: 12, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}