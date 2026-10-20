import 'dart:io';

import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../models/expense.dart';
import '../../../utils/categories.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onTap,
    required this.onDelete,
  });

  String _peso(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '₱$whole.${parts[1]}';
  }

  String _date(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final income = expense.isIncome;
    final c = context.colors;
    final categoryColor = Categories.colorFor(expense.category);

    // The receipt/photo is stored on-device; show it when the file still exists.
    final path = expense.receiptUrl;
    final File? imageFile =
        (path != null && path.isNotEmpty && File(path).existsSync())
        ? File(path)
        : null;
    final notes = expense.notes.trim();

    return Material(
      color: c.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: imageFile != null
                    ? c.inputFill
                    : categoryColor.withValues(alpha: 0.18),
                backgroundImage: imageFile != null
                    ? FileImage(imageFile)
                    : null,
                child: imageFile == null
                    ? Icon(
                        Categories.iconFor(expense.category),
                        color: categoryColor,
                        size: 22,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${expense.category}  •  ${_date(expense.date)}',
                      style: AppTextStyles.text.copyWith(
                        color: c.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          notes,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.text.copyWith(
                            color: c.textSecondary,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${income ? '+' : '-'}${_peso(expense.amount)}',
                style: AppTextStyles.title.copyWith(
                  color: income ? c.primary : c.error,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: c.textSecondary,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
