import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _darkMode = true;
  String _language = 'English';
  String _currency = 'PKR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Settings',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Account Section
                _buildSectionHeader('Account'),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Edit Profile coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Change Password coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone Number',
                  subtitle: '+92 300 1234567',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Change Phone coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),

                const SizedBox(height: 24),

                // Notifications Section
                _buildSectionHeader('Notifications'),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Enable Notifications',
                  subtitle: 'Receive all notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                if (_notificationsEnabled) ...[
                  _buildSwitchTile(
                    icon: Icons.email_outlined,
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() => _emailNotifications = value);
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.sms_outlined,
                    title: 'SMS Notifications',
                    subtitle: 'Receive updates via SMS',
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() => _smsNotifications = value);
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.phone_android_rounded,
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() => _pushNotifications = value);
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // Preferences Section
                _buildSectionHeader('Preferences'),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() => _darkMode = value);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: _language,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white38,
                  ),
                  onTap: () {
                    _showLanguageSelector();
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.attach_money_rounded,
                  title: 'Currency',
                  subtitle: _currency,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white38,
                  ),
                  onTap: () {
                    _showCurrencySelector();
                  },
                ),

                const SizedBox(height: 24),

                // Privacy & Security Section
                _buildSectionHeader('Privacy & Security'),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Privacy Policy coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Terms of Service coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.block_rounded,
                  title: 'Blocked Businesses',
                  subtitle: 'Manage blocked businesses',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Blocked List coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),

                const SizedBox(height: 24),

                // Support Section
                _buildSectionHeader('Support'),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Help Center coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Contact Us',
                  subtitle: 'Send us a message',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Contact Us coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate App',
                  subtitle: 'Rate us on the app store',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('App Store coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),

                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader('About'),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: '1.0.0 (Build 1)',
                  onTap: null,
                ),

                const SizedBox(height: 32),

                // Logout Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleLogout,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.white38,
        letterSpacing: 1.2,
      ),
    ).animate().fadeIn();
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDeep.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryDeep.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryDeep;
                }
                return null;
              }),
              activeTrackColor: AppColors.primaryDeep.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Language',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['English', 'اردو', 'العربية'].map((lang) {
                return ListTile(
                  title: Text(
                    lang,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  trailing: _language == lang
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primaryLight)
                      : null,
                  onTap: () {
                    setState(() => _language = lang);
                    context.pop();
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Currency',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['PKR', 'USD', 'EUR', 'GBP', 'AED'].map((curr) {
                return ListTile(
                  title: Text(
                    curr,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  trailing: _currency == curr
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primaryLight)
                      : null,
                  onTap: () {
                    setState(() => _currency = curr);
                    context.pop();
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Session cleared
      context.go('/onboarding');
    }
  }
}
