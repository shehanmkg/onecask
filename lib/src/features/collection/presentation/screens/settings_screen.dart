import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C21),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Text(
                  'Settings',
                  style: const TextStyle(
                    fontFamily: 'EBGaramond',
                    color: Color(0xFFE7E9EA),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Account section
                    _buildSectionHeader('Account'),
                    _buildSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () {
                        // Navigate to profile settings
                      },
                    ),
                    _buildSettingsItem(
                      svgIcon: 'assets/icons/ic_bell.svg',
                      title: 'Notifications',
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      onTap: () {
                        // Navigate to privacy settings
                      },
                    ),

                    const SizedBox(height: 24),

                    // General section
                    _buildSectionHeader('General'),
                    _buildSettingsItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      onTap: () {
                        // Navigate to language settings
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // Navigate to help & support
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // Show about dialog
                        _showAboutDialog(context);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Auth section
                    _buildSectionHeader('Authentication'),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      titleColor: const Color(0xFFDE9A1F),
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                    ),

                    const SizedBox(height: 40),

                    // About section at the bottom
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Developed by Shehan Kande Gamage',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '© 2025',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version $_appVersion',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Lato',
          color: Color(0xFFDE9A1F),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    IconData? icon,
    String? svgIcon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    Widget? leadingWidget;

    if (svgIcon != null) {
      leadingWidget = SvgPicture.asset(
        svgIcon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          titleColor ?? const Color(0xFFE7E9EA),
          BlendMode.srcIn,
        ),
      );
    } else if (icon != null) {
      leadingWidget = Icon(
        icon,
        color: titleColor ?? const Color(0xFFE7E9EA),
        size: 24,
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Lato',
          color: Color(0xFFE7E9EA),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0E1C21),
        title: Text(
          'About One Cask',
          style: const TextStyle(
            fontFamily: 'EBGaramond',
            color: Color(0xFFE7E9EA),
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'One Cask is a premium whiskey collection management app designed for connoisseurs and collectors.',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Developed by Shehan Kande Gamage',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                height: 1.5,
              ),
            ),
            Text(
              '© 2025',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                height: 1.5,
              ),
            ),
            Text(
              'Version $_appVersion',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFE7E9EA),
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFDE9A1F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0E1C21),
        title: Text(
          'Logout',
          style: const TextStyle(
            fontFamily: 'EBGaramond',
            color: Color(0xFFE7E9EA),
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: const TextStyle(
            fontFamily: 'Lato',
            color: Color(0xFFE7E9EA),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Colors.white70,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text(
              'Logout',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xFFDE9A1F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
