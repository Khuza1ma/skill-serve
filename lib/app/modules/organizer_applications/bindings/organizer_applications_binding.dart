import 'package:get/get.dart';

import '../controllers/organizer_applications_controller.dart';

class OrganizerApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrganizerApplicationsController>(
      () => OrganizerApplicationsController(),
    );
  }
}
