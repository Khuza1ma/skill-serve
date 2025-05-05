import 'package:get/get.dart';

import '../controllers/organizer_dashboard_controller.dart';

class OrganizerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrganizerDashboardController>(
      () => OrganizerDashboardController(),
    );
  }
}
