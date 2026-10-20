import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_routes.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BudgetBuddyApp());
}

class BudgetBuddyApp extends StatelessWidget {
  const BudgetBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Theme, budget & expense providers all follow the authenticated uid,
        // so each account keeps its own data in Firestore.
        ChangeNotifierProxyProvider<AuthProvider, ThemeController>(
          create: (_) => ThemeController(),
          update: (_, auth, theme) =>
              (theme ?? ThemeController())..start(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BudgetProvider>(
          create: (_) => BudgetProvider(),
          update: (_, auth, budget) =>
              (budget ?? BudgetProvider())..start(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ExpenseProvider>(
          create: (_) => ExpenseProvider(),
          update: (_, auth, expenses) =>
              (expenses ?? ExpenseProvider())..start(auth.user?.uid),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) => MaterialApp(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          // A single, fully-built theme drives the whole app; its brightness is
          // baked in per ThemeKind, so no separate darkTheme/themeMode needed.
          theme: AppTheme.forKind(theme.kind),
          home: const SplashScreen(),
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
