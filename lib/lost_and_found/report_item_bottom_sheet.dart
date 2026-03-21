import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:amber_hackathon/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showReportItemSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ReportItemBottomSheet(),
  );
}

class ReportItemBottomSheet extends StatefulWidget {
  const ReportItemBottomSheet({super.key});

  @override
  State<ReportItemBottomSheet> createState() => _ReportItemBottomSheetState();
}

class _ReportItemBottomSheetState extends State<ReportItemBottomSheet> {
  bool _isLost = true;
  bool _isSubmitting = false;

  File? _selectedImage;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  final ImagePicker _picker = ImagePicker();



  static const String _cloudName = 'doturqykw';
  static const String _uploadPreset = 'hostelx';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image pick failed: $e')),
      );
    }
  }

  Future<void> _showImageSourceSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final yyyy = picked.year.toString().padLeft(4, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');

      setState(() {
        _dateController.text = '$yyyy-$mm-$dd';
      });
    }
  }

  Future<String> _uploadImageToCloudinary(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: $responseBody');
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    return data['secure_url'] as String;
  }

  Future<void> _submitData() async {
    final title = _titleController.text.trim();
    final description = _descController.text.trim();
    final location = _locationController.text.trim();
    final date = _dateController.text.trim();
    final phone = _phoneController.text.trim();
    final room = _roomController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        location.isEmpty ||
        date.isEmpty ||
        phone.isEmpty ||
        room.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload one item image')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final imageUrl = await _uploadImageToCloudinary(_selectedImage!);

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('lost_found_items').add({
        'title': title,
        'description': description,
        'location': location,
        'date': date,
        'phone': phone,
        'room': room,
        'status': _isLost ? 'Lost' : 'Found',
        'isUrgent': false,
        'imageUrl': imageUrl,
        'avatarUrl': user?.photoURL ??
            'https://ui-avatars.com/api/?name=User&background=random&color=fff',
        'userId': user?.uid ?? '',
        'userName': user?.displayName ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item reported successfully ✅')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.outline),
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor:
                    AppColors.surfaceContainerHigh.withOpacity(0.5),
                  ),
                ),
                Text(
                  'Report Item',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, color: AppColors.primary),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor:
                    AppColors.surfaceContainerHigh.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeToggle(),
                  const SizedBox(height: 40),
                  _buildImageUploadArea(),
                  const SizedBox(height: 32),
                  _buildInputLabel('Item Name'),
                  _buildTextField(
                    hintText: 'e.g. Silver MacBook Pro 14',
                    controller: _titleController,
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Description'),
                  _buildTextField(
                    hintText:
                    'Describe the item, including any identifying marks or features...',
                    controller: _descController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Last Seen Location'),
                  _buildTextField(
                    hintText: 'e.g. Common Area, Room 302',
                    controller: _locationController,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Date'),
                  _buildTextField(
                    hintText: 'Select Date',
                    controller: _dateController,
                    icon: Icons.calendar_today_outlined,
                    isReadOnly: true,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppColors.primaryContainer,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      'Contact Information',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF312E81),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Phone Number'),
                  _buildTextField(
                    hintText: '+1 (555) 000-0000',
                    controller: _phoneController,
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('Room / Bed No.'),
                  _buildTextField(
                    hintText: 'e.g. 402-B',
                    controller: _roomController,
                    icon: Icons.bed_outlined,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryContainer],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit Report',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'By submitting, you agree to allow HostelX to share this information within the community Lost & Found registry.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.outline,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _isSubmitting ? null : () => setState(() => _isLost = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isLost ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _isLost
                        ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      'Lost',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _isLost ? Colors.white : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () => setState(() => _isLost = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_isLost ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: !_isLost
                        ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      'Found',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: !_isLost ? Colors.white : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadArea() {
    return InkWell(
      onTap: _isSubmitting ? null : _showImageSourceSheet,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryContainer.withOpacity(0.5),
            width: 2,
          ),
          image: _selectedImage != null
              ? DecorationImage(
            image: FileImage(_selectedImage!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.primaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upload Item Photos',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to choose camera or gallery',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.outline,
              ),
            ),
          ],
        )
            : Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () => setState(() => _selectedImage = null),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: AppColors.outlineVariant),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.outline) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 16),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
      ),
    );
  }
}