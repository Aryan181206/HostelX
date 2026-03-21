import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.outline),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.5),
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
                    backgroundColor: AppColors.surfaceContainerHigh.withOpacity(0.5),
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

                  // Upload Image Section
                  _buildImageUploadArea(),
                  const SizedBox(height: 32),

                  // Inputs Section
                  _buildInputLabel('Item Name'),
                  _buildTextField(
                    hintText: 'e.g. Silver MacBook Pro 14',
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel('Description'),
                  _buildTextField(
                    hintText: 'Describe the item, including any identifying marks or features...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel('Last Seen Location'),
                  _buildTextField(
                    hintText: 'e.g. Common Area, Room 302',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel('Date'),
                  _buildTextField(
                    hintText: 'Select Date', // Using hint text for date picker visual
                    icon: Icons.calendar_today_outlined,
                    isReadOnly: true,
                    onTap: () {
                      // Handle date picker
                    },
                  ),
                  const SizedBox(height: 32),

                  // Contact Information Header
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.primaryContainer, width: 4)),
                    ),
                    child: Text(
                      'Contact Information',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF312E81), // indigo-900
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel('Phone Number'),
                  _buildTextField(
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel('Room / Bed No.'),
                  _buildTextField(
                    hintText: 'e.g. 402-B',
                    icon: Icons.bed_outlined,
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
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
                      onPressed: () {
                        // Handle submission
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
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
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Disclaimer text
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
                onTap: () => setState(() => _isLost = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isLost ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _isLost
                        ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
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
                onTap: () => setState(() => _isLost = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_isLost ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: !_isLost
                        ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
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
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: 200, // h-56 equivalent
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryContainer.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid, // Note: Use package 'dotted_border' if you want literal dashes
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF), // indigo-50
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryContainer, size: 32),
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
              'Drag & drop or click to browse',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.outline,
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
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
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
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}