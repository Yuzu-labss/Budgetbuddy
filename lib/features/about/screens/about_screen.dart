import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../config/theme.dart';

/// Static "About Us" page: generic info about the budget tracker and the team
/// behind it. Non-functional placeholder — no links or actions yet.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // App identity
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.banner,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: c.onAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  kAppName,
                  style: AppTextStyles.subHeader.copyWith(
                    color: c.onBanner,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kAppTagline,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text.copyWith(
                    color: c.onBannerMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About the app
          _section(
            context,
            title: 'About the app',
            children: [
              Text(
                '$kAppName is a student-friendly budget and expense tracker. '
                'It helps you set daily, weekly, and monthly spending limits, '
                'log your income and expenses, and see exactly how much of '
                'your budget is left in real time.\n\n',
                style: AppTextStyles.text.copyWith(
                  color: c.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // What you can do
          _section(
            context,
            title: 'What you can do',
            children: [
              _feature(
                context,
                Icons.track_changes_rounded,
                'Set daily, weekly, and monthly budgets',
              ),
              _feature(
                context,
                Icons.receipt_long_rounded,
                'Track income and expenses by category',
              ),
              _feature(
                context,
                Icons.bar_chart_rounded,
                'Watch live progress bars for every budget period',
              ),
              _feature(
                context,
                Icons.dark_mode_outlined,
                'Switch between light and dark mode',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Developers
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Developed by',
                  style: AppTextStyles.text.copyWith(
                    color: c.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3f_g1 team',
                  style: AppTextStyles.title.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: AppTextStyles.text.copyWith(
              color: c.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.text.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _feature(BuildContext context, IconData icon, String text) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: c.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.text.copyWith(
                color: c.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
