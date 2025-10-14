import 'dart:convert';

import 'package:encrypted_notes/src/features/settings/domain/settings_state.dart';
import 'package:encrypted_notes/src/shared/storage/shared_preferences/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  late final SharedPreferences _sharedPreferences;

  @override
  FutureOr<ThemeSettings> build() async {
    _sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    final stringJson = _sharedPreferences.getString('themeSettings');
    if (stringJson != null) {
      try {
        final mapJson = jsonDecode(stringJson) as Map<String, dynamic>;
        return ThemeSettings.fromJson(mapJson);
      } catch (_) {
        return ThemeSettings();
      }
    }

    return ThemeSettings();
  }

  Future<void> toggleThemeMode() async {
    final current = state.value;
    if (current == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(themeMode: ThemeMode.values[_nextThemeModeValueIndex()]),
    );

    await _save();
  }

  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    final current = state.value;
    if (current == null || current.themeMode == newThemeMode) {
      return;
    }

    state = AsyncData(current.copyWith(themeMode: newThemeMode));

    await _save();
  }

  Future<void> setColorSchemeSeed(Color newColor) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    state = AsyncData(current.copyWith(colorSchemeSeed: newColor));

    await _save();
  }

  int _nextThemeModeValueIndex() {
    final current = state.value;
    if (current == null) {
      return 0;
    }

    final nextIndex = current.themeMode.index + 1;
    return nextIndex >= 3 ? 0 : nextIndex;
  }

  Future<void> _save() async {
    final current = state.value;
    if (current == null) {
      return;
    }

    final jsonString = jsonEncode(current.toJson());
    await _sharedPreferences.setString('themeSettings', jsonString);
    return;
  }
}
