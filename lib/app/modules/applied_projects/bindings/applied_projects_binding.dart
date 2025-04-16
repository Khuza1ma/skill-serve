import 'package:get/get.dart';

import '../controllers/applied_projects_controller.dart';

class AppliedProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppliedProjectsController>(
      () => AppliedProjectsController(),
    );
  }
}
