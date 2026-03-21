import 'package:amber_hackathon/api/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

class AdminMessFeedbackScreen extends StatefulWidget {
  const AdminMessFeedbackScreen({super.key});

  @override
  State<AdminMessFeedbackScreen> createState() => _AdminMessFeedbackScreenState();
}

class _AdminMessFeedbackScreenState extends State<AdminMessFeedbackScreen> {

  String _selectedFilter = 'All';

  double _averageRating = 0.0;
  int _totalReviews = 0;

  void _calculateStats(List<Map<String, String>> data) {
    if (data.isEmpty) {
      _averageRating = 0.0;
      _totalReviews = 0;
      return;
    }

    double totalRatingSum = 0;
    for (var item in data) {
      totalRatingSum += double.tryParse(item['rating'] ?? '0') ?? 0;
    }
    _averageRating = totalRatingSum / data.length;
    _totalReviews = data.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mess Feedback',
              style: GoogleFonts.manrope(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface, letterSpacing: -0.5,
              ),
            ),
            Text('Monitor student reviews and ratings',
              style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: UserSheetsApi.getAllFeedback(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final rawList = snapshot.data ?? [];
          _calculateStats(rawList);


          List<Map<String, String>> filteredList = rawList.where((item) {
            double r = double.tryParse(item['rating'] ?? '0') ?? 0;
            if (_selectedFilter == 'High Rating') return r > 3.0;
            if (_selectedFilter == 'Low Rating') return r <= 2.0;
            return true;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.only( bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _buildSummaryCard(
                        title: 'Avg. Rating',
                        value: _averageRating.toStringAsFixed(1),
                        icon: Icons.star,
                        iconColor: AppColors.secondary,
                        iconBgColor: AppColors.secondaryContainer.withOpacity(0.3),
                      ),
                      const SizedBox(width: 16),
                      _buildSummaryCard(
                        title: 'Total Reviews',
                        value: _totalReviews.toString(),
                        icon: Icons.reviews,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.primaryContainer.withOpacity(0.1),
                      ),
                      const SizedBox(width: 16),
                      _buildSummaryCard(
                        title: 'Status',
                        value: _averageRating >= 4.0 ? 'Good' : 'Needs Work',
                        icon: Icons.trending_up,
                        iconColor: AppColors.tertiary,
                        iconBgColor: AppColors.tertiaryFixed.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),


                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('High Rating'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Low Rating'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: filteredList.isEmpty
                      ? const Center(child: Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Text("No reviews found for this filter."),
                  ))
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      double rating = double.tryParse(item['rating'] ?? '0') ?? 0;

                      Color themeColor = AppColors.secondary;
                      Color badgeBg = AppColors.secondaryContainer.withOpacity(0.2);
                      bool isCritical = false;

                      if (rating <= 2.0) {
                        themeColor = AppColors.error;
                        badgeBg = AppColors.errorContainer.withOpacity(0.4);
                        isCritical = true;
                      } else if (rating <= 3.5) {
                        themeColor = AppColors.tertiary;
                        badgeBg = AppColors.tertiaryFixed.withOpacity(0.2);
                      }

                      return _buildFeedbackCard(
                        userId: item['admissionNo'] ?? 'Unknown',
                        date: item['date'] ?? '',
                        rating: rating.toString(),
                        review: item['feedback'] ?? '',
                        avatarUrl: 'https://i.pravatar.cc/150?u=${item['admissionNo']}',
                        themeColor: themeColor,
                        badgeBgColor: badgeBg,
                        isError: isCritical,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }


  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color iconColor, required Color iconBgColor}) {
    return Container(
      width: 180, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 24)),
          const SizedBox(height: 16),
          Text(title.toUpperCase(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant, letterSpacing: 1.0)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard({required String userId, required String date, required String rating, required String review, required String avatarUrl, required Color themeColor, required Color badgeBgColor, bool isError = false}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: themeColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
                            const SizedBox(width: 12),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(userId, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(date, style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant)),
                            ]),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Text(rating, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: isError ? AppColors.error : themeColor)),
                            const SizedBox(width: 4),
                            Icon(Icons.star, size: 14, color: isError ? AppColors.error : themeColor),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(review, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant, height: 1.5)),
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