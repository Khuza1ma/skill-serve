import 'package:get/get.dart';

enum SideBarTab {
  dashboard,
  volunteer,
  workshop,
  transactions,
}

class HomeController extends GetxController {
  RxBool isSideBarOpen = true.obs;
  Rx<SideBarTab> selectedTab = SideBarTab.dashboard.obs;
  RxBool isSideBarItemVisible = true.obs;
  RxBool isFullScreen = false.obs;
}
