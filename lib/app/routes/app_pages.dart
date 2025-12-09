import 'package:get/get.dart';

import '../modules/notes/notes_binding.dart';
import '../modules/notes/notes_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.notes,
      page: () => const NotesView(),
      binding: NotesBinding(),
    ),
  ];
}


