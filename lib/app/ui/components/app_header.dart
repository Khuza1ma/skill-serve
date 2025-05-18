import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

import '../../constants/app_colors.dart';
import '../../data/local/user_provider.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../routes/app_pages.dart';
import 'app_modals.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                          UserProvider.currentUser?.currentUsername
                                  ?.capitalizeFirst ??
                              '',
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
    );
  }
}
