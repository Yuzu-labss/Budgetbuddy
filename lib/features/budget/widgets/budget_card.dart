import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class BudgetCard extends StatelessWidget {
  final String period;
  final double budget;
  final double spent;
  final VoidCallback onEdit;

  const BudgetCard({
    super.key,
    required this.period,
    required this.budget,
    required this.spent,
    required this.onEdit,
  });

  String _peso(double v) => '₱${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasBudget = budget > 0;
    final ratio = hasBudget ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final percent = (ratio * 100).round();
    final almostUsed = ratio >= 0.8;
    final remaining = budget - spent;
    final fillColor = almostUsed ? c.expense : c.income;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                period,
                style: AppTextStyles.text.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                hasBudget ? '$percent%' : '--',
                style: AppTextStyles.text.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Track
                Container(
                  height: 14,
                  width: double.infinity,
                  color: c.textSecondary.withValues(alpha: 0.25),
                ),
                // Animated fill
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  builder: (context, value, _) => FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Budget amount
          Text(
            hasBudget ? _peso(budget) : 'No budget set',
            style: AppTextStyles.title.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),

          // Spent / Remaining
          if (hasBudget)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spent: ${_peso(spent)}',
                  style: AppTextStyles.text.copyWith(
                    color: c.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Remaining: ${_peso(remaining)}',
                  style: AppTextStyles.text.copyWith(
                    color: remaining < 0 ? c.expense : c.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),

          // Edit / Set button
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.expense,
                  foregroundColor: c.onAccent,
                  elevation: 0,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: AppTextStyles.text
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                child: Text(hasBudget ? 'Edit' : 'Set'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
