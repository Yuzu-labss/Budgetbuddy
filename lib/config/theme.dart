import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

/// ===========================================================================
/// theme.dart — the SINGLE source of truth for BudgetBuddy's design system.
///
/// Everything visual (colour, typography, component styling, dark mode) is
/// defined here. Editing this file re-skins the entire app; no widget should
/// declare its own colours or hardcode a hex value.
///
/// HOW TO USE IT IN A WIDGET
/// -------------------------
/// ```dart
/// final c = context.colors;                 // semantic, theme-aware palette
/// Container(color: c.background, ...)
/// Text('Hi', style: AppTextStyles.title.copyWith(color: c.onBanner));
/// ```
/// `context.colors` resolves to the value of the active [ThemeKind] (one of
/// five skins), so switching themes repaints the whole app.
///
/// ADDING / CHANGING A COLOUR
/// --------------------------
/// 1. Add the raw value ONCE to [AppPalette] (the normalized hex registry).
/// 2. Expose it as a semantic role on [AppColors], giving it a value in EACH of
///    the five instances (cleanWhite / midnight / sage / azure / scarlet).
/// 3. Consume it through `context.colors.<role>` — never reference the raw hex.
///
/// Most widgets (AppBar, Card, Dialog, inputs, buttons, navigation, chips …)
/// are already themed centrally in [AppTheme]; prefer omitting per-widget
/// colour overrides so the theme stays in control.
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// AppPalette — the normalized raw colour registry.
///
/// Each distinct hex value used anywhere in the app lives here exactly once.
/// These are the *ingredients*; [AppColors] maps them onto semantic roles for
/// the light and dark themes. Nothing outside this file should reference these
/// constants directly — go through `context.colors` instead.
/// ---------------------------------------------------------------------------
class AppPalette {
  AppPalette._();

  // Neutrals
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // -- Clean White (neutral grayscale monochrome) --------------------------
  static const Color cwBackground = Color(0xFFFFFFFF);
  static const Color cwSurface = Color(0xFFF6F6F8);
  static const Color cwSurfaceVariant = Color(0xFFEDEDF0);
  static const Color cwCard = Color(0xFFF2F2F5);
  static const Color cwBanner = Color(0xFF33333A);
  static const Color cwInputFill = Color(0xFFFFFFFF);
  static const Color cwTextPrimary = Color(0xFF1C1C22);
  static const Color cwTextSecondary = Color(0xFF6C6C76);
  static const Color cwTextDisabled = Color(0xFFB2B2BA);
  static const Color cwOnBannerMuted = Color(0xFFB9B9C2);
  static const Color cwPrimary = Color(0xFF43434C);
  static const Color cwSecondary = Color(0xFF8A8A93);
  static const Color cwAccent = Color(0xFFE3E3E8);

  // -- Midnight (near-black monochrome) ------------------------------------
  static const Color mdBackground = Color(0xFF000000);
  static const Color mdSurface = Color(0xFF0E0E11);
  static const Color mdSurfaceVariant = Color(0xFF1B1B20);
  static const Color mdCard = Color(0xFF141418);
  static const Color mdBanner = Color(0xFF0C0C0F);
  static const Color mdInputFill = Color(0xFF1B1B20);
  static const Color mdTextPrimary = Color(0xFFF2F2F4);
  static const Color mdTextSecondary = Color(0xFFA2A2AB);
  static const Color mdTextDisabled = Color(0xFF5C5C64);
  static const Color mdOnBannerMuted = Color(0xFF9A9AA3);
  static const Color mdPrimary = Color(0xFFE6E6EA);
  static const Color mdSecondary = Color(0xFF8C8C95);
  static const Color mdAccent = Color(0xFFC9C9D0);

  // -- Sage Green (green monochrome) ---------------------------------------
  static const Color sgBackground = Color(0xFFEEF2EA);
  static const Color sgSurface = Color(0xFFE1E9DB);
  static const Color sgSurfaceVariant = Color(0xFFD2DCCA);
  static const Color sgCard = Color(0xFFDDE6D6);
  static const Color sgBanner = Color(0xFF5C7A58);
  static const Color sgInputFill = Color(0xFFF6F9F3);
  static const Color sgTextPrimary = Color(0xFF2E3F2D);
  static const Color sgTextSecondary = Color(0xFF556B54);
  static const Color sgTextDisabled = Color(0xFF9BAA98);
  static const Color sgOnBanner = Color(0xFFF2F6EF);
  static const Color sgOnBannerMuted = Color(0xFFCEDCC8);
  static const Color sgPrimary = Color(0xFF7C9A78);
  static const Color sgSecondary = Color(0xFFA7C0A1);
  static const Color sgAccent = Color(0xFFBFDCB9);

  // -- Azure Blue (blue monochrome) ----------------------------------------
  static const Color azBackground = Color(0xFFEAF2FB);
  static const Color azSurface = Color(0xFFDDEAF7);
  static const Color azSurfaceVariant = Color(0xFFCFE1F3);
  static const Color azCard = Color(0xFFD9E8F7);
  static const Color azBanner = Color(0xFF2C6BA8);
  static const Color azInputFill = Color(0xFFF5F9FE);
  static const Color azTextPrimary = Color(0xFF17374F);
  static const Color azTextSecondary = Color(0xFF45657F);
  static const Color azTextDisabled = Color(0xFF93A9BC);
  static const Color azOnBanner = Color(0xFFEAF2FB);
  static const Color azOnBannerMuted = Color(0xFFBBD3E8);
  static const Color azPrimary = Color(0xFF3E86C6);
  static const Color azSecondary = Color(0xFF7FAED8);
  static const Color azAccent = Color(0xFFBBD7EF);

  // -- Scarlet Red (soft red monochrome) -----------------------------------
  static const Color scBackground = Color(0xFFFBEDEC);
  static const Color scSurface = Color(0xFFF7E2E0);
  static const Color scSurfaceVariant = Color(0xFFF2D3D0);
  static const Color scCard = Color(0xFFF6DEDB);
  static const Color scBanner = Color(0xFFA8473E);
  static const Color scInputFill = Color(0xFFFEF6F5);
  static const Color scTextPrimary = Color(0xFF5A2A25);
  static const Color scTextSecondary = Color(0xFF8A5751);
  static const Color scTextDisabled = Color(0xFFC2A09C);
  static const Color scOnBanner = Color(0xFFFBEDEB);
  static const Color scOnBannerMuted = Color(0xFFEFC7C2);
  static const Color scPrimary = Color(0xFFC4685E);
  static const Color scSecondary = Color(0xFFDB9C94);
  static const Color scAccent = Color(0xFFEFC1BA);

  // -- Shared status & money ------------------------------------------------
  // These deliberately KEEP their hue across every (monochromatic) theme so a
  // "yes" always reads green (acceptance) and a "no"/destructive action always
  // reads red (rejection).
  static const Color success = Color(0xFF2E9E5B); // acceptance (light themes)
  static const Color successDark = Color(0xFF57C98A); // acceptance (midnight)
  static const Color income = Color(0xFF4CAF7D);
  static const Color expense = Color(0xFFE08484);
  static const Color error = Color(0xFFD6483F); // rejection (light themes)
  static const Color errorMidnight = Color(0xFFFF6F61); // rejection (midnight)
  static const Color errorScarlet = Color(0xFFB3271E); // deeper, distinct red
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF1A0B0A);

  // -- Hairlines (pre-composed alpha so they can stay const) ----------------
  static const Color dividerOnLight = Color(0x1A000000); // black @ ~10%
  static const Color borderOnLight = Color(0x26000000); // black @ ~15%
  static const Color dividerOnDark = Color(0x1FFFFFFF); // white @ ~12%
  static const Color borderOnDark = Color(0x29FFFFFF); // white @ ~16%
  static const Color shadow = Color(0xFF000000);
}

/// ---------------------------------------------------------------------------
/// AppColors — the semantic, theme-aware colour roles.
///
/// This is a [ThemeExtension], registered on every theme built by
/// [AppTheme.forKind]. Widgets read it with `context.colors.<role>`; the value
/// for the active [ThemeKind] is supplied automatically and animates on change.
/// ---------------------------------------------------------------------------
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.banner,
    required this.inputFill,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.onBanner,
    required this.onBannerMuted,
    required this.onPrimary,
    required this.onAccent,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.error,
    required this.onError,
    required this.success,
    required this.income,
    required this.expense,
    required this.divider,
    required this.border,
    required this.shadow,
    required this.disabled,
    required this.chartPalette,
  });

  // Surfaces
  /// Base scaffold / page background.
  final Color background;

  /// Elevated panels: dialogs, bottom sheets, popovers.
  final Color surface;

  /// Secondary panels: dropdown menus, segmented backgrounds.
  final Color surfaceVariant;

  /// Content cards: budget cards, expense tiles, chips.
  final Color card;

  /// Branded dark-green header surfaces: app bar, nav bar, hero panels.
  final Color banner;

  /// Text-field fill.
  final Color inputFill;

  // Text & icons
  /// Primary foreground on [background] / [surface] / [card].
  final Color textPrimary;

  /// Secondary / caption foreground.
  final Color textSecondary;

  /// Disabled foreground.
  final Color textDisabled;

  /// Foreground placed on a [banner].
  final Color onBanner;

  /// Muted foreground placed on a [banner].
  final Color onBannerMuted;

  /// Foreground placed on a [primary] control.
  final Color onPrimary;

  /// Foreground placed on an [accent] / money surface (dark in both modes).
  final Color onAccent;

  // Brand
  final Color primary;
  final Color secondary;
  final Color accent;

  // Status & money
  final Color error;
  final Color onError;
  final Color success;
  final Color income;
  final Color expense;

  // Detail
  final Color divider;
  final Color border;
  final Color shadow;
  final Color disabled;

  /// Ordered palette for charts (pie / bars / legend dots).
  final List<Color> chartPalette;

  // -- Theme instances ------------------------------------------------------
  // Five monochromatic skins. Status/money colours (success, error, income,
  // expense) intentionally keep their hue in every theme so yes/no semantics
  // stay readable.

  /// Clean White — a simple, neutral light layout (grayscale monochrome).
  static const AppColors cleanWhite = AppColors(
    background: AppPalette.cwBackground,
    surface: AppPalette.cwSurface,
    surfaceVariant: AppPalette.cwSurfaceVariant,
    card: AppPalette.cwCard,
    banner: AppPalette.cwBanner,
    inputFill: AppPalette.cwInputFill,
    textPrimary: AppPalette.cwTextPrimary,
    textSecondary: AppPalette.cwTextSecondary,
    textDisabled: AppPalette.cwTextDisabled,
    onBanner: AppPalette.white,
    onBannerMuted: AppPalette.cwOnBannerMuted,
    onPrimary: AppPalette.white,
    onAccent: AppPalette.cwTextPrimary,
    primary: AppPalette.cwPrimary,
    secondary: AppPalette.cwSecondary,
    accent: AppPalette.cwAccent,
    error: AppPalette.error,
    onError: AppPalette.onErrorLight,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerOnLight,
    border: AppPalette.borderOnLight,
    shadow: AppPalette.shadow,
    disabled: AppPalette.cwTextDisabled,
    chartPalette: <Color>[
      AppPalette.cwBanner,
      AppPalette.cwPrimary,
      AppPalette.cwSecondary,
      AppPalette.cwTextDisabled,
      AppPalette.cwAccent,
      AppPalette.cwSurfaceVariant,
    ],
  );

  /// Midnight — a really dark theme with a true black background.
  static const AppColors midnight = AppColors(
    background: AppPalette.mdBackground,
    surface: AppPalette.mdSurface,
    surfaceVariant: AppPalette.mdSurfaceVariant,
    card: AppPalette.mdCard,
    banner: AppPalette.mdBanner,
    inputFill: AppPalette.mdInputFill,
    textPrimary: AppPalette.mdTextPrimary,
    textSecondary: AppPalette.mdTextSecondary,
    textDisabled: AppPalette.mdTextDisabled,
    onBanner: AppPalette.mdTextPrimary,
    onBannerMuted: AppPalette.mdOnBannerMuted,
    onPrimary: AppPalette.black,
    onAccent: AppPalette.black,
    primary: AppPalette.mdPrimary,
    secondary: AppPalette.mdSecondary,
    accent: AppPalette.mdAccent,
    error: AppPalette.errorMidnight,
    onError: AppPalette.onErrorDark,
    success: AppPalette.successDark,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerOnDark,
    border: AppPalette.borderOnDark,
    shadow: AppPalette.black,
    disabled: AppPalette.mdTextDisabled,
    chartPalette: <Color>[
      AppPalette.mdPrimary,
      AppPalette.mdAccent,
      AppPalette.mdSecondary,
      AppPalette.mdTextSecondary,
      AppPalette.mdTextDisabled,
      AppPalette.mdSurfaceVariant,
    ],
  );

  /// Sage Green — the classic green skin (browns/creams replaced with sage).
  static const AppColors sage = AppColors(
    background: AppPalette.sgBackground,
    surface: AppPalette.sgSurface,
    surfaceVariant: AppPalette.sgSurfaceVariant,
    card: AppPalette.sgCard,
    banner: AppPalette.sgBanner,
    inputFill: AppPalette.sgInputFill,
    textPrimary: AppPalette.sgTextPrimary,
    textSecondary: AppPalette.sgTextSecondary,
    textDisabled: AppPalette.sgTextDisabled,
    onBanner: AppPalette.sgOnBanner,
    onBannerMuted: AppPalette.sgOnBannerMuted,
    onPrimary: AppPalette.white,
    onAccent: AppPalette.sgTextPrimary,
    primary: AppPalette.sgPrimary,
    secondary: AppPalette.sgSecondary,
    accent: AppPalette.sgAccent,
    error: AppPalette.error,
    onError: AppPalette.onErrorLight,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerOnLight,
    border: AppPalette.borderOnLight,
    shadow: AppPalette.shadow,
    disabled: AppPalette.sgTextDisabled,
    chartPalette: <Color>[
      AppPalette.sgBanner,
      AppPalette.sgPrimary,
      AppPalette.sgSecondary,
      AppPalette.sgAccent,
      AppPalette.sgSurfaceVariant,
      AppPalette.sgTextPrimary,
    ],
  );

  /// Azure Blue — a cool, bluish monochrome skin.
  static const AppColors azure = AppColors(
    background: AppPalette.azBackground,
    surface: AppPalette.azSurface,
    surfaceVariant: AppPalette.azSurfaceVariant,
    card: AppPalette.azCard,
    banner: AppPalette.azBanner,
    inputFill: AppPalette.azInputFill,
    textPrimary: AppPalette.azTextPrimary,
    textSecondary: AppPalette.azTextSecondary,
    textDisabled: AppPalette.azTextDisabled,
    onBanner: AppPalette.azOnBanner,
    onBannerMuted: AppPalette.azOnBannerMuted,
    onPrimary: AppPalette.white,
    onAccent: AppPalette.azTextPrimary,
    primary: AppPalette.azPrimary,
    secondary: AppPalette.azSecondary,
    accent: AppPalette.azAccent,
    error: AppPalette.error,
    onError: AppPalette.onErrorLight,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerOnLight,
    border: AppPalette.borderOnLight,
    shadow: AppPalette.shadow,
    disabled: AppPalette.azTextDisabled,
    chartPalette: <Color>[
      AppPalette.azBanner,
      AppPalette.azPrimary,
      AppPalette.azSecondary,
      AppPalette.azAccent,
      AppPalette.azSurfaceVariant,
      AppPalette.azTextPrimary,
    ],
  );

  /// Scarlet Red — a soft, easy-on-the-eyes red monochrome skin.
  static const AppColors scarlet = AppColors(
    background: AppPalette.scBackground,
    surface: AppPalette.scSurface,
    surfaceVariant: AppPalette.scSurfaceVariant,
    card: AppPalette.scCard,
    banner: AppPalette.scBanner,
    inputFill: AppPalette.scInputFill,
    textPrimary: AppPalette.scTextPrimary,
    textSecondary: AppPalette.scTextSecondary,
    textDisabled: AppPalette.scTextDisabled,
    onBanner: AppPalette.scOnBanner,
    onBannerMuted: AppPalette.scOnBannerMuted,
    onPrimary: AppPalette.white,
    onAccent: AppPalette.scTextPrimary,
    primary: AppPalette.scPrimary,
    secondary: AppPalette.scSecondary,
    accent: AppPalette.scAccent,
    error: AppPalette.errorScarlet,
    onError: AppPalette.onErrorLight,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerOnLight,
    border: AppPalette.borderOnLight,
    shadow: AppPalette.shadow,
    disabled: AppPalette.scTextDisabled,
    chartPalette: <Color>[
      AppPalette.scBanner,
      AppPalette.scPrimary,
      AppPalette.scSecondary,
      AppPalette.scAccent,
      AppPalette.scSurfaceVariant,
      AppPalette.scTextPrimary,
    ],
  );

  /// Backwards-compatible aliases used by the [of] brightness fallback.
  static AppColors get light => cleanWhite;
  static AppColors get dark => midnight;

  /// Look up the active [AppColors] from the nearest [Theme].
  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    assert(
      colors != null,
      'AppColors is not registered on the current ThemeData. Use AppTheme.forKind().',
    );
    return colors ??
        (theme.brightness == Brightness.dark ? midnight : cleanWhite);
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? card,
    Color? banner,
    Color? inputFill,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? onBanner,
    Color? onBannerMuted,
    Color? onPrimary,
    Color? onAccent,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? error,
    Color? onError,
    Color? success,
    Color? income,
    Color? expense,
    Color? divider,
    Color? border,
    Color? shadow,
    Color? disabled,
    List<Color>? chartPalette,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      card: card ?? this.card,
      banner: banner ?? this.banner,
      inputFill: inputFill ?? this.inputFill,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      onBanner: onBanner ?? this.onBanner,
      onBannerMuted: onBannerMuted ?? this.onBannerMuted,
      onPrimary: onPrimary ?? this.onPrimary,
      onAccent: onAccent ?? this.onAccent,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      disabled: disabled ?? this.disabled,
      chartPalette: chartPalette ?? this.chartPalette,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      card: Color.lerp(card, other.card, t)!,
      banner: Color.lerp(banner, other.banner, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      onBanner: Color.lerp(onBanner, other.onBanner, t)!,
      onBannerMuted: Color.lerp(onBannerMuted, other.onBannerMuted, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      chartPalette: _lerpPalette(chartPalette, other.chartPalette, t),
    );
  }

  static List<Color> _lerpPalette(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return <Color>[
      for (int i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!,
    ];
  }
}

/// Convenience accessors so widgets can write `context.colors.background`.
extension AppThemeContextX on BuildContext {
  /// The active [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The active semantic colour roles (light or dark).
  AppColors get colors => AppColors.of(this);

  /// The active themed [TextTheme] (DM Sans, correctly coloured).
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the active theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// ---------------------------------------------------------------------------
/// AppTextStyles — colourless typographic presets (DM Sans).
///
/// Colours are intentionally NOT baked in so the same style works in light and
/// dark mode. Tint with a semantic colour when needed, e.g.
/// `AppTextStyles.title.copyWith(color: context.colors.onBanner)`.
/// For most cases prefer the themed [TextTheme] (`context.textTheme`).
/// ---------------------------------------------------------------------------
class AppTextStyles {
  AppTextStyles._();

  static final TextStyle header = GoogleFonts.dmSans(
    fontSize: kHeaderSize,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle subHeader = GoogleFonts.dmSans(
    fontSize: kSubHeaderSize,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle title = GoogleFonts.dmSans(
    fontSize: kTitleSize,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.dmSans(
    fontSize: kTextSize,
    fontWeight: FontWeight.w400,
  );

  /// Alias of [body], kept for the budget/expense features.
  static final TextStyle text = GoogleFonts.dmSans(
    fontSize: kTextSize,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle chart = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Alias of [chart].
  static final TextStyle chartTextStyle = chart;

  static final TextStyle button = GoogleFonts.dmSans(
    fontSize: kTitleSize,
    fontWeight: FontWeight.w600,
  );
}

/// ---------------------------------------------------------------------------
/// ThemeKind — the five selectable skins.
///
/// Each maps 1:1 to an [AppColors] instance and a [Brightness]. The value is
/// persisted per user (see ThemeController / SettingsService) by its [name].
/// ---------------------------------------------------------------------------
enum ThemeKind { cleanWhite, midnight, sage, azure, scarlet }

extension ThemeKindX on ThemeKind {
  /// Human-readable name shown in the theme picker.
  String get label => switch (this) {
    ThemeKind.cleanWhite => 'Clean White',
    ThemeKind.midnight => 'Midnight',
    ThemeKind.sage => 'Sage Green',
    ThemeKind.azure => 'Azure Blue',
    ThemeKind.scarlet => 'Scarlet Red',
  };

  /// The prominent colour used to render this theme's picker circle.
  Color get swatch => switch (this) {
    ThemeKind.cleanWhite => AppPalette.white,
    ThemeKind.midnight => AppPalette.black,
    ThemeKind.sage => AppPalette.sgPrimary,
    ThemeKind.azure => AppPalette.azPrimary,
    ThemeKind.scarlet => AppPalette.scPrimary,
  };

  /// The semantic palette for this skin.
  AppColors get colors => switch (this) {
    ThemeKind.cleanWhite => AppColors.cleanWhite,
    ThemeKind.midnight => AppColors.midnight,
    ThemeKind.sage => AppColors.sage,
    ThemeKind.azure => AppColors.azure,
    ThemeKind.scarlet => AppColors.scarlet,
  };

  /// Base brightness driving the ColorScheme / status-bar styling.
  Brightness get brightness =>
      this == ThemeKind.midnight ? Brightness.dark : Brightness.light;

  bool get isDark => this == ThemeKind.midnight;

  /// Resolves a persisted [name] back to a [ThemeKind], defaulting to
  /// [ThemeKind.cleanWhite] when the value is missing or unknown.
  static ThemeKind fromName(String? name) => ThemeKind.values.firstWhere(
    (k) => k.name == name,
    orElse: () => ThemeKind.cleanWhite,
  );
}

/// ---------------------------------------------------------------------------
/// AppTheme — builds the [ThemeData] for a given [ThemeKind], wiring the
/// [AppColors] extension and every component theme. [forKind] is the entry
/// point used by the app; [light]/[dark] are convenience aliases.
/// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._();

  /// Builds the full [ThemeData] for [kind].
  static ThemeData forKind(ThemeKind kind) =>
      _build(kind.brightness, kind.colors);

  static ThemeData get light => forKind(ThemeKind.cleanWhite);
  static ThemeData get dark => forKind(ThemeKind.midnight);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme =
        (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      tertiary: c.accent,
      onTertiary: c.onAccent,
      error: c.error,
      onError: c.onError,
      surface: c.background,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surface,
      outline: c.border,
      outlineVariant: c.divider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[c],
      scaffoldBackgroundColor: c.background,
      dividerColor: c.divider,
      textTheme: _textTheme(c),
      iconTheme: IconThemeData(color: c.textPrimary),
      primaryIconTheme: IconThemeData(color: c.onBanner),
      appBarTheme: AppBarThemeData(
        backgroundColor: c.banner,
        foregroundColor: c.onBanner,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        shadowColor: c.shadow,
        iconTheme: IconThemeData(color: c.onBanner),
        titleTextStyle: AppTextStyles.subHeader.copyWith(color: c.onBanner),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: c.background,
        elevation: 2,
        scrimColor: c.shadow.withValues(alpha: 0.4),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
        contentTextStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        elevation: 4,
        showDragHandle: true,
        dragHandleColor: c.textSecondary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: _inputTheme(c),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.primary.withValues(alpha: 0.45),
          disabledForegroundColor: c.onPrimary.withValues(alpha: 0.85),
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: c.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.banner,
        foregroundColor: c.onBanner,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.banner,
        selectedItemColor: c.accent,
        unselectedItemColor: c.onBannerMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: c.primary,
        disabledColor: c.disabled,
        surfaceTintColor: Colors.transparent,
        labelStyle: AppTextStyles.body.copyWith(
          color: c.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: AppTextStyles.body.copyWith(color: c.onPrimary),
        side: BorderSide.none,
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textPrimary,
        textColor: c.textPrimary,
        titleTextStyle: AppTextStyles.title.copyWith(
          color: c.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      ),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.border,
        circularTrackColor: c.border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.banner,
        contentTextStyle: AppTextStyles.body.copyWith(color: c.onBanner),
        actionTextColor: c.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surface,
        headerBackgroundColor: c.banner,
        headerForegroundColor: c.onBanner,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  /// DM Sans [TextTheme] tinted with the semantic foreground colours.
  static TextTheme _textTheme(AppColors c) {
    final TextTheme base = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: c.textPrimary,
      displayColor: c.textPrimary,
    );
    return base.copyWith(
      displayLarge: AppTextStyles.header.copyWith(color: c.textPrimary),
      displayMedium: AppTextStyles.header.copyWith(color: c.textPrimary),
      headlineLarge: AppTextStyles.header.copyWith(color: c.textPrimary),
      headlineMedium: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
      headlineSmall: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
      titleLarge: AppTextStyles.title.copyWith(color: c.textPrimary),
      titleMedium: AppTextStyles.title.copyWith(
        color: c.textPrimary,
        fontSize: kTitleSize - 2,
      ),
      titleSmall: AppTextStyles.body.copyWith(
        color: c.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTextStyles.title.copyWith(color: c.textPrimary),
      bodyMedium: AppTextStyles.body.copyWith(color: c.textPrimary),
      bodySmall: AppTextStyles.body.copyWith(color: c.textSecondary, fontSize: 12),
      labelLarge: AppTextStyles.button.copyWith(color: c.onPrimary),
      labelMedium: AppTextStyles.body.copyWith(
        color: c.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: AppTextStyles.body.copyWith(color: c.textSecondary, fontSize: 11),
    );
  }

  /// Shared input decoration used across auth, budget and expense forms.
  static InputDecorationThemeData _inputTheme(AppColors c) {
    OutlineInputBorder border(Color color, [double width = 1.0]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationThemeData(
      filled: true,
      fillColor: c.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      labelStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      floatingLabelStyle: AppTextStyles.body.copyWith(
        color: c.primary,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: AppTextStyles.body.copyWith(color: c.error, fontSize: 12),
      prefixIconColor: c.primary,
      suffixIconColor: c.textSecondary,
      iconColor: c.textSecondary,
      border: border(c.border),
      enabledBorder: border(c.border),
      focusedBorder: border(c.primary, 1.5),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, 1.5),
      disabledBorder: border(c.border),
    );
  }
}
