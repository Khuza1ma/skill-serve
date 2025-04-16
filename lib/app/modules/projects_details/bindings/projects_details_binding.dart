import 'package:get/get.dart';

import '../controllers/projects_details_controller.dart';

class ProjectsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectsDetailsController>(
      () => ProjectsDetailsController(),
    );
  }
}
