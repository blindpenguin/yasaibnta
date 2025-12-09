import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'app/data/services/notes_db_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isDesktop =
      !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  // Configure sqflite for desktop (Linux/Windows/macOS) using FFI.
  if (isDesktop) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Configure minimum window size on desktop platforms.
  if (isDesktop) {
    await windowManager.ensureInitialized();
    const minSize = Size(800, 600);
    const windowOptions = WindowOptions(
      minimumSize: minSize,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    // Explicitly enforce minimum size; needed on some desktop window managers.
    await windowManager.setMinimumSize(minSize);
  }

  await Get.putAsync<NotesDbService>(
    () async => NotesDbService().init(),
  );
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = _buildTheme();
    return GetMaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: AppRoutes.notes,
      getPages: AppPages.routes,
    );
  }
}

ThemeData _buildTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      // Neutral, serious desktop palette.
      seedColor: const Color(0xFF111827),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    dividerColor: Colors.black12,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: base.colorScheme.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: base.colorScheme.primary,
        foregroundColor: base.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: base.colorScheme.primary,
        side: BorderSide(color: base.colorScheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      // Clear selection state for the note list.
      selectedTileColor: const Color(0xFFD1D5DB),
      selectedColor: base.colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}


