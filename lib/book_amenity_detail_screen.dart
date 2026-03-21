import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';

class BookAmenityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> amenityData;
  final String amenityId;
  final String currentUid;

  const BookAmenityDetailScreen({
    super.key,
    required this.amenityData,
    required this.amenityId,
    required this.currentUid,
  });

  @override
  State<BookAmenityDetailScreen> createState() => _BookAmenityDetailScreenState();
}

class _BookAmenityDetailScreenState extends State<BookAmenityDetailScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedDurationIndex = 0;
  bool _isSubmitting = false;

  final List<String> _days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  List<dynamic> _dates = [];
  List<dynamic> _timeSlots = [];
  List<dynamic> _durations = [];

  @override
  void initState() {
    super.initState();
    _dates = widget.amenityData['dates'] ?? ['1'];
    _timeSlots = widget.amenityData['timeSlots'] ?? [];
    _durations = widget.amenityData['durations'] ?? [60];
  }

  Future<void> _submitBookingRequest() async {
    if (_selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'uid': widget.currentUid, // Saving the admission/roll number explicitly as requested!
        'userId': widget.currentUid, // (Optional fallback key for ease of use)
        'amenityId': widget.amenityId,
        'amenityTitle': widget.amenityData['title'],
        'time': 'Date: ${_dates[_selectedDateIndex]} • ${_timeSlots[_selectedTimeIndex]}',
        'duration': _durations[_selectedDurationIndex],
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking request sent for approval!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => _isSubmitting = false);
    }
  }

  // ... The rest of the BookAmenityDetailScreen methods remain exactly the same
  // as the previous response (_buildHeroSection, _buildDescription, _buildDateSelector,
  // _buildTimeSlots, _buildDurationSelector, _buildBottomActionBar, etc.)

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
                      widget.amenityData['title'],
                      style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
              ),
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildTimeSlots(),
              const SizedBox(height: 24),
              _buildDurationSelector(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(widget.amenityData['imageUrl']),
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
              widget.amenityData['title'],
              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
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
          Text('Description', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            widget.amenityData['description'] ?? 'No description available for this amenity.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
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
            children: List.generate(_dates.length > 7 ? 7 : _dates.length, (index) {
              bool isSelected = _selectedDateIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _dates[index].toString(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedTimeIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedTimeIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _timeSlots[index],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
          ...List.generate(_durations.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDurationRadio(index: index, label: '${_durations[index]} Minutes'),
            );
          }),
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

  Widget _buildBottomActionBar() {
    String selectedSlotText = _selectedTimeIndex != -1
        ? 'Date: ${_dates[_selectedDateIndex]}, ${_timeSlots[_selectedTimeIndex]}'
        : 'Select a slot';

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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SELECTED SLOT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(selectedSlotText, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBookingRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Request', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.send, color: Colors.white, size: 18),
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