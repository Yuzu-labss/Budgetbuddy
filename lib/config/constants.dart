// Global app constants shared across every integrated feature.
const String kAppName = 'BudgetBuddy';
const String kAppTagline = 'Student budget & expense tracker';

// Layout
const double kDefaultPadding = 16.0;
const double kDefaultRadius = 16.0;

// Typography scale
const double kHeaderSize = 35;
const double kSubHeaderSize = 25;
const double kTitleSize = 20;
const double kTextSize = 14;

// Auth
const int kMinPasswordLength = 6;

// Firestore collections
const String kUsersCollection = 'users';
const String kBudgetsCollection = 'budgets';
const String kExpensesCollection = 'expenses';
const String kSettingsCollection = 'settings';

// Fixed document ids within a user's subcollections
const String kBudgetDocId = 'current';
const String kSettingsDocId = 'preferences';

// Currency
const String kCurrencySymbol = '₱';
const String kCurrencyLocale = 'en_PH';
