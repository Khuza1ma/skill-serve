import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/data_grid/applied_projects_data_grid.dart';
import '../../../data/models/applied_project_model.dart';
import '../../../ui/components/app_modals.dart';
import '../../../utils/data_grid_utils.dart';
import '../controllers/applied_projects_controller.dart';

class AppliedProjectsView extends GetView<AppliedProjectsController> {
  const AppliedProjectsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                color: AppColors.k262837,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applied Projects',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => controller.appliedProjects.isEmpty
                          ? Expanded(
                              child: const Center(
                                child: Text(
                                  'No applied projects available',
                                  style: TextStyle(
                                    color: AppColors.k6C757D,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(
                                  headerColor: AppColors.k806dff,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: SfDataGrid(
                                    shrinkWrapRows: true,
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.none,
                                    onQueryRowHeight: (details) {
                                      return 65;
                                    },
                                    gridLinesVisibility:
                                        GridLinesVisibility.horizontal,
                                    source: AppliedProjectDataSource(
                                      appliedProjects:
                                          controller.appliedProjects,
                                      onWithdraw: (AppliedProject project) {
                                        _showWithdrawConfirmation(project);
                                      },
                                    ),
                                    columnWidthMode: ColumnWidthMode.fill,
                                    isScrollbarAlwaysShown: true,
                                    showHorizontalScrollbar: true,
                                    rowsPerPage: controller.limit.value,
                                    columns: _buildColumns(),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    _buildDataPager(
                      context,
                      AppliedProjectDataSource(
                        appliedProjects: controller.appliedProjects,
                        onWithdraw: (AppliedProject project) {
                          _showWithdrawConfirmation(project);
                        },
                      ),
                    ),
                  ],
                ).paddingOnly(top: 16, right: 16, left: 16),
              ),
            )
          ],
        ).paddingAll(16);
      },
    );
  }

  Widget _buildDataPager(
      BuildContext context, AppliedProjectDataSource dataSource) {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        selectedItemColor: AppColors.kc6c6c8,
        backgroundColor: AppColors.k000000,
        itemColor: AppColors.k262837,
        disabledItemColor: AppColors.k1f1d2c,
        itemTextStyle: TextStyle(
          color: AppColors.kFFFFFF,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        disabledItemTextStyle: TextStyle(
          color: AppColors.kFFFFFF,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: controller.appliedProjects.isEmpty
          ? const SizedBox.shrink()
          : Container(
              color: AppColors.k000000,
              child: SfDataPager(
                delegate: dataSource,
                availableRowsPerPage: DataGridUtils.pageSizes,
                pageCount: controller.pageCount,
                onRowsPerPageChanged: (int? rowsPerPage) {
                  if (rowsPerPage != null) {
                    controller.onPageSizeChanged(rowsPerPage);
                  }
                },
                controller: controller.dataPagerController,
                onPageNavigationStart: (int newPageIndex) {
                  controller.startPageIndex.value = newPageIndex;
                  controller.dataPagerController.selectedPageIndex =
                      newPageIndex;
                },
                onPageNavigationEnd: (int newPageIndex) {
                  if (controller.currentPageIndex.value != newPageIndex &&
                      controller.startPageIndex.value != newPageIndex) {
                    controller.dataPagerController.selectedPageIndex =
                        newPageIndex;
                    controller.currentPageIndex.value = newPageIndex;
                    controller.loadAppliedProjects();
                  }
                },
              ),
            ),
    );
  }

  List<GridColumn> _buildColumns() {
    return [
      _buildColumn(columnName: 'sr_no', label: 'Sr. No.', width: 90),
      _buildColumn(columnName: 'application_id', label: 'Application ID'),
      _buildColumn(columnName: 'volunteer_id', label: 'Volunteer ID'),
      _buildColumn(columnName: 'project_id', label: 'Project ID'),
      _buildColumn(columnName: 'status', label: 'Status'),
      _buildColumn(columnName: 'date_applied', label: 'Date Applied'),
      _buildColumn(columnName: 'actions', label: 'Actions', width: 150),
    ];
  }

  GridColumn _buildColumn({
    required String columnName,
    required String label,
    double? width,
  }) {
    return GridColumn(
      columnWidthMode: ColumnWidthMode.fill,
      width: width ?? double.nan,
      columnName: columnName,
      label: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.kFFFFFF,
          ),
        ),
      ),
    );
  }

  void _showWithdrawConfirmation(AppliedProject project) {
    showCustomModal(
      title: 'Withdraw Project',
      content:
          'Are you sure you want to withdraw your application \nfrom "${project.projectId?.title}"?',
      buttonTitle: "Withdraw",
      onSubmit: () async {
        Get.back();
        if (project.id != null) {
          controller.withdrawProject(project.id!);
        }
      },
      modalState: ModalState.warning,
      alignment: Alignment.center,
    );
  }
}
