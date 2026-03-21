import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api/user_sheet_api.dart';
import 'app_theme.dart';
import 'mess_menu_data.dart';

class MessMenuScreen extends StatefulWidget {
  const MessMenuScreen({super.key});

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {
  late DateTime _currentDate;
  late int _currentWeekday;

  bool _isTodayTab = true;
  late int _selectedWeeklyDay;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _currentWeekday = _currentDate.weekday;
    _selectedWeeklyDay = _currentWeekday;
  }

  String _getFormattedDate() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String dayName = MessMenuData.weekdays[_currentDate.weekday - 1];
    String monthName = months[_currentDate.month - 1];

    String suffix = 'th';
    if (_currentDate.day % 10 == 1 && _currentDate.day != 11) suffix = 'st';
    if (_currentDate.day % 10 == 2 && _currentDate.day != 12) suffix = 'nd';
    if (_currentDate.day % 10 == 3 && _currentDate.day != 13) suffix = 'rd';

    return '$dayName, ${_currentDate.day}$suffix $monthName';
  }

  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    int activeDay = _isTodayTab ? _currentWeekday : _selectedWeeklyDay;
    final displayMenu = MessMenuData.weeklyMenu[activeDay] ?? {};

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: AppColors.surface.withOpacity(0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              titleSpacing: 24,
              title: Row(
                children: [
                  const Icon(Icons.restaurant, color: AppColors.primaryContainer, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Mess Menu',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isTodayTab = true),
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isTodayTab ? AppColors.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: _isTodayTab ? [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            'Today',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: _isTodayTab ? FontWeight.w600 : FontWeight.w500,
                              color: _isTodayTab ? AppColors.primary : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isTodayTab = false),
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isTodayTab ? AppColors.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: !_isTodayTab ? [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            'Weekly',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: !_isTodayTab ? FontWeight.w600 : FontWeight.w500,
                              color: !_isTodayTab ? AppColors.primary : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!_isTodayTab) ...[
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    int dayInt = index + 1;
                    bool isSelected = dayInt == _selectedWeeklyDay;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          MessMenuData.weekdays[index].substring(0, 3),
                          style: GoogleFonts.inter(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerLowest,
                        showCheckmark: false,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedWeeklyDay = dayInt);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              _isTodayTab ? "Today's Selection" : "${MessMenuData.weekdays[_selectedWeeklyDay - 1]}'s Menu",
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isTodayTab ? _getFormattedDate() : 'Weekly Overview',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            if (displayMenu.containsKey('Breakfast'))
              _buildMealCard(
                title: 'Breakfast',
                time: '08:00 AM - 10:00 AM',
                icon: Icons.coffee,
                themeColor: AppColors.secondary,
                bgColor: AppColors.secondaryContainer.withOpacity(0.3),
                items: displayMenu['Breakfast']!,
              ),
            const SizedBox(height: 24),

            if (displayMenu.containsKey('Lunch'))
              _buildMealCard(
                title: 'Lunch',
                time: '12:30 PM - 02:30 PM',
                icon: Icons.restaurant_menu,
                themeColor: AppColors.primary,
                bgColor: AppColors.primaryFixed.withOpacity(0.3),
                items: displayMenu['Lunch']!,
              ),
            const SizedBox(height: 24),

            if (displayMenu.containsKey('Snacks'))
              _buildMealCard(
                title: 'Snacks',
                time: '05:00 PM - 06:00 PM',
                icon: Icons.bakery_dining,
                themeColor: Colors.orange,
                bgColor: Colors.orange.withOpacity(0.15),
                items: displayMenu['Snacks']!,
              ),
            const SizedBox(height: 24),

            if (displayMenu.containsKey('Dinner'))
              _buildMealCard(
                title: 'Dinner',
                time: '07:30 PM - 09:30 PM',
                icon: Icons.dinner_dining,
                themeColor: AppColors.tertiary,
                bgColor: AppColors.tertiaryFixed.withOpacity(0.3),
                items: displayMenu['Dinner']!,
              ),

            if (_isTodayTab) ...[
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      "Rate today's food",
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'How was your experience?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedRating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select rating")),
                            );
                            return;
                          }
                          _showFeedbackDialog(context, selectedRating);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          'Submit Feedback',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required String time,
    required IconData icon,
    required Color themeColor,
    required Color bgColor,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: themeColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: themeColor),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          time,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStar({required bool isFilled}) {
    return Icon(
      isFilled ? Icons.star : Icons.star_border,
      size: 36,
      color: isFilled ? AppColors.primary : AppColors.outlineVariant,
    );
  }

  void _showFeedbackDialog(BuildContext context, int rating) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Feedback",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter your feedback...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final feedbackText = feedbackController.text.trim();

                if (feedbackText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter feedback")),
                  );
                  return;
                }

                bool success = await UserSheetsApi.addFeedback(
                  rating: rating,
                  feedbackText: feedbackText,
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? "Feedback submitted successfully ✅"
                          : "Failed to submit feedback ❌",
                    ),
                  ),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}