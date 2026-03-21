import 'package:amber_hackathon/amenity_list_screen.dart';
import 'package:amber_hackathon/complaints/complaints_screen.dart';
import 'package:amber_hackathon/lost_and_found/lost_and_found_screen.dart';
import 'package:amber_hackathon/mess_menu_screen.dart';
import 'package:amber_hackathon/notice.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // 🔹 Common Spacing
  static const double spacing = 16;

  // 🔹 Common Text Styles
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Quick Actions
              const Text("Quick Actions", style: sectionTitle),
              const SizedBox(height: 12),

              // First Row of Actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.report_problem,
                      title: "Raise a\nComplaint",
                      color: Colors.redAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.storefront,
                      title: "Book\nFacility",
                      color: Colors.blueAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AmenitiesListScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Second Row of Actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.restaurant_menu,
                      title: "Mess\nMenu",
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MessMenuScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.travel_explore,
                      title: "Lost and\nFound",
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LostAndFoundScreen()),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 🔹 Notice Board Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Notice Board", style: sectionTitle),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NoticesScreen()),
                    ),
                    child: Row(
                      children: const [
                        Text("View More"),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),

              /// 🔹 Notice Board Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildAnnouncementRow("Water supply will be off tomorrow from 10 AM to 2 PM."),
                    const Divider(height: 24, thickness: 1),
                    _buildAnnouncementRow("Hostel gate will close at 10 PM strictly."),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Mess Section
              const Text("What is in Today's Food? 🍽️", style: sectionTitle),
              const SizedBox(height: 12),

              _buildMessCard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Common Card Decoration
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    );
  }

  /// 🔹 Quick Action Card (Updated with Navigation)
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Announcement Row (Cleaned up for the master container)
  Widget _buildAnnouncementRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.campaign, color: Colors.orange, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  /// 🔹 Mess Card
  Widget _buildMessCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Today’s Mess Menu", style: cardTitle),
              Icon(Icons.restaurant, color: Colors.green),
            ],
          ),

          const SizedBox(height: 20),

          _buildMealItem(
            title: "BREAKFAST",
            food: "Pancakes & Coffee",
            time: "08:00 AM - 10:00 AM",
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          _buildMealItem(
            title: "LUNCH",
            food: "Vegetable Biryani",
            time: "12:30 PM - 02:30 PM",
            color: Colors.green,
          ),

          const SizedBox(height: 16),

          _buildMealItem(
            title: "DINNER",
            food: "Paneer Butter Masala",
            time: "08:00 PM - 10:00 PM",
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  /// 🔹 Meal Item
  Widget _buildMealItem({
    required String title,
    required String food,
    required String time,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: subtitle.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 4),
              Text(food, style: cardTitle),
              const SizedBox(height: 4),
              Text(time, style: subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

