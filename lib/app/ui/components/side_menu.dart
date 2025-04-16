import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:skill_serve/app/constants/asset_constants.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_pages.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: controller.isSideBarOpen()
            ? Container(
                width: 250,
                decoration: BoxDecoration(
                  color: AppColors.k262837,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Image.asset(AppAssets.logo, height: 40, width: 40),
                        Text(
                          'Skill Serve',
                          style: GoogleFonts.montserrat(
                            color: AppColors.kc6c6c8,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 20),
                    Divider(
                      color: AppColors.kc6c6c8.withValues(alpha: 0.2),
                      height: 1,
                      thickness: 1,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.dashboard,
                              label: 'Dashboard',
                              tab: SideBarTab.dashboard,
                              route: Routes.DASHBOARD,
                            ),
                            _buildMenuItem(
                              icon: Icons.group,
                              label: 'Volunteer',
                              tab: SideBarTab.volunteer,
                              route: 'Routes.Volunteer',
                            ),
                            _buildMenuItem(
                              icon: Icons.event,
                              label: 'Workshop',
                              tab: SideBarTab.workshop,
                              route: 'Routes.Workshop',
                            ),
                            _buildMenuItem(
                              icon: Icons.money,
                              label: 'Transactions',
                              tab: SideBarTab.transactions,
                              route: 'Routes.Transactions',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                width: 0,
                height: double.infinity,
              ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required SideBarTab tab,
    required String route,
  }) {
    return Obx(
      () {
        final isSelected = controller.selectedTab() == tab;
        return InkWell(
          onTap: () {
            if (!isSelected) {
              // Get.offNamed(route, id: 1);
              controller.selectedTab(tab);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.k806dff : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? AppColors.kFFFFFF : AppColors.kc6c6c8,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.aBeeZee(
                    color: isSelected ? AppColors.kFFFFFF : AppColors.kc6c6c8,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
