import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key}); // ✅ FIXED

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 Quick Actions
              const Text("Quick Actions", style: sectionTitle),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.report_problem,
                      title: "Complaint",
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.exit_to_app,
                      title: "Leave Request",
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),



              /// 🔹 Notice Board
              const Text("Notice Board", style: sectionTitle),
              const SizedBox(height: 12),

              _buildAnnouncementCard(
                  "Water supply will be off tomorrow from 10 AM to 2 PM."),
              _buildAnnouncementCard(
                  "Hostel gate will close at 10 PM strictly."),

              const SizedBox(height: 24),

              /// 🔹 Mess Section
              const Text("What is in Today's Food? 🍽️",
                  style: sectionTitle),
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

  /// 🔹 Quick Action Card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// 🔹 Announcement Card
  Widget _buildAnnouncementCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: const [
          Icon(Icons.campaign, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(child: Text("")),
        ],
      ),
    ).copyWithText(text);
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

/// 🔥 Extension to fix text inside announcement cleanly
extension on Container {
  Widget copyWithText(String text) {
    final row = (child as Row);
    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: Row(
        children: [
          row.children[0],
          row.children[1],
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}