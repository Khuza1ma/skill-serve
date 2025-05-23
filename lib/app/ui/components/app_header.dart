import 'package:get/get.dart';
import 'package:web/web.dart' as web;

import '../../data/local/user_provider.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../routes/app_pages.dart';
import 'app_text_form_field.dart';
import 'app_modals.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        elevation: 5,
        toolbarHeight: 81,
        shadowColor: AppColors.k806dff.withValues(alpha: 0.1),
        backgroundColor: AppColors.k262837,
        surfaceTintColor: AppColors.k262837,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            controller.isSideBarOpen.toggle();
          },
          icon: const Icon(
            Icons.menu,
            size: 30,
            color: AppColors.kc6c6c8,
          ),
        ),
        titleSpacing: 0,
        title: controller.selectedTab.value == SideBarTab.dashboard
            ? const SizedBox.shrink()
            : SizedBox(
                width: 400,
                child: AppTextField(
                  name: 'search',
                  hintText: 'Search',
                  // controller: controller.searchController,
                  textInputAction: TextInputAction.send,
                  fillColor: AppColors.kF8F8FC,

                  // onSubmit: (value) {
                  //   // controller.search(value);
                  // },
                  onChanged: (value) {
                    // controller.isSearching(!(value?.isEmpty ?? false));
                    // if (value?.isEmpty ?? true) {
                    //   controller.search(value);
                    // }
                  },
                  prefix: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.ka1a5b7,
                  ),
                  suffix: /*!controller.isSearching()*/ true
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // controller.searchController.clear();
                            // controller.search(controller.searchController.text);
                          },
                        ),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              if (controller.isFullScreen()) {
                web.document.exitFullscreen();
              } else {
                web.document.documentElement?.requestFullscreen();
              }
              controller.isFullScreen.toggle();
            },
            icon: const Icon(
              Icons.fullscreen,
              size: 30,
              color: AppColors.kc6c6c8,
            ),
          ),
          const SizedBox(width: 20),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            tooltip: 'Show Profile',
            icon: const CircleAvatar(
              backgroundColor: AppColors.k806dff,
              radius: 18,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                enabled: false,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.k806dff,
                      child: Text(
                        UserProvider.currentUser?.currentUsername
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kFFFFFF,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserProvider.currentUser?.currentUsername ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.k806dff,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            UserProvider.currentUser?.currentUserEmail ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.k262837,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, color: AppColors.kFF0000),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColors.kFF0000,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              if (value == 'logout') {
                showCustomModal(
                  title: 'Confirm Logout',
                  content: 'Are you sure you want to logout? ',
                  buttonTitle: "Confirm",
                  onSubmit: () async {
                    await controller.logout();
                    Get.back();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  modalState: ModalState.PRIMARY,
                  alignment: Alignment.center,
                );
              }
              // Handle other menu options here
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
