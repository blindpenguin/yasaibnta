import 'package:get/get.dart';

import '../../data/services/notes_db_service.dart';
import 'notes_controller.dart';

class NotesBinding extends Bindings {
  @override
  void dependencies() {
    // NotesDbService is initialized in main() via Get.putAsync.
    Get.lazyPut<NotesController>(
      () => NotesController(Get.find<NotesDbService>()),
    );
  }
}

