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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette_outlined, color: c.textPrimary, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Theme',
                        style: AppTextStyles.title.copyWith(
                          color: c.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ThemeKind.values
                        .map(
                          (kind) => _ThemeSwatch(
                            kind: kind,
                            selected: theme.kind == kind,
                            onTap: () =>
                                context.read<ThemeController>().setKind(kind),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
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

/// A single theme picker control: a simple circle filled with the theme's
/// prominent colour. The active theme gets a ring and a check mark.
class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  final ThemeKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Pick a legible check colour based on how light/dark the swatch is.
    final checkColor =
        ThemeData.estimateBrightnessForColor(kind.swatch) == Brightness.dark
        ? AppPalette.white
        : const Color(0xFF1C1C22);

    return Semantics(
      button: true,
      selected: selected,
      label: kind.label,
      child: Tooltip(
        message: kind.label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? c.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kind.swatch,
                border: Border.all(color: c.border, width: 1),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, size: 22, color: checkColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
