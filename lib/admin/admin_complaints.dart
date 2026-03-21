import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminComplaintsScreen extends StatelessWidget {
  const AdminComplaintsScreen({super.key});

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
              'Complaints Admin',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4338CA), // Indigo-700
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Track and manage student issues',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Color(0xFF4F46E5)),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.6, // Adjust ratio for mobile card shape
              children: [
                _buildStatCard(
                  title: 'Total',
                  value: '42',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.primary,
                ),
                _buildStatCard(
                  title: 'Pending',
                  value: '12',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.error,
                ),
                _buildStatCard(
                  title: 'In Progress',
                  value: '08',
                  icon: Icons.build_outlined,
                  color: AppColors.tertiaryContainer,
                ),
                _buildStatCard(
                  title: 'Resolved',
                  value: '22',
                  icon: Icons.check_circle_outline,
                  color: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Filter Chips (Horizontal Scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildFilterChip('All', isActive: true),
                  const SizedBox(width: 12),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 12),
                  _buildFilterChip('In Progress'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Resolved'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Complaint List
            _buildComplaintCard(
              title: 'Electrical Issue',
              status: 'Pending',
              reporter: 'ADM1023',
              time: 'Oct 24, 10:30 AM',
              description: 'The main switchboard in Room 302 is sparking whenever multiple appliances are connected. Needs urgent inspection.',
              imageUrl: 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?q=80&w=200&auto=format&fit=crop', // Generic electrical outlet
              icon: Icons.bolt,
              themeColor: AppColors.error,
              themeBgColor: AppColors.errorContainer,
              onThemeColor: AppColors.onErrorContainer,
              actions: [
                _buildActionButton('Mark In Progress', AppColors.primary),
                const SizedBox(width: 12),
                _buildActionButton('Resolve', AppColors.secondary),
              ],
            ),
            const SizedBox(height: 20),

            _buildComplaintCard(
              title: 'Plumbing Leak',
              status: 'In Progress',
              reporter: 'ADM1288',
              time: 'Oct 23, 04:15 PM',
              description: 'Water leakage from the ceiling in the common bathroom area on the 2nd floor. Plumber notified and on the way.',
              imageUrl: 'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?q=80&w=200&auto=format&fit=crop', // Generic pipe leak
              icon: Icons.water_drop_outlined,
              themeColor: AppColors.tertiaryContainer,
              themeBgColor: AppColors.tertiaryContainer.withOpacity(0.2),
              onThemeColor: AppColors.tertiaryContainer,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'IN PROGRESS...',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildActionButton('Resolve Now', AppColors.secondary),
              ],
            ),
            const SizedBox(height: 20),

            _buildComplaintCard(
              title: 'Furniture Repair',
              status: 'Resolved',
              reporter: 'ADM0992',
              time: 'Oct 22, 11:00 AM',
              description: 'Study desk leg was broken. Carpenter has replaced the leg and reinforced the structure. Checked by warden.',
              imageUrl: 'https://images.unsplash.com/photo-1518455027359-f3f8164d1151?q=80&w=200&auto=format&fit=crop', // Generic desk
              icon: Icons.build_outlined,
              themeColor: AppColors.secondary,
              themeBgColor: AppColors.secondaryContainer.withOpacity(0.3),
              onThemeColor: AppColors.onSecondaryContainer,
              actions: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: AppColors.secondary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'CLOSED ON OCT 23',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.outline,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1.0,
                ),
              ),
              Icon(icon, color: color.withOpacity(0.3), size: 28),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isActive
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
            : [],
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildComplaintCard({
    required String title,
    required String status,
    required String reporter,
    required String time,
    required String description,
    required String imageUrl,
    required IconData icon,
    required Color themeColor,
    required Color themeBgColor,
    required Color onThemeColor,
    required List<Widget> actions,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: themeColor, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon, Title, Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: onThemeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: onThemeColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Meta Info: Reporter & Time
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      reporter,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Body: Text and Image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Divider
            const Divider(height: 1, color: AppColors.surfaceContainerHigh),
            const SizedBox(height: 16),

            // Actions
            Row(children: actions),
          ],
        ),
      ),
    );
  }

  // Helper for the secondary buttons
  Widget _buildActionButton(String label, Color textColor) {
    return Expanded(
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}