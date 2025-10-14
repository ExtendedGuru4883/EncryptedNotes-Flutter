import 'package:flutter/material.dart';

@immutable
class ThemeSettings {
  final ThemeMode themeMode;
  final Color colorSchemeSeed;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.colorSchemeSeed = Colors.green,
  });

  ThemeSettings copyWith({ThemeMode? themeMode, Color? colorSchemeSeed}) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      colorSchemeSeed: colorSchemeSeed ?? this.colorSchemeSeed,
    );
  }

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'colorSchemeSeed': colorSchemeSeed.toARGB32(),
  };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) => ThemeSettings(
    themeMode: ThemeMode.values[json['themeMode'] ?? 0],
    colorSchemeSeed: Color(json['colorSchemeSeed'] ?? Colors.green.toARGB32()),
  );
}