import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/config/logger.dart';
import '../../../data/data_grid/applied_projects_data_grid.dart';
import '../../../utils/data_grid_utils.dart';
import '../controllers/applied_projects_controller.dart';

class AppliedProjectsView extends GetView<AppliedProjectsController> {
  const AppliedProjectsView({super.key});
  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Applied Projects',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.appliedProjects.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return SfDataGridTheme(
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
                        headerGridLinesVisibility: GridLinesVisibility.none,
                        gridLinesVisibility: GridLinesVisibility.horizontal,
                        source: AppliedProjectDataSource(
                          appliedProjects: controller.appliedProjects,
                          controller: controller,
                        ),
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: _buildColumns(),
                      ),
                    ),
                  );
                }),
                _buildDataPager(context),
              ],
            ).paddingOnly(top: 16, right: 16, left: 16),
          ),
        )
      ],
    ).paddingAll(16);
  }

  Widget _buildDataPager(BuildContext context) {
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
                delegate: AppliedProjectDataSource(
                  appliedProjects: controller.appliedProjects,
                  controller: controller,
                ),
                availableRowsPerPage: DataGridUtils.pageSizes,
                pageCount:
                    (controller.appliedProjects.length / controller.limit.value)
                        .ceil()
                        .toDouble(),
                onRowsPerPageChanged: (int? rowsPerPage) {
                  logW('rowsPerPage: $rowsPerPage');
                  controller.limit(rowsPerPage);
                },
                controller: controller.dataPagerController,
                onPageNavigationStart: (int newPageIndex) {
                  controller.startPageIndex(newPageIndex);
                },
                onPageNavigationEnd: (int newPageIndex) {
                  if (controller.currentPageIndex() != newPageIndex &&
                      controller.startPageIndex() != newPageIndex) {
                    controller.currentPageIndex.value = newPageIndex;
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
    ];
  }

  GridColumn _buildColumn({
    required String columnName,
    required String label,
    double? width,
  }) {
    return GridColumn(
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
}
