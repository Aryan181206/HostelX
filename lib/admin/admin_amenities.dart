import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminAmenitiesScreen extends StatefulWidget {
  const AdminAmenitiesScreen({super.key});

  @override
  State<AdminAmenitiesScreen> createState() => _AdminAmenitiesScreenState();
}

class _AdminAmenitiesScreenState extends State<AdminAmenitiesScreen> {
  int _activeTabIndex = 0; 
  bool _isActiveAmenity = true;

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
          'Amenities Management',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4338CA), // Indigo-700
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation Tabs (Segmented Control)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Amenities', 0)),
                  Expanded(child: _buildTabButton('Requests', 1)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dynamic Content based on selected tab
            _activeTabIndex == 0
                ? _buildRegisterAmenitySection()
                : _buildRequestsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.primary : AppColors.outline,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION 1: AMENITIES (REGISTER FORM)
  // ==========================================
  Widget _buildRegisterAmenitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Register New Amenity',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(
                    'NEW ENTRY',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.0),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Form Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUnderlineInput('Amenity Name', 'e.g. Study Hall A'),
              const SizedBox(height: 24),
              _buildUnderlineInput('Description', 'Describe the facility...', maxLines: 2),
              const SizedBox(height: 24),

              // Image Upload Placeholder
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant, width: 2), // Dashed in HTML, solid here for simplicity
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined, color: AppColors.outline, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Upload Facility Photo',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.outline),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Grid for Duration and Date
              Row(
                children: [
                  Expanded(
                    child: _buildUnderlineDropdown('Duration', '60 Mins', ['60 Mins', '90 Mins', '120 Mins']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUnderlineInput('Available Date', 'Oct 24, 2023', icon: Icons.calendar_today, isReadOnly: true),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Time Slots Chips
              Text(
                'AVAILABLE SLOTS',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSlotChip('10:00 AM', isActive: true),
                  _buildSlotChip('11:00 AM'),
                  _buildSlotChip('12:00 PM'),
                  _buildSlotChip('01:00 PM'),
                  _buildSlotChip('02:00 PM'),
                ],
              ),
              const SizedBox(height: 24),

              // Active Toggle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.surfaceContainer, width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set as Active',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    Switch(
                      value: _isActiveAmenity,
                      onChanged: (val) => setState(() => _isActiveAmenity = val),
                      activeColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'ADD AMENITY',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnderlineInput(String label, String hint, {int maxLines = 1, IconData? icon, bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0),
        ),
        TextFormField(
          maxLines: maxLines,
          readOnly: isReadOnly,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
            suffixIcon: icon != null ? Icon(icon, color: AppColors.outline, size: 20) : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceContainerHigh, width: 2)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildUnderlineDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0),
        ),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.outline, size: 20),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceContainerHigh, width: 2)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2)),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildSlotChip(String time, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
      ),
      child: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  // ==========================================
  // SECTION 2: REQUESTS LIST
  // ==========================================
  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Requests',
              style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface),
            ),
            Text(
              'VIEW ALL',
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildRequestCard(
          title: 'Gym Access',
          id: 'ADM1056',
          status: 'Pending',
          date: 'Today',
          time: '10:00 AM - 11:00 AM',
          statusColor: AppColors.tertiaryFixedDim,
          statusBg: AppColors.tertiaryFixed,
          statusTextColor: AppColors.onTertiaryFixedVariant,
          showActions: true,
        ),
        const SizedBox(height: 16),
        _buildRequestCard(
          title: 'Library Pod 04',
          id: 'ADM1089',
          status: 'Approved',
          date: 'Tomorrow',
          time: '02:00 PM',
          statusColor: AppColors.secondary,
          statusBg: AppColors.secondaryContainer,
          statusTextColor: AppColors.onSecondaryContainer,
          opacity: 0.8,
        ),
        const SizedBox(height: 16),
        _buildRequestCard(
          title: 'Music Room',
          id: 'ADM1022',
          status: 'Rejected',
          date: 'Oct 25',
          time: '04:00 PM',
          statusColor: AppColors.error,
          statusBg: AppColors.errorContainer,
          statusTextColor: AppColors.onErrorContainer,
          opacity: 0.8,
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String id,
    required String status,
    required String date,
    required String time,
    required Color statusColor,
    required Color statusBg,
    required Color statusTextColor,
    bool showActions = false,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: $id',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: statusTextColor, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16, color: AppColors.outline),
                    const SizedBox(width: 6),
                    Text(date, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.outline),
                    const SizedBox(width: 6),
                    Text(time, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle, size: 16, color: Colors.white),
                      label: Text('Approve', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel, size: 16, color: AppColors.error),
                      label: Text('Reject', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}