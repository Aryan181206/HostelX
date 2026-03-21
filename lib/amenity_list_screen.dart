import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'book_amenity_detail_screen.dart';

class AmenitiesListScreen extends StatefulWidget {
  const AmenitiesListScreen({super.key});

  @override
  State<AmenitiesListScreen> createState() => _AmenitiesListScreenState();
}

class _AmenitiesListScreenState extends State<AmenitiesListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Available', 'Booked'

  String? currentUserId;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');

      if (userStr != null) {
        final userData = jsonDecode(userStr);
        setState(() {
          currentUserId = userData['Admission No'] ?? 'unknown_user';
          _isLoadingUser = false;
        });
      } else {
        setState(() => _isLoadingUser = false);
      }
    } catch (e) {
      debugPrint("Error loading user from prefs: $e");
      setState(() => _isLoadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar ---
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search for amenities...',
                hintStyle: GoogleFonts.inter(color: AppColors.outline.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Filters ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Available'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Booked'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Available Today',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // --- Dynamic Amenities List ---
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('amenities').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No amenities found.');
                }

                var docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final matchesSearch = data['title'].toString().toLowerCase().contains(_searchQuery);
                  final matchesFilter = _selectedFilter == 'All' || data['status'] == _selectedFilter;
                  return matchesSearch && matchesFilter;
                }).toList();

                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No amenities match your search or filter.'),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final amenity = docs[index].data() as Map<String, dynamic>;
                    final amenityId = docs[index].id;
                    return _buildAmenityCard(context, amenity, amenityId);
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // --- My Bookings Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Bookings',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  'View History',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Dynamic Bookings List ---
            if (currentUserId != null)
              StreamBuilder<QuerySnapshot>(
                // Filter where 'uid' matches the shared preferences roll number
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('uid', isEqualTo: currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('You have no bookings yet.');
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: snapshot.data!.docs.map((doc) {
                        final booking = doc.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildBookingCard(booking),
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            else
              const Text('Could not load user data. Please log in again.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityCard(BuildContext context, Map<String, dynamic> data, String id) {
    bool isAvailable = data['status'] == 'Available';
    Color tagColor = isAvailable ? AppColors.secondary : AppColors.tertiaryFixed;
    Color tagBg = isAvailable ? AppColors.secondaryContainer : AppColors.tertiaryContainer;
    Color tagTextColor = isAvailable ? AppColors.onSecondaryContainer : AppColors.onTertiaryContainer;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(data['imageUrl'], fit: BoxFit.cover),
                Positioned(
                  top: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        color: tagBg.withOpacity(0.9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                              data['status'],
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: tagTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['subtitle'] ?? '',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookAmenityDetailScreen(
                          amenityData: data,
                          amenityId: id,
                          currentUid: currentUserId ?? 'unknown_user', // Pass UID here
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text('Book Now', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> data) {
    String status = data['status'] ?? 'Pending';
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bgColor = AppColors.primaryContainer;
        textColor = Colors.white;
        icon = Icons.event_available;
        break;
      case 'rejected':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.cancel;
        break;
      case 'pending':
      default:
        bgColor = AppColors.surfaceContainerHigh;
        textColor = AppColors.onSurface;
        icon = Icons.hourglass_empty;
    }

    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: textColor == Colors.white ? Colors.white.withOpacity(0.2) : textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(icon, color: textColor, size: 20),
              ),
              Text(
                status.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(data['amenityTitle'] ?? '', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(data['time'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}