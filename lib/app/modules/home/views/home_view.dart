import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../ui/components/app_footer.dart';
import '../../../ui/components/app_header.dart';
import '../../../ui/components/side_menu.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetResponsiveView<HomeController> {
  HomeView({super.key});

  @override
  Widget desktop() {
    return buildDesktopView();
  }

  @override
  Widget tablet() {
    return buildDesktopView();
  }

  Widget buildDesktopView() {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Row(
          children: [
            const SideBar(),
            _buildTabBody(),
          ],
        ),
      ),
    );
  }

  Expanded _buildTabBody() {
    return Expanded(
      child: Column(
        children: [
          const AppHeader(),
          _buildNavigator(),
          const AppFooter(),
        ],
      ),
    );
  }

  Expanded _buildNavigator() {
    return Expanded(
      child: Navigator(
        key: Get.nestedKey(1),
        onGenerateRoute: (settings) {
          // Save app pages routes in temp list
          var routes = [...AppPages.routes];

          var route =
              routes.firstWhereOrNull((route) => route.name == settings.name);

          if (route != null) {
            return GetPageRoute(
              settings: settings,
              page: route.page,
              binding: route.binding,
            );
          }

          return GetPageRoute(
            settings: settings,
            page: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
