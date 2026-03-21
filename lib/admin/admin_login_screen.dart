import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Ensure these paths match your project structure
import '../app_theme.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _obscurePassword = true;

  // Controllers for text fields
  final adminEmailController = TextEditingController();
  final adminPasswordController = TextEditingController();

  // Hardcoded credentials as per your requirement
  final String adminEmailKey = "admin@iitism.ac.in";
  final String adminPasswordKey = "adminiitamber";

  @override
  void dispose() {
    adminEmailController.dispose();
    adminPasswordController.dispose();
    super.dispose();
  }

  // Extracted Login Logic
  void _handleLogin() {
    final email = adminEmailController.text.trim();
    final password = adminPasswordController.text.trim();

    if (email == adminEmailKey && password == adminPasswordKey) {
      // Use pushReplacement so user can't "Go Back" to login screen after success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid Credentials. Please try again.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Background Mesh Effect
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixedDim,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 450),
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
                          // Header
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Text(
                                  'RESIDENT ONE',
                                  style: GoogleFonts.manrope(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.0,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Admin Login',
                                  style: GoogleFonts.manrope(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sign in to manage hostel operations',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Form
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(12),
                                    border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 20),
                                      const SizedBox(width: 12),
                                      Text(
                                        'ADMIN ACCESS ONLY',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Email
                                _buildTextField(
                                  controller: adminEmailController,
                                  hintText: 'Enter admin email',
                                  icon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // Password
                                _buildTextField(
                                  controller: adminPasswordController,
                                  hintText: 'Enter password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Login Button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primary, AppColors.primaryContainer],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _handleLogin, // Fixed Navigation Logic
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, color: AppColors.onPrimary, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          // Footer Indicator
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                            color: AppColors.surfaceContainerHigh.withOpacity(0.3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.security, color: AppColors.outline, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'ENCRYPTED END-TO-END ENVIRONMENT',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.outline,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: AppColors.outline, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: AppColors.outline),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.outline,
          ),
          onPressed: onToggleVisibility,
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 2),
        ),
      ),
    );
  }
}