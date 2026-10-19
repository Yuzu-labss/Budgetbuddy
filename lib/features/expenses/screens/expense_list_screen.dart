import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/category_chip.dart';
import '../widgets/expense_tile.dart';
import 'edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String? _selectedCategory;
  String _searchQuery = '';
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _confirmDelete(BuildContext context, Expense e) {
    final c = context.colors;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete this entry?',
          style: AppTextStyles.title.copyWith(
            color: c.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This item will be removed from your list.',
          style: AppTextStyles.text.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.text.copyWith(
                color: c.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ExpenseProvider>().delete(e);
            },
            child: Text(
              'Delete',
              style: AppTextStyles.text.copyWith(
                color: c.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final c = context.colors;

    final filtered = p.expenses.where((e) {
      // Category filter
      if (_selectedCategory != null && e.category != _selectedCategory) {
        return false;
      }
      // Date filter
      if (_selectedDate != null) {
        if (e.date.year != _selectedDate!.year ||
            e.date.month != _selectedDate!.month ||
            e.date.day != _selectedDate!.day) {
          return false;
        }
      }
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final nameMatch = e.name.toLowerCase().contains(q);
        final categoryMatch = e.category.toLowerCase().contains(q);
        final notesMatch = e.notes.toLowerCase().contains(q);
        if (!nameMatch && !categoryMatch && !notesMatch) {
          return false;
        }
      }
      return true;
    }).toList();

    final isFiltered = _selectedCategory != null ||
        _selectedDate != null ||
        _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Expenses'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search expenses...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: _selectedDate == null
                            ? () => _pickDate(context)
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedDate != null ? c.primary : c.card,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: _selectedDate != null
                                    ? c.onPrimary
                                    : c.textPrimary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _selectedDate == null
                                    ? 'Date'
                                    : DateFormat('MMM d').format(_selectedDate!),
                                style: AppTextStyles.text.copyWith(
                                  color: _selectedDate != null
                                      ? c.onPrimary
                                      : c.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_selectedDate != null) ...[
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedDate = null),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: c.onPrimary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CategoryChipRow(
                          selected: _selectedCategory,
                          includeAll: true,
                          onSelected: (cat) =>
                              setState(() => _selectedCategory = cat),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: p.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            p.error ??
                                (!isFiltered
                                    ? 'No expenses yet'
                                    : 'No matching expenses found'),
                            style: AppTextStyles.title
                                .copyWith(color: c.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final e = filtered[i];
                            return ExpenseTile(
                              expense: e,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EditExpenseScreen(expense: e)),
                              ),
                              onDelete: () => _confirmDelete(context, e),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
