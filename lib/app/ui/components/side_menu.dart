import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../modules/home/controllers/home_controller.dart';

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
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.k141218,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 17),
                    const Text(
                      'Click2Cater',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        _buildSideBarMenu(
                          title: 'Dashboard',
                          icon: Icons.dashboard,
                          onExpansionChanged: (value) {
                            // Get.offNamed(Routes.DASHBOARD, id: 1);
                            // controller.selectedTab(SideBarTab.dashboard);
                          },
                          isSelected:
                              controller.selectedTab() == SideBarTab.dashboard,
                        ),
                        _buildSideBarMenu(
                          title: 'Destination',
                          icon: Icons.location_on_sharp,
                          isSelected: false,
                          onExpansionChanged: (value) {},
                          children: [
                            // _buildSubmenuItems(
                            //   title: 'Location',
                            //   isSelected: controller.selectedTab() ==
                            //       SideBarTab.location,
                            //   onTap: () {
                            //     Get.offNamed(Routes.LOCATION, id: 1);
                            //     controller.selectedTab(SideBarTab.location);
                            //   },
                            // ),
                            _buildSubmenuItems(
                              title: 'City',
                              isSelected:
                                  controller.selectedTab() == SideBarTab.city,
                              onTap: () {
                                // Get.offNamed(Routes.CITY, id: 1);
                                // controller.selectedTab(SideBarTab.city);
                              },
                            ),
                          ],
                        ),
                        _buildSideBarMenu(
                          title: 'Occasion',
                          icon: Icons.event,
                          isSelected:
                              controller.selectedTab() == SideBarTab.occasion,
                          onExpansionChanged: (value) {
                            // Get.offNamed(Routes.OCCASION, id: 1);
                            // controller.selectedTab(SideBarTab.occasion);
                          },
                        ),
                        _buildSideBarMenu(
                          title: 'Menu',
                          icon: Icons.menu_book,
                          isSelected: false,
                          onExpansionChanged: (value) {},
                          children: [
                            _buildSubmenuItems(
                              title: 'Category',
                              isSelected: controller.selectedTab() ==
                                  SideBarTab.category,
                              onTap: () {
                                // Get.offNamed(Routes.CATEGORY, id: 1);
                                // controller.selectedTab(SideBarTab.category);
                              },
                            ),
                            _buildSubmenuItems(
                              title: 'Cuisine ',
                              isSelected: controller.selectedTab() ==
                                  SideBarTab.cuisine,
                              onTap: () {
                                // Get.offNamed(Routes.CUISINE, id: 1);
                                // controller.selectedTab(SideBarTab.cuisine);
                              },
                            ),
                            _buildSubmenuItems(
                              title: 'Dishes',
                              isSelected: controller.selectedTab() ==
                                  SideBarTab.menuItems,
                              onTap: () {
                                // Get.offNamed(RoutdTes.MENU_ITEMS, id: 1);
                                // controller.selecteab(SideBarTab.menuItems);
                              },
                            ),
                          ],
                        ),
                        _buildSideBarMenu(
                          title: 'Packages',
                          icon: Icons.card_giftcard,
                          isSelected:
                              controller.selectedTab() == SideBarTab.package,
                          onExpansionChanged: (value) {
                            // Get.offNamed(Routes.PACKAGES, id: 1);
                            // controller.selectedTab(SideBarTab.package);
                          },
                        ),
                        /*                              _buildSideBarMenu(
                          title: 'Orders',
                          icon: Icons.shopping_cart,
                          isSelected: controller.selectedIndex() == 6,
                          onExpansionChanged: (value) {
                            Get.offNamed(Routes.ORDER_HISTORY, id: 1);
                            controller.selectedIndex(1);
                          },
                        ),
                        _buildSideBarMenu(
                          title: 'Payment',
                          icon: Icons.payment,
                          isSelected: controller.selectedIndex() == 7,
                          onExpansionChanged: (value) {
                            Get.offNamed(Routes.PAYMENT, id: 1);
                            controller.selectedIndex(1);
                          },
                          children: [
                            _buildSubmenuItems(
                              title: 'Transaction History',
                              onTap: () {
                                Get.offNamed(Routes.TRANSACTIONS, id: 1);
                              },
                            ),
                          ],
                        ),
                        _buildSideBarMenu(
                          title: 'Activity',
                          icon: Icons.local_activity,
                          isSelected: controller.selectedIndex() == 8,
                          onExpansionChanged: (value) {
                            Get.offNamed(Routes.ACTIVITY, id: 1);
                            controller.selectedIndex(2);
                          },
                        ),
                        _buildSideBarMenu(
                          title: 'Profile',
                          icon: Icons.person,
                          isSelected: controller.selectedIndex() == 9,
                          onExpansionChanged: (value) {
                            controller.selectedIndex(3);
                            Get.offNamed(Routes.PROFILE, id: 1);
                          },
                        ),*/
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: Get.height,
              ),
      ),
    );
  }

  Widget _buildSubmenuItems({
    required String title,
    required Function onTap,
    required bool isSelected,
  }) {
    return ListTileTheme(
      dense: true,
      contentPadding: EdgeInsets.zero,
      child: ListTile(
        minVerticalPadding: 0,
        dense: true,
        contentPadding: const EdgeInsets.only(left: 40),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        tileColor: isSelected ? AppColors.kFFFFFF : Colors.transparent,
        leading: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 12,
          color: isSelected ? AppColors.k2A2D3E : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.k2A2D3E : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        onTap: () {
          if (isSelected) {
            return;
          }
          onTap.call();
        },
      ),
    );
  }

  Widget _buildSideBarMenu({
    required String title,
    required IconData icon,
    required Function(bool) onExpansionChanged,
    List<Widget> children = const <Widget>[],
    required bool isSelected,
  }) {
    return Obx(
      () => controller.isSideBarItemVisible()
          ? ListTileTheme(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 5,
              child: ExpansionTile(
                iconColor: isSelected ? AppColors.k2A2D3E : Colors.white,
                tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                onExpansionChanged: (value) {
                  if (!isSelected) {
                    onExpansionChanged.call(value);
                    isSelected = value;
                  }
                },
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.k2A2D3E : Colors.white,
                  ),
                ),
                maintainState: true,
                leading: Icon(
                  icon,
                  size: 15,
                  color: isSelected ? AppColors.k2A2D3E : Colors.white,
                ),
                collapsedIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide.none,
                ),
                trailing: children.isNotEmpty ? null : const SizedBox.shrink(),
                children: children,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
