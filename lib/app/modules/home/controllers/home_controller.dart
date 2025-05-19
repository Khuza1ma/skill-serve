import 'package:get/get.dart';

import '../../../data/config/logger.dart';
import '../../../data/remote/services/user_service.dart';

enum SideBarTab {
  dashboard,
  projects,
  appliedProjects,
  createProject,
  manageProject,
  volunteerApplications,
}

class HomeController extends GetxController {
  RxBool isSideBarOpen = true.obs;
  Rx<SideBarTab> selectedTab = SideBarTab.dashboard.obs;
  RxBool isSideBarItemVisible = true.obs;
  RxBool isFullScreen = false.obs;

  Future<bool> logout() async {
    try {
      return await UserService.logout();
    } catch (e) {
      logE(e);
      return false;
    }
  }
}
