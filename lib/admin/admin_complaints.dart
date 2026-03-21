import 'package:amber_hackathon/api/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Recommended for Cloudinary
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

  // --- NEW: Function to handle Status Updates ---
  Future<void> _updateStatus(Map<String, String> complaint, String newStatus) async {
    // Show a loading dialog so the admin knows it's working
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

    // Pop the loading dialog
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
      _loadComplaints(); // Refresh the list to show new data
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
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSummaryStats(),
                  const SizedBox(height: 32),
                  _buildFilterChips(),
                  const SizedBox(height: 24),
                  _buildComplaintsList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Sections ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface.withOpacity(0.9),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complaints Admin',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4338CA),
            ),
          ),
          Text(
            'Manage and track student reports',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.outline),
          ),
        ],
      ),
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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total', total.toString(), Icons.analytics_outlined, AppColors.primary),
        _buildStatCard('Pending', pending.toString(), Icons.pending_actions, AppColors.error),
        _buildStatCard('In Progress', progress.toString(), Icons.loop, Colors.orange),
        _buildStatCard('Resolved', resolved.toString(), Icons.check_circle_outline, AppColors.secondary),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'In Progress', 'Resolved'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedFilter = filter),
              selectedColor: AppColors.primary,
              labelStyle: GoogleFonts.inter(
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
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
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final complaint = _filteredComplaints[index];
        return _buildComplaintCard(complaint);
      },
    );
  }

  Widget _buildComplaintCard(Map<String, String> data) {
    final status = data['status'] ?? 'Pending';
    final type = data['complaintType'] ?? 'General';

    // Status-specific colors
    Color themeColor = status == 'Resolved'
        ? AppColors.secondary
        : (status == 'In Progress' ? Colors.orange : AppColors.error);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: themeColor, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildStatusBadge(status, themeColor),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: AppColors.outline),
                const SizedBox(width: 4),
                Text(data['admissionNo'] ?? 'N/A', style: GoogleFonts.inter(fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 14, color: AppColors.outline),
                const SizedBox(width: 4),
                Text(data['date'] ?? 'No Date', style: GoogleFonts.inter(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    data['description'] ?? 'No description provided.',
                    style: GoogleFonts.inter(fontSize: 13, height: 1.4),
                  ),
                ),
                if (data['imageUrl'] != null && data['imageUrl']!.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['imageUrl']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.2),
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // PASS THE ENTIRE DATA MAP TO THE BUTTONS
            _buildActionButtons(data),
          ],
        ),
      ),
    );
  }

  // --- NEW: Using the complaint map to trigger logic ---
  Widget _buildActionButtons(Map<String, String> complaint) {
    final status = complaint['status'] ?? 'Pending';

    if (status == 'Resolved') {
      return Center(
        child: Text(
          'RESOLVED',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              letterSpacing: 1.2),
        ),
      );
    }

    return Row(
      children: [
        if (status == 'Pending')
          Expanded(
            child: OutlinedButton(
              // Trigger Update to 'In Progress'
              onPressed: () => _updateStatus(complaint, 'In Progress'),
              child: const Text('Start Work'),
            ),
          ),
        if (status == 'Pending') const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white),
            // Trigger Update to 'Resolved'
            onPressed: () => _updateStatus(complaint, 'Resolved'),
            child: const Text('Resolve'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.outline)),
        ],
      ),
    );
  }
}