import 'package:flutter/material.dart';

class Categories {
  Categories._();

  static const String food = 'Food';
  static const String transportation = 'Transportation';
  static const String school = 'School';
  static const String loadInternet = 'Load/Internet';
  static const String entertainment = 'Entertainment';
  static const String other = 'Other';

  static const List<String> all = [
    food,
    transportation,
    school,
    loadInternet,
    entertainment,
    other,
  ];

  static const Map<String, IconData> _icons = {
    food: Icons.restaurant_rounded,
    transportation: Icons.directions_bus_rounded,
    school: Icons.menu_book_rounded,
    loadInternet: Icons.wifi_rounded,
    entertainment: Icons.sports_esports_rounded,
    other: Icons.more_horiz_rounded,
  };

  static IconData iconFor(String category) =>
      _icons[category] ?? Icons.category_rounded;

  /// Fixed brand colour per category. Deliberately theme-independent so a
  /// category reads the same in every skin (unlike the chart palette).
  static const Map<String, Color> _colors = {
    food: Color(0xFFF97316), // Orange
    transportation: Color(0xFF3B82F6), // Blue
    school: Color(0xFF8B5CF6), // Purple
    loadInternet: Color(0xFF10B981), // Teal/Green
    entertainment: Color(0xFFEC4899), // Pink/Magenta
    other: Color(0xFF6B7280), // Neutral gray
  };

  static Color colorFor(String category) =>
      _colors[category] ?? _colors[other]!;
}
