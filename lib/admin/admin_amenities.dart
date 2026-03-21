import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../app_theme.dart';

class AdminAmenitiesScreen extends StatefulWidget {
  const AdminAmenitiesScreen({super.key});

  @override
  State<AdminAmenitiesScreen> createState() => _AdminAmenitiesScreenState();
}

class _AdminAmenitiesScreenState extends State<AdminAmenitiesScreen> {
  int _activeTabIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _datesController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(text: '60');

  File? _selectedImage;
  bool _isActiveAmenity = true;
  bool _isSubmitting = false;

  final List<String> _availableTimeSlots = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '01:00 PM', '02:00 PM', '04:00 PM', '06:00 PM'
  ];
  final List<String> _selectedTimeSlots = [];

  final String cloudName = 'doturqykw';
  final String uploadPreset = 'hostelx';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);
        return jsonMap['secure_url'];
      } else {
        debugPrint('Cloudinary Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Upload Error: $e');
      return null;
    }
  }

  Future<void> _submitAmenity() async {
    if (_nameController.text.isEmpty || _descController.text.isEmpty || _selectedImage == null || _selectedTimeSlots.isEmpty || _datesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and select an image & slots.')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl = await _uploadImageToCloudinary(_selectedImage!);

      if (imageUrl == null) {
        throw Exception("Image upload failed");
      }

      List<String> datesList = _datesController.text.split(',').map((e) => e.trim()).toList();
      List<int> durationsList = _durationController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 60).toList();

      await FirebaseFirestore.instance.collection('amenities').add({
        'title': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'imageUrl': imageUrl,
        'status': _isActiveAmenity ? 'Available' : 'Unavailable',
        'dates': datesList,
        'timeSlots': _selectedTimeSlots,
        'durations': durationsList,
        'timestamp': FieldValue.serverTimestamp(),
      });


      setState(() {
        _nameController.clear();
        _descController.clear();
        _datesController.clear();
        _durationController.text = '60';
        _selectedImage = null;
        _selectedTimeSlots.clear();
        _isActiveAmenity = true;
        _isSubmitting = false;
        _activeTabIndex = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amenity registered successfully!')));
      }

    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _updateRequestStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(docId).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request $newStatus')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _datesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4F46E5)),
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
            color: const Color(0xFF4338CA),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            _activeTabIndex == 0 ? _buildRegisterAmenitySection() : _buildRequestsSection(),
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
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
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

  Widget _buildRegisterAmenitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Register New Amenity',
                style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('NEW ENTRY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.0)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUnderlineInput('Amenity Name', 'e.g. Study Hall A', controller: _nameController),
              const SizedBox(height: 24),
              _buildUnderlineInput('Description', 'Describe the facility...', maxLines: 2, controller: _descController),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant, width: 2),
                    image: _selectedImage != null
                        ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined, color: AppColors.outline, size: 32),
                      const SizedBox(height: 8),
                      Text('Upload Facility Photo', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.outline)),
                    ],
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildUnderlineInput('Durations (Mins)', 'e.g. 60, 90', controller: _durationController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUnderlineInput('Available Dates', 'e.g. 28, 29, 30', icon: Icons.calendar_today, controller: _datesController),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('AVAILABLE SLOTS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTimeSlots.map((time) {
                  final isSelected = _selectedTimeSlots.contains(time);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected ? _selectedTimeSlots.remove(time) : _selectedTimeSlots.add(time);
                      });
                    },
                    child: _buildSlotChip(time, isActive: isSelected),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.surfaceContainer, width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Set as Active', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
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

              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAmenity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('ADD AMENITY', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnderlineInput(String label, String hint, {int maxLines = 1, IconData? icon, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
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

  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Recent Requests', style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            ),
            Text('VIEW ALL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0)),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No recent requests found.');
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return _buildRequestCard(
                  docId: doc.id,
                  title: data['amenityTitle'] ?? 'Unknown Amenity',
                  id: data['uid'] ?? 'UNKNOWN_USER',
                  status: data['status'] ?? 'Pending',
                  timeInfo: data['time'] ?? 'No time specified',
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String docId,
    required String title,
    required String id,
    required String status,
    required String timeInfo,
  }) {
    bool isPending = status.toLowerCase() == 'pending';
    bool isApproved = status.toLowerCase() == 'confirmed';

    Color statusColor = isPending ? AppColors.tertiaryFixedDim : (isApproved ? AppColors.secondary : AppColors.error);
    Color statusBg = isPending ? AppColors.tertiaryFixed : (isApproved ? AppColors.secondaryContainer : AppColors.errorContainer);
    Color statusTextColor = isPending ? AppColors.onTertiaryFixedVariant : (isApproved ? AppColors.onSecondaryContainer : AppColors.onErrorContainer);
    double opacity = isPending ? 1.0 : 0.8;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(height: 2),
                      Text('User ID: $id', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline, letterSpacing: 1.0)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(status.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: statusTextColor, letterSpacing: 0.5)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: AppColors.outline),
                const SizedBox(width: 6),
                Expanded(child: Text(timeInfo, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant))),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateRequestStatus(docId, 'Confirmed'),
                      icon: const Icon(Icons.check_circle, size: 16, color: Colors.white),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Approve', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateRequestStatus(docId, 'Rejected'),
                      icon: const Icon(Icons.cancel, size: 16, color: AppColors.error),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Reject', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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