import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../api/user_sheet_api.dart';
import '../app_theme.dart';

void showNewComplaintSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NewComplaintBottomSheet(),
  );
}

class NewComplaintBottomSheet extends StatefulWidget {
  const NewComplaintBottomSheet({super.key});

  @override
  State<NewComplaintBottomSheet> createState() =>
      _NewComplaintBottomSheetState();
}

class _NewComplaintBottomSheetState
    extends State<NewComplaintBottomSheet> {

  String? _selectedCategory;
  final TextEditingController _descriptionController =
  TextEditingController();

  bool _isLoading = false;

  File? _selectedImage;
  String imageUrl = "";

  final ImagePicker _picker = ImagePicker();

  static const String _cloudName = 'doturqykw';
  static const String _uploadPreset = 'hostelx';


  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image pick failed: $e")),
      );
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

    print("CLOUDINARY STATUS: ${response.statusCode}");
    print("CLOUDINARY RESPONSE: $responseBody");

    if (response.statusCode != 200) {
      throw Exception("Upload failed: $responseBody");
    }

    final data = jsonDecode(responseBody);
    return data['secure_url'];
  }


  Future<void> _submitComplaint() async {
    if (_selectedCategory == null ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {

      if (_selectedImage != null) {
        imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      }

      final success = await UserSheetsApi.addComplaint(
        complaintType: _selectedCategory!,
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint submitted successfully")),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Sheet API failed");
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [


          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors.outlineVariant.withOpacity(0.15)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Complaint',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.onSurfaceVariant,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLow,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),


          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildLabel('Complaint Type'),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text(
                      'Select a category',
                      style: GoogleFonts.inter(
                          color: AppColors.onSurfaceVariant),
                    ),
                    icon: const Icon(Icons.expand_more,
                        color: AppColors.onSurfaceVariant),
                    dropdownColor: AppColors.surfaceContainerLowest,
                    style: GoogleFonts.inter(
                        color: AppColors.onSurface, fontSize: 16),
                    decoration: _inputDecoration(),
                    items: const [
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                      DropdownMenuItem(value: 'Plumbing', child: Text('Plumbing')),
                      DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
                      DropdownMenuItem(value: 'Cleaning', child: Text('Cleaning')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  _buildLabel('Description'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    style: GoogleFonts.inter(
                        color: AppColors.onSurface, fontSize: 16),
                    decoration: _inputDecoration().copyWith(
                      hintText: 'Briefly describe the issue...',
                      hintStyle:
                      GoogleFonts.inter(color: AppColors.outline),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildLabel('Attachment (Optional)'),
                  const SizedBox(height: 8),

                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _selectedImage == null
                              ? Column(
                            children: [
                              const Icon(Icons.add_photo_alternate, size: 40),
                              const SizedBox(height: 12),
                              Text('Upload an image'),
                            ],
                          )
                              : Image.file(_selectedImage!, height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Complaint'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text);
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(border: InputBorder.none);
  }
}