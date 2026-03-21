import 'package:amber_hackathon/api/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  List<Map<String, String>> _allComplaints = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() => _isLoading = true);
    try {
      final data = await UserSheetsApi.getAllComplaints();
      setState(() {
        _allComplaints = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading complaints: $e')),
        );
      }
    }
  }

  // --- Logic to handle Status Updates ---
  Future<void> _updateStatus(Map<String, String> complaint, String newStatus) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      ),
    );

    final success = await UserSheetsApi.updateComplaintStatus(
      admissionNo: complaint['admissionNo'] ?? '',
      description: complaint['description'] ?? '',
      newStatus: newStatus,
    );

    if (mounted) Navigator.pop(context);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status successfully updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _loadComplaints();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Filtered list logic
  List<Map<String, String>> get _filteredComplaints {
    if (_selectedFilter == 'All') return _allComplaints;
    return _allComplaints
        .where((c) => c['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)))
          : RefreshIndicator(
        onRefresh: _loadComplaints,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryStats(),
              const SizedBox(height: 32),
              _buildFilterChips(),
              const SizedBox(height: 24),
              _buildComplaintsList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Sections ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complaints Admin',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4338CA),
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
    );
  }

  Widget _buildSummaryStats() {
    int total = _allComplaints.length;
    int pending = _allComplaints.where((c) => c['status'] == 'Pending').length;
    int progress = _allComplaints.where((c) => c['status'] == 'In Progress').length;
    int resolved = _allComplaints.where((c) => c['status'] == 'Resolved').length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          title: 'Total',
          value: total.toString(),
          icon: Icons.inventory_2_outlined,
          color: AppColors.primary,
        ),
        _buildStatCard(
          title: 'Pending',
          value: pending.toString(),
          icon: Icons.warning_amber_rounded,
          color: AppColors.error,
        ),
        _buildStatCard(
          title: 'In Progress',
          value: progress.toString(),
          icon: Icons.build_outlined,
          color: AppColors.tertiaryContainer,
        ),
        _buildStatCard(
          title: 'Resolved',
          value: resolved.toString(),
          icon: Icons.check_circle_outline,
          color: AppColors.secondary,
        ),
      ],
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

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'In Progress', 'Resolved'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: _buildFilterChip(filter, isActive: isSelected),
            ),
          );
        }).toList(),
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

  Widget _buildComplaintsList() {
    if (_filteredComplaints.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text('No complaints found.', style: GoogleFonts.inter(color: AppColors.outline)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredComplaints.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final complaint = _filteredComplaints[index];
        return _buildDynamicComplaintCard(complaint);
      },
    );
  }

  Widget _buildDynamicComplaintCard(Map<String, String> data) {
    final status = data['status'] ?? 'Pending';
    final title = data['complaintType'] ?? 'General Issue';
    final reporter = data['admissionNo'] ?? 'N/A';
    final time = data['date'] ?? 'No Date';
    final description = data['description'] ?? 'No description provided.';
    final imageUrl = data['imageUrl'];

    Color themeColor;
    Color themeBgColor;
    Color onThemeColor;
    IconData icon;

    // Map status to theme colors and icons
    if (status == 'Resolved') {
      themeColor = AppColors.secondary;
      themeBgColor = AppColors.secondaryContainer.withOpacity(0.3);
      onThemeColor = AppColors.onSecondaryContainer;
      icon = Icons.check_circle_outline;
    } else if (status == 'In Progress') {
      themeColor = AppColors.tertiaryContainer;
      themeBgColor = AppColors.tertiaryContainer.withOpacity(0.2);
      onThemeColor = AppColors.tertiaryContainer;
      icon = Icons.loop;
    } else { // Pending
      themeColor = AppColors.error;
      themeBgColor = AppColors.errorContainer;
      onThemeColor = AppColors.onErrorContainer;
      icon = Icons.report_problem_outlined;
    }

    // Dynamic Actions based on status
    List<Widget> actions = [];
    if (status == 'Resolved') {
      actions.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: AppColors.secondary, size: 16),
              const SizedBox(width: 8),
              Text(
                'RESOLVED',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.0),
              ),
            ],
          ),
        ),
      );
    } else if (status == 'In Progress') {
      actions.add(
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
      );
      actions.add(const SizedBox(width: 12));
      actions.add(_buildActionButton('Resolve Now', AppColors.secondary, () => _updateStatus(data, 'Resolved')));
    } else {
      // Pending actions
      actions.add(_buildActionButton('In Progress', AppColors.primary, () => _updateStatus(data, 'In Progress')));
      actions.add(const SizedBox(width: 12));
      actions.add(_buildActionButton('Resolve', AppColors.secondary, () => _updateStatus(data, 'Resolved')));
    }

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
            // Header
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
                if (imageUrl != null && imageUrl.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceContainerHigh.withOpacity(0.5),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.surfaceContainerHigh.withOpacity(0.3),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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

  // Helper for action buttons
  Widget _buildActionButton(String label, Color textColor, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
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