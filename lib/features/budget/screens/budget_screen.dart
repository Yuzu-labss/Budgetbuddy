import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../widgets/budget_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BudgetProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();
    final b = p.budget;
    final c = context.colors;

    // Calculate spent values from actual expenses
    final expenses = expenseProvider.expenses.where((e) => !e.isIncome);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfDay.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    double spentDaily = 0;
    double spentWeekly = 0;
    double spentMonthly = 0;

    for (final e in expenses) {
      if (e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day) {
        spentDaily += e.amount;
      }
      if (!e.date.isBefore(startOfWeek) && e.date.isBefore(endOfWeek)) {
        spentWeekly += e.amount;
      }
      if (e.date.year == now.year && e.date.month == now.month) {
        spentMonthly += e.amount;
      }
    }

    final isLoading = p.isLoading || expenseProvider.isLoading;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Budget'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 170),
              children: [
                BudgetCard(
                  period: 'DAILY',
                  budget: b.daily,
                  spent: spentDaily,
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'WEEKLY',
                  budget: b.weekly,
                  spent: spentWeekly,
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'MONTHLY',
                  budget: b.monthly,
                  spent: spentMonthly,
                ),
                if (p.error != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    p.error!,
                    style: AppTextStyles.text.copyWith(color: c.error),
                  ),
                ],
              ],
            ),
    );
  }
}
