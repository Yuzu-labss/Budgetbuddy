import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_fab.dart';
import '../budget/screens/budget_screen.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../expenses/screens/expense_list_screen.dart';

/// The authenticated app shell. It owns the hamburger [AppDrawer], the bottom
/// navigation bar and the single shared [AppFab] (visible on every page), and
/// switches between Dashboard / Budget / Expense with an [IndexedStack] so each
/// page keeps its state.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      key: rootScaffoldKey,
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardScreen(),
          BudgetScreen(),
          ExpenseListScreen(),
        ],
      ),
      floatingActionButton: const AppFab(),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: c.banner,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: c.shadow.withValues(alpha: 0.10),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Budget',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Expense',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
