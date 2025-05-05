import 'package:get/get.dart';

import '../controllers/volunteer_dashboard_controller.dart';

class VolunteerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VolunteerDashboardController>(
      () => VolunteerDashboardController(),
    );
  }
}
