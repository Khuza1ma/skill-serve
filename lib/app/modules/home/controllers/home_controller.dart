import 'package:get/get.dart';

enum SideBarTab {
  dashboard,
  projects,
  projectsDetails,
  appliedProjects,
  createProject,
  manageProject,
}

class HomeController extends GetxController {
  RxBool isSideBarOpen = true.obs;
  Rx<SideBarTab> selectedTab = SideBarTab.dashboard.obs;
  RxBool isSideBarItemVisible = true.obs;
  RxBool isFullScreen = false.obs;
}
