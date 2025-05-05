import 'package:get/get.dart';

import '../controllers/manage_project_controller.dart';

class ManageProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageProjectController>(
      () => ManageProjectController(),
    );
  }
}
