import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/config/logger.dart';
import '../../../data/data_grid/projects_data_grid.dart';
import '../../../utils/data_grid_utils.dart';
import '../controllers/projects_controller.dart';

class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final projectDataSource = ProjectDataSource(
          projects: controller.projects,
        );

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
                      'Projects',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SfDataGridTheme(
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
                          source: projectDataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          isScrollbarAlwaysShown: true,
                          showHorizontalScrollbar: true,
                          columns: _buildColumns(),
                        ),
                      ),
                    ),
                    _buildDataPager(context, projectDataSource),
                  ],
                ).paddingOnly(top: 16, right: 16, left: 16),
              ),
            )
          ],
        ).paddingAll(16);
      },
    );
  }

  Widget _buildDataPager(BuildContext context, ProjectDataSource dataSource) {
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
      child: controller.projects.isEmpty
          ? const SizedBox.shrink()
          : Container(
              color: AppColors.k000000,
              child: SfDataPager(
                delegate: dataSource,
                availableRowsPerPage: DataGridUtils.pageSizes,
                pageCount: controller.pageCount,
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
      _buildColumn(columnName: 'title', label: 'Title'),
      _buildColumn(columnName: 'organizer_name', label: 'Organizer'),
      _buildColumn(columnName: 'location', label: 'Location'),
      _buildColumn(columnName: 'time_commitment', label: 'Time Commitment'),
      _buildColumn(columnName: 'start_date', label: 'Start Date'),
      _buildColumn(columnName: 'status', label: 'Status'),
      _buildColumn(
          columnName: 'assigned_volunteer', label: 'Assigned Volunteer'),
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
}
