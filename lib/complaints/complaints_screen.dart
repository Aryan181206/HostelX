import 'dart:ui';
import 'package:amber_hackathon/complaints/new_complaints_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  // 🔹 Dummy Data for Active Complaints (Added 6 to test the >5 logic)
  static final List<Map<String, dynamic>> activeComplaints = [
    {
      'title': 'Plumbing: Leakage in Block B',
      'status': 'In Progress',
      'date': 'Oct 24, 2023',
      'detailIcon': Icons.warning_amber_rounded,
      'detailText': 'High Priority',
      'borderColor': AppColors.tertiary,
      'statusColor': AppColors.onTertiaryFixed,
      'statusBgColor': AppColors.tertiaryFixed,
    },
    {
      'title': 'Wifi Connectivity Issues',
      'status': 'Assigned',
      'date': 'Oct 26, 2023',
      'detailIcon': Icons.router,
      'detailText': 'Room 402',
      'borderColor': AppColors.primary,
      'statusColor': AppColors.primary,
      'statusBgColor': AppColors.primaryFixed,
    },
    {
      'title': 'Broken Window in Common Room',
      'status': 'Pending',
      'date': 'Oct 27, 2023',
      'detailIcon': Icons.broken_image,
      'detailText': 'Block A',
      'borderColor': Colors.orange,
      'statusColor': Colors.orange,
      'statusBgColor': Colors.orange.withOpacity(0.2),
    },
    {
      'title': 'Elevator Malfunction',
      'status': 'In Progress',
      'date': 'Oct 28, 2023',
      'detailIcon': Icons.elevator,
      'detailText': 'Block C',
      'borderColor': AppColors.tertiary,
      'statusColor': AppColors.onTertiaryFixed,
      'statusBgColor': AppColors.tertiaryFixed,
    },
    {
      'title': 'Heater Not Working',
      'status': 'Pending',
      'date': 'Oct 29, 2023',
      'detailIcon': Icons.thermostat,
      'detailText': 'Room 105',
      'borderColor': Colors.orange,
      'statusColor': Colors.orange,
      'statusBgColor': Colors.orange.withOpacity(0.2),
    },
    {
      'title': 'Washing Machine Error',
      'status': 'Assigned',
      'date': 'Oct 30, 2023',
      'detailIcon': Icons.local_laundry_service,
      'detailText': 'Laundry Room 2',
      'borderColor': AppColors.primary,
      'statusColor': AppColors.primary,
      'statusBgColor': AppColors.primaryFixed,
    },
  ];

  // 🔹 Dummy Data for History/Archive
  static final List<Map<String, dynamic>> pastComplaints = [
    {
      'icon': Icons.restaurant,
      'title': 'Mess Quality Feedback',
      'subtitle': 'Resolved • Sep 12',
      'iconBgColor': AppColors.secondaryContainer,
      'iconColor': AppColors.secondary,
      'trailingIcon': Icons.check_circle,
      'trailingColor': AppColors.secondary,
    },
    {
      'icon': Icons.ac_unit,
      'title': 'AC Maintenance',
      'subtitle': 'Closed • Aug 30',
      'iconBgColor': AppColors.surfaceContainerHigh,
      'iconColor': AppColors.onSurfaceVariant,
      'trailingIcon': Icons.task_alt,
      'trailingColor': AppColors.outline,
    },
    {
      'icon': Icons.bolt,
      'title': 'Light Bulb Replacement',
      'subtitle': 'Closed • Aug 15',
      'iconBgColor': AppColors.surfaceContainerHigh,
      'iconColor': AppColors.onSurfaceVariant,
      'trailingIcon': Icons.task_alt,
      'trailingColor': AppColors.outline,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Determine how many active complaints to show inline
    final displayActiveCount = activeComplaints.length > 5 ? 5 : activeComplaints.length;
    final displayedActiveComplaints = activeComplaints.sublist(0, displayActiveCount);
    final hasMoreActive = activeComplaints.length > 5;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUPPORT HUB',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary.withOpacity(0.7),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complaints',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),

            _buildNewComplaintCTA(context),
            const SizedBox(height: 40),

            _buildSectionHeader('Active Complaints', badgeText: '${activeComplaints.length} Pending'),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: hasMoreActive ? () => _showAllActiveComplaints(context) : null,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ...displayedActiveComplaints.map((comp) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildActiveComplaintCard(
                          title: comp['title'],
                          status: comp['status'],
                          date: comp['date'],
                          detailIcon: comp['detailIcon'],
                          detailText: comp['detailText'],
                          borderColor: comp['borderColor'],
                          statusColor: comp['statusColor'],
                          statusBgColor: comp['statusBgColor'],
                        ),
                      );
                    }).toList(),

                    if (hasMoreActive)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '+ ${activeComplaints.length - 5} more active complaints. Tap to view all.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            Text(
              'History',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: pastComplaints.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var comp = entry.value;
                  return Column(
                    children: [
                      _buildHistoryItem(
                        icon: comp['icon'],
                        title: comp['title'],
                        subtitle: comp['subtitle'],
                        iconBgColor: comp['iconBgColor'],
                        iconColor: comp['iconColor'],
                        trailingIcon: comp['trailingIcon'],
                        trailingColor: comp['trailingColor'],
                      ),
                      if (idx != pastComplaints.length - 1)
                        Divider(color: AppColors.outlineVariant.withOpacity(0.2), height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),

            // View Archive Button
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => _showFullArchive(context),
                child: Text(
                  'View Full Archive',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showAllActiveComplaints(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  _buildSectionHeader('All Active Complaints', badgeText: '${activeComplaints.length} Total'),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: activeComplaints.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        var comp = activeComplaints[index];
                        return _buildActiveComplaintCard(
                          title: comp['title'],
                          status: comp['status'],
                          date: comp['date'],
                          detailIcon: comp['detailIcon'],
                          detailText: comp['detailText'],
                          borderColor: comp['borderColor'],
                          statusColor: comp['statusColor'],
                          statusBgColor: comp['statusBgColor'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFullArchive(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  Text('Full Archive', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: pastComplaints.length, // Can add more dummy items to this list to see scrolling
                      separatorBuilder: (_, __) => Divider(color: AppColors.outlineVariant.withOpacity(0.2), height: 1),
                      itemBuilder: (context, index) {
                        var comp = pastComplaints[index];
                        return _buildHistoryItem(
                          icon: comp['icon'],
                          title: comp['title'],
                          subtitle: comp['subtitle'],
                          iconBgColor: comp['iconBgColor'],
                          iconColor: comp['iconColor'],
                          trailingIcon: comp['trailingIcon'],
                          trailingColor: comp['trailingColor'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildNewComplaintCTA(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const NewComplaintBottomSheet(),
        );
      },
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Abstract Glow Effect
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Encountered an issue?',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Log a new ticket for quick resolution.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: const Icon(Icons.add, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? badgeText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        if (badgeText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveComplaintCard({
    required String title,
    required String status,
    required String date,
    required IconData detailIcon,
    required String detailText,
    required Color borderColor,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(detailIcon, size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  detailText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required IconData trailingIcon,
    required Color trailingColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(trailingIcon, color: trailingColor),
        ],
      ),
    );
  }
}