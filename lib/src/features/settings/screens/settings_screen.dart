import 'dart:async';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:encrypted_notes/src/features/auth/models/auth_state.dart';
import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:encrypted_notes/src/features/settings/providers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _currentUsername = '';
  int _secondsBeforeResetDelete = 0;
  Timer? _deleteTimer;

  @override
  void initState() {
    final authStateAsync = ref.read(authNotifierProvider);
    authStateAsync.whenOrNull(
      data: (authState) {
        if (authState case Authenticated(:final username)) {
          _currentUsername = username;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (settings) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.directional(start: 10, end: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 30,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      _currentUsername,
                      style: TextStyle(fontSize: 50),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedEmoji(AnimatedEmojis.wave, size: 50),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('Theme:'),
                  ChoiceChip(
                    label: Text('Dark'),
                    selected: settings.themeMode == ThemeMode.dark,
                    onSelected: (_) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                  ),
                  ChoiceChip(
                    label: Text('Light'),
                    selected: settings.themeMode == ThemeMode.light,
                    onSelected: (_) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                  ),
                  ChoiceChip(
                    label: Text('System'),
                    selected: settings.themeMode == ThemeMode.system,
                    onSelected: (_) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('Color:'),
                  BlockPicker(
                    pickerColor: settings.colorSchemeSeed,
                    onColorChanged: ref
                        .read(settingsNotifierProvider.notifier)
                        .setColorSchemeSeed,
                    layoutBuilder: (context, colors, child) => Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [for (Color color in colors) child(color)],
                        ),
                      ),
                    ),
                    itemBuilder: (color, isCurrentColor, changeColor) =>
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: changeColor,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 210),
                                opacity: isCurrentColor ? 1 : 0,
                                child: Icon(
                                  Icons.done,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                    availableColors: [
                      Colors.pink,
                      Colors.red,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.amber,
                      Colors.yellow,
                      Colors.lime,
                      Colors.lightGreen,
                      Colors.green,
                      Colors.teal,
                      Colors.cyan,
                      Colors.lightBlue,
                      Colors.blue,
                      Colors.indigo,
                      Colors.deepPurple,
                      Colors.purple,
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => ref
                        .read(authNotifierProvider.notifier)
                        .logout(message: "Logged out"),

                    child: Text('Log out'),
                  ),
                  FilledButton(
                    style: _secondsBeforeResetDelete > 0
                        ? FilledButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onError,
                          )
                        : null,
                    onPressed: _deleteUser,
                    child: _secondsBeforeResetDelete > 0
                        ? Text('Confirm? $_secondsBeforeResetDelete')
                        : Text('Delete account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteUser() async {
    if (_secondsBeforeResetDelete > 0) {
      try {
        await ref.read(authNotifierProvider.notifier).deleteUser();
      } catch (ex) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(ex.toString())));
          _deleteTimer?.cancel();
          setState(() => _secondsBeforeResetDelete = 0);
        }
      }
    } else {
      setState(() => _secondsBeforeResetDelete = 5);
      _deleteTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timer.tick == 5) timer.cancel();
        if (mounted) {
          setState(() => _secondsBeforeResetDelete--);
        }
      });
    }
  }

  @override
  void dispose() {
    _deleteTimer?.cancel();
    super.dispose();
  }
}
