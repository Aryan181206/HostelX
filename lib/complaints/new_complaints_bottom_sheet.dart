import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/app_theme.dart';
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
  State<NewComplaintBottomSheet> createState() => _NewComplaintBottomSheetState();
}

class _NewComplaintBottomSheetState extends State<NewComplaintBottomSheet> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Ensures the sheet moves up when the keyboard appears
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9, // max-h-[795px] equivalent
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle (Mobile only indicator)
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

          // Sticky Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.15)),
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

          // Scrollable Form Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown: Complaint Type
                  _buildLabel('Complaint Type'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text(
                      'Select a category',
                      style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
                    ),
                    icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
                    dropdownColor: AppColors.surfaceContainerLowest,
                    style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 16),
                    decoration: _inputDecoration(),
                    items: const [
                      DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                      DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
                      DropdownMenuItem(value: 'electrical', child: Text('Electrical')),
                      DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Text Area: Description
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 16),
                    decoration: _inputDecoration().copyWith(
                      hintText: 'Briefly describe the issue...',
                      hintStyle: GoogleFonts.inter(color: AppColors.outline),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload Image Area
                  _buildLabel('Attachment (Optional)'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      // Handle file upload
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Upload an image',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PNG, JPG up to 5MB',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Submit Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.15)),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Submit Complaint',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
    );
  }

  // Extracted input decoration to match your Tailwind CSS focus states
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
  }
}