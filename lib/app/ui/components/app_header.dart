import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../modules/home/controllers/home_controller.dart';
import 'dart:js_interop';

import 'app_modals.dart';
import 'app_text_form_field.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        elevation: 5,
        shadowColor: AppColors.k3b7ddd.withOpacity(0.1),
        backgroundColor: AppColors.kFFFFFF,
        surfaceTintColor: AppColors.kFFFFFF,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (controller.isSideBarOpen()) {
              //controller.isSideBarItemVisible.toggle();
            }
            controller.isSideBarOpen.toggle();
          },
          icon: const Icon(Icons.menu),
        ),
        titleSpacing: 0,
        title: controller.selectedTab.value == SideBarTab.dashboard
            ? const SizedBox.shrink()
            : SizedBox(
                width: 400,
                child: AppTextFormField(
                  name: 'search',
                  labelText: 'Search',
                  // controller: controller.searchController,
                  textInputAction: TextInputAction.send,
                  prefixIconConstraints: const BoxConstraints(minWidth: 20),
                  labelTextStyle: TextStyle(
                    fontSize: 12,
                    color: AppColors.k000000,
                    fontWeight: FontWeight.w300,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.k000000,
                    fontWeight: FontWeight.w300,
                  ),
                  isFilled: true,
                  fillColor: AppColors.kF8F8FC,
                  borderRadius: 10,
                  onSubmit: (value) {
                    // controller.search(value);
                  },
                  onChange: (value) {
                    // controller.isSearching(!(value?.isEmpty ?? false));
                    // if (value?.isEmpty ?? true) {
                    //   controller.search(value);
                    // }
                  },
                  suffixIcon: /*!controller.isSearching()*/ true
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
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.kF8F8FC,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.kF8F8FC,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.kF8F8FC,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintTextStyle: TextStyle(
                    fontSize: 12,
                    color: AppColors.k000000,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              if (controller.isFullScreen()) {
                // document.exitFullscreen();
              } else {
                // document.documentElement?.requestFullscreen();
              }
              controller.isFullScreen.toggle();
            },
            icon: const Icon(Icons.fullscreen),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              showCustomModal(
                title: 'Confirm Logout',
                content: 'Are you sure you want to logout? ',
                buttonTitle: "Confirm",
                onSubmit: () async {
                  Get.back();
                  // await controller.logout();
                },
                modalState: ModalState.PRIMARY,
                alignment: Alignment.center,
              );
            },
            icon: const Icon(
              Icons.power_settings_new,
            ),
            color: Colors.black,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
