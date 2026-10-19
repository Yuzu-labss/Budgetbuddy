import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_input_field.dart';

/// Opens the "Set / Edit Budget" popup (modal bottom sheet).
///
/// Shows all three periods at once, prefilled with the current budget, and
/// saves through [BudgetProvider] so each account persists its own values in
/// Firestore (`users/{uid}/budgets/current`).
Future<void> showBudgetSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _BudgetSheet(),
  );
}

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
                  onEdit: () => showBudgetSheet(context),
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'WEEKLY',
                  budget: b.weekly,
                  spent: spentWeekly,
                  onEdit: () => showBudgetSheet(context),
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'MONTHLY',
                  budget: b.monthly,
                  spent: spentMonthly,
                  onEdit: () => showBudgetSheet(context),
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

class _BudgetSheet extends StatefulWidget {
  const _BudgetSheet();

  @override
  State<_BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends State<_BudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _daily;
  late final TextEditingController _weekly;
  late final TextEditingController _monthly;

  @override
  void initState() {
    super.initState();
    final b = context.read<BudgetProvider>().budget;
    _daily = TextEditingController(text: _prefill(b.daily));
    _weekly = TextEditingController(text: _prefill(b.weekly));
    _monthly = TextEditingController(text: _prefill(b.monthly));
  }

  String _prefill(double v) => v > 0 ? v.toStringAsFixed(2) : '';

  @override
  void dispose() {
    _daily.dispose();
    _weekly.dispose();
    _monthly.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await context.read<BudgetProvider>().save(
          daily: double.parse(_daily.text.trim()),
          weekly: double.parse(_weekly.text.trim()),
          monthly: double.parse(_monthly.text.trim()),
        );
    if (!mounted) return;
    if (ok) {
      nav.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Budget updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final provider = context.watch<BudgetProvider>();
    final saving = provider.isSaving;
    final error = provider.error;
    final hasBudget = !provider.budget.isEmpty;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  hasBudget ? 'Edit Budget' : 'Set Budget',
                  style: AppTextStyles.subHeader
                      .copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 20),
              BudgetInputField(
                controller: _daily,
                label: 'Daily Budget',
                icon: Icons.today_rounded,
              ),
              const SizedBox(height: 16),
              BudgetInputField(
                controller: _weekly,
                label: 'Weekly Budget',
                icon: Icons.date_range_rounded,
              ),
              const SizedBox(height: 16),
              BudgetInputField(
                controller: _monthly,
                label: 'Monthly Budget',
                icon: Icons.calendar_month_rounded,
                textInputAction: TextInputAction.done,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: AppTextStyles.text
                      .copyWith(color: colors.error, fontSize: 13),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.expense,
                    foregroundColor: colors.onAccent,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    textStyle: AppTextStyles.title
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  child: saving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: colors.onAccent),
                        )
                      : Text(hasBudget ? 'Save Changes' : 'Set Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
