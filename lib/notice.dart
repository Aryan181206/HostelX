import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart';
import 'api/user_sheet_api.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Map<String, String>>>(
        future: UserSheetsApi.getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No announcements available"));
          }

          final announcements = snapshot.data!;


          announcements.sort((a, b) =>
              b['date']!.compareTo(a['date']!));

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 50, left: 20, right: 20, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('📢 ANNOUNCEMENTS'),
                const SizedBox(height: 16),


                ...announcements.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildNoticeCard(
                      category: item['header'] ?? 'General',
                      date: _formatDate(item['date'] ?? ''),
                      title: item['header'] ?? 'Notice',
                      description: item['announcement'] ?? '',
                      categoryColor: _getCategoryColor(item['header']),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }


  String _formatDate(String rawDate) {
    try {
      if (double.tryParse(rawDate) != null) {
        int days = int.parse(rawDate);
        DateTime date =
        DateTime(1899, 12, 30).add(Duration(days: days));
        return DateFormat('dd MMM yyyy').format(date);
      }

      return DateFormat('dd MMM yyyy')
          .format(DateTime.parse(rawDate));
    } catch (e) {
      return rawDate;
    }
  }


  Color _getCategoryColor(String? header) {
    switch (header?.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'maintenance':
        return Colors.red;
      case 'events':
        return Colors.blue;
      case 'facility':
        return Colors.green;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2.0,
        ),
      ),
    );
  }


  Widget _buildNoticeCard({
    required String category,
    required String date,
    required String title,
    required String description,
    required Color categoryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),


          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),

          const SizedBox(height: 4),


          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}