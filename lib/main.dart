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
    return GetMaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.notes,
      getPages: AppPages.routes,
    );
  }
}


