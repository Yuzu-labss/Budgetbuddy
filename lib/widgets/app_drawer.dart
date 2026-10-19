import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../features/about/screens/about_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_controller.dart';

/// Global key used by the HomeShell Scaffold so any page's AppBar menu button
/// can open the shared drawer.
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeController>();
    final user = auth.user;
    final c = context.colors;

    return Drawer(
      backgroundColor: c.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: c.banner,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: c.onAccent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Budget Buddy',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title.copyWith(
                            color: c.onBanner,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (user?.email != null)
                          Text(
                            user!.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.text.copyWith(
                              color: c.onBannerMuted,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _tile(
              icon: Icons.info_outline_rounded,
              label: 'About',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.dark_mode_outlined,
                color: c.textPrimary,
              ),
              title: Text(
                'Dark mode',
                style: AppTextStyles.title.copyWith(
                  color: c.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: theme.isDark,
              onChanged: (v) => context.read<ThemeController>().setDark(v),
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: c.error,
              ),
              title: Text(
                'Log out',
                style: AppTextStyles.title.copyWith(
                  color: c.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // close drawer
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final c = context.colors;
        return ListTile(
          leading: Icon(icon, color: c.textPrimary),
          title: Text(
            label,
            style: AppTextStyles.title.copyWith(
              color: c.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // close drawer
            onTap?.call();
          },
        );
      },
    );
  }
}
