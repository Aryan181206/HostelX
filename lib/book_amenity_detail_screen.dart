import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class BookAmenityDetailScreen extends StatefulWidget {
  const BookAmenityDetailScreen({super.key});

  @override
  State<BookAmenityDetailScreen> createState() => _BookAmenityDetailScreenState();
}

class _BookAmenityDetailScreenState extends State<BookAmenityDetailScreen> {
  int _selectedDateIndex = 5;
  int _selectedTimeIndex = 2;
  int _selectedDurationIndex = 0;

  final List<String> _days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  final List<String> _dates = ['28', '29', '30', '1', '2', '3', '4'];

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '08:00 AM', 'status': 'Booked'},
    {'time': '09:30 AM', 'status': 'Booked'},
    {'time': '11:00 AM', 'status': 'Available'},
    {'time': '12:30 PM', 'status': 'Available'},
    {'time': '02:00 PM', 'status': 'Available'},
    {'time': '03:30 PM', 'status': 'Booked'},
    {'time': '05:00 PM', 'status': 'Available'},
    {'time': '06:30 PM', 'status': 'Available'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 40),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primaryContainer),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(backgroundColor: AppColors.surfaceContainerHigh),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Executive Laundry',
                      style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
              ),

              // Hero Section
              _buildHeroSection(),
              const SizedBox(height: 24),

              // Date Selector
              _buildDateSelector(),
              const SizedBox(height: 24),

              // Time Slots
              _buildTimeSlots(),
              const SizedBox(height: 24),

              // Warning
              _buildWarningBanner(),
              const SizedBox(height: 24),

              // Duration
              _buildDurationSelector(),
              const SizedBox(height: 24),

              // Booking Details
              _buildBookingDetails(),
            ],
          ),
        ),
      ),
      // Sticky Action Bar
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1517677129300-07b130802f46?q=80&w=800&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Executive Laundry Suite',
              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Date', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _days.map((day) => Expanded(child: Text(day, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline)))).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_dates.length, (index) {
              bool isSelected = _selectedDateIndex == index;
              bool isPast = index < 3;
              return Expanded(
                child: GestureDetector(
                  onTap: isPast ? null : () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _dates[index],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.onPrimary : (isPast ? AppColors.outlineVariant : AppColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Slots', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Fixed Overflow: Lowered crossAxisCount to 3 for mobile, or adjusted AspectRatio
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5, // Wider aspect ratio to fit text comfortably
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final slot = _timeSlots[index];
              final isBooked = slot['status'] == 'Booked';
              final isSelected = _selectedTimeIndex == index;

              return GestureDetector(
                onTap: isBooked ? null : () => setState(() => _selectedTimeIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isBooked ? AppColors.surfaceContainer : (isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceContainerLow),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // FittedBox prevents text overflow on very small screens
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          slot['time'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isBooked ? AppColors.outline : (isSelected ? AppColors.primary : AppColors.onSurface),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBooked ? 'Booked' : (isSelected ? 'Select' : 'Available'),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: isBooked ? AppColors.outline : (isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppColors.tertiary, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.tertiary, size: 20),
          const SizedBox(width: 12),
          // Expanded prevents text from overflowing
          Expanded(
            child: Text(
              'Peak hours detected (11:00 AM - 2:00 PM). Booking duration is limited to 90 minutes.',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.tertiary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Duration', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDurationRadio(index: 0, label: '60 Minutes'),
          const SizedBox(height: 12),
          _buildDurationRadio(index: 1, label: '90 Minutes'),
        ],
      ),
    );
  }

  Widget _buildDurationRadio({required int index, required String label}) {
    bool isSelected = _selectedDurationIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDurationIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withOpacity(0.1) : AppColors.surfaceContainerLow,
          border: Border.all(color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
            Radio<int>(
              value: index,
              groupValue: _selectedDurationIndex,
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) setState(() => _selectedDurationIndex = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: const Border(left: BorderSide(color: AppColors.secondary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Details', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDetailRow('Booked by', 'Julian Casablancas'),
          const SizedBox(height: 12),
          _buildDetailRow('Room No.', 'Suite 402 - Floor 4'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Tokens', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text('15 Tokens', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.2))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, -8))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fixed Overflow: Wrapped in Expanded to prevent text from pushing the button off-screen
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SELECTED SLOT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
                  // FittedBox prevents text wrapping awkwardly if the date is long
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Tomorrow, 11:00 AM', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Fixed Overflow: Button is now flexible and has reasonable padding
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Confirm', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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