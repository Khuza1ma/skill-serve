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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            // shadowColor: Colors.black12,
            color: AppColors.k262837,
            // surfaceTintColor: AppColors.kFFFFFF,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Projects',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: AppColors.k806dff,
                    ),
                    // child: Obx(
                    //   () => SfDataGrid(
                    //     headerGridLinesVisibility: GridLinesVisibility.none,
                    //     gridLinesVisibility: GridLinesVisibility.horizontal,
                    //     source: ProjectDataSource(
                    //       projects: [],
                    //     ),
                    //     columnWidthMode: ColumnWidthMode.fill,
                    //     columns: _buildColumns(),
                    //   ),
                    // ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: SfDataGrid(
                        headerGridLinesVisibility: GridLinesVisibility.none,
                        gridLinesVisibility: GridLinesVisibility.horizontal,
                        source: ProjectDataSource(
                          projects: ['1', '2', '3'],
                        ),
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: _buildColumns(),
                      ),
                    ),
                  ),
                ),
                // Obx(
                //   () => _buildDataPager(context),
                // ),
                _buildDataPager(context)
              ],
            ).paddingOnly(top: 16, right: 16, left: 16),
          ),
        )
      ],
    ).paddingAll(16);
  }

  Widget _buildDataPager(BuildContext context) {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(selectedItemColor: AppColors.k1f1d2c),
      child: true
          ? const SizedBox.shrink()
          : SfDataPager(
              delegate: ProjectDataSource(projects: []),
              availableRowsPerPage: DataGridUtils.pageSizes,
              pageCount: 0,
              onRowsPerPageChanged: (int? rowsPerPage) {
                logW('rowsPerPage: $rowsPerPage');
                controller.limit(rowsPerPage);
                // controller.fetchAndStoreCity(
                //   skip: 0,
                //   limit: controller.limit(),
                // );
              },
              controller: controller.dataPagerController,
              onPageNavigationStart: (int newPageIndex) {
                controller.startPageIndex(newPageIndex);
              },
              onPageNavigationEnd: (int newPageIndex) {
                if (controller.currentPageIndex() != newPageIndex &&
                    controller.startPageIndex() != newPageIndex) {
                  controller.currentPageIndex.value = newPageIndex;
                  // controller.fetchAndStoreCity(
                  //   skip: newPageIndex * controller.limit(),
                  //   limit: controller.limit(),
                  // );
                }
              },
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
