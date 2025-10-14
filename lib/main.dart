import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:encrypted_notes/src/features/settings/providers/settings_notifier.dart';
import 'package:encrypted_notes/src/shared/router/providers/go_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    _initializeAndRemoveSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(goRouterProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Encrypted Notes',
      themeAnimationDuration: const Duration(seconds: 1),
      themeAnimationCurve: Curves.easeOutExpo,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: settingsAsync.value?.colorSchemeSeed ?? Colors.black,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: settingsAsync.value?.colorSchemeSeed ?? Colors.black,
      ),
      themeMode: settingsAsync.value?.themeMode ?? ThemeMode.system,
    );
  }

  Future<void> _initializeAndRemoveSplash() async {
    await dotenv.load(fileName: ".env");
    await ref.read(authNotifierProvider.future);
    await ref.read(settingsNotifierProvider.future);
    FlutterNativeSplash.remove();
  }
}
