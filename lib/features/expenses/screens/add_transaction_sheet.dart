import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../providers/expense_provider.dart';
import '../../../utils/categories.dart';
import '../../budget/widgets/budget_input_field.dart';

/// Opens the "Add Transaction" popup (modal bottom sheet).
///
/// Ported from the `budgetbuddy_dashboard_floatingaction` project's
/// `AddExpenseScreen`: a single form holding an Expense/Income toggle plus the
/// name, amount, date, category and notes fields. Instead of pushing a page it
/// is presented as a popup, and it saves through the shared [ExpenseProvider].
Future<void> showAddTransactionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const AddTransactionSheet(),
  );
}

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isIncome = false;
  String _category = Categories.food;
  DateTime _date = DateTime.now();

  Color get _accent => _isIncome ? context.colors.income : context.colors.expense;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _switchType(bool income) {
    if (_isIncome == income) return;
    setState(() {
      _isIncome = income;
      _category = Categories.food;
      // Drop a date that is no longer valid for the newly selected type.
      final today = DateUtils.dateOnly(DateTime.now());
      final date = DateUtils.dateOnly(_date);
      if ((!income && date.isAfter(today)) || (income && date.isBefore(today))) {
        _date = today;
      }
    });
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _isIncome ? today : DateTime(2000),
      lastDate: _isIncome ? DateTime(2100, 12, 31) : today,
      helpText: _isIncome ? 'Select income date' : 'Select expense date',
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await context.read<ExpenseProvider>().add(
          name: _nameController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          category: _category,
          date: _date,
          notes: _notesController.text.trim(),
          type: _isIncome ? 'income' : 'expense',
        );
    if (!mounted) return;
    if (ok) {
      nav.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(_isIncome ? 'Income added' : 'Expense added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final saving = context.watch<ExpenseProvider>().isLoading;
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
                  'Add Transaction',
                  style: AppTextStyles.subHeader.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 20),

              // EXPENSE / INCOME SELECTOR
              Row(
                children: [
                  Expanded(child: _typeButton('Expense', income: false)),
                  const SizedBox(width: 12),
                  Expanded(child: _typeButton('Income', income: true)),
                ],
              ),
              const SizedBox(height: 20),

              // NAME
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                style: AppTextStyles.title.copyWith(color: colors.textPrimary),
                cursorColor: colors.textPrimary,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _isIncome ? 'Income source is required' : 'Name is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: _isIncome ? 'Income Source' : 'Expense Name',
                  hintText: _isIncome ? 'e.g. Allowance' : 'e.g. Lunch',
                  prefixIcon: Icon(Icons.label_rounded, color: colors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // AMOUNT
              BudgetInputField(
                controller: _amountController,
                label: 'Amount',
                icon: Icons.payments_rounded,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),

              // DATE
              Material(
                color: colors.inputFill,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _pickDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, color: colors.primary),
                        const SizedBox(width: 12),
                        Text(
                          _fmtDate(_date),
                          style: AppTextStyles.title.copyWith(color: colors.textPrimary),
                        ),
                        const Spacer(),
                        Icon(Icons.edit_rounded, size: 18, color: colors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down_rounded, color: colors.primary),
                style: AppTextStyles.title.copyWith(color: colors.textPrimary),
                dropdownColor: colors.surface,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded, color: colors.primary),
                ),
                items: [
                  for (final c in Categories.all)
                    DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Icon(Categories.iconFor(c), size: 20, color: colors.primary),
                          const SizedBox(width: 10),
                          Text(c),
                        ],
                      ),
                    ),
                ],
                onChanged: (c) => setState(() => _category = c ?? _category),
              ),
              const SizedBox(height: 16),

              // NOTES
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: AppTextStyles.title.copyWith(color: colors.textPrimary),
                cursorColor: colors.textPrimary,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add additional details...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_rounded, color: colors.primary),
                ),
              ),
              const SizedBox(height: 24),

              // ATTACHMENT (placeholder — not wired to storage yet)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File upload coming soon')),
                  ),
                  icon: Icon(Icons.upload_file_rounded,
                      size: 20, color: colors.primary),
                  label: Text(
                    'Attach Receipt / File',
                    style: AppTextStyles.text
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(
                        color: colors.primary.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // SAVE
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: colors.onPrimary,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    textStyle:
                        AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                  ),
                  child: saving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: colors.onPrimary),
                        )
                      : Text(_isIncome ? 'Add Income' : 'Add Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String label, {required bool income}) {
    final colors = context.colors;
    final isSelected = _isIncome == income;
    final color = income ? colors.income : colors.expense;

    return GestureDetector(
      onTap: () => _switchType(income),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? colors.onPrimary : color,
          ),
        ),
      ),
    );
  }
}
