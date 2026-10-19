import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class BudgetCard extends StatelessWidget {
  final String period;
  final double budget;
  final double spent;
  final VoidCallback? onEdit;

  const BudgetCard({
    super.key,
    required this.period,
    required this.budget,
    required this.spent,
    this.onEdit,
  });

  String _peso(double v) => '₱${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final hasBudget = budget > 0;
    final ratio = hasBudget ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final almostUsed = ratio >= 0.8;
    final remaining = budget - spent;
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
            period,
            style: AppTextStyles.text.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: c.textSecondary,
              valueColor: AlwaysStoppedAnimation(
                almostUsed ? c.expense : c.income,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasBudget ? _peso(budget) : 'No budget set',
            style: AppTextStyles.title.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasBudget)
            Text(
              'Spent ${_peso(spent)}  •  Remaining ${_peso(remaining)}',
              style: AppTextStyles.text.copyWith(
                color: c.textSecondary,
                fontSize: 12,
              ),
            )
          else if (spent > 0)
            Text(
              'Spent ${_peso(spent)}',
              style: AppTextStyles.text.copyWith(
                color: c.textSecondary,
                fontSize: 12,
              ),
            ),
          if (onEdit != null) ...[
            const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
