import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/data_grid/project_details_data_grid.dart';
import '../../../data/models/project_model.dart';
import '../../../ui/components/app_modals.dart';
import '../../../utils/data_grid_utils.dart';
import '../controllers/projects_details_controller.dart';

class ProjectsDetailsView extends GetView<ProjectsDetailsController> {
  const ProjectsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final projectDetailsDataSource = ProjectDetailsDataSource(
          projects: controller.selectedProject,
          onApply: (Project project) {
            _showApplyConfirmation(project);
          },
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
                      'Project Details',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    controller.selectedProject.isEmpty
                        ? Expanded(
                            child: const Center(
                              child: Text(
                                'No projects available',
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
                                  source: projectDetailsDataSource,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  onQueryRowHeight: (details) {
                                    return 65;
                                  },
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.none,
                                  gridLinesVisibility:
                                      GridLinesVisibility.horizontal,
                                  isScrollbarAlwaysShown: true,
                                  showHorizontalScrollbar: true,
                                  rowsPerPage: controller.limit.value,
                                  columns: _buildColumns(),
                                ),
                              ),
                            ),
                          ),
                    _buildDataPager(context, projectDetailsDataSource),
                  ],
                ).paddingOnly(top: 16, right: 16, left: 16),
              ),
            ),
          ],
        ).paddingAll(16);
      },
    );
  }

  Widget _buildDataPager(
      BuildContext context, ProjectDetailsDataSource dataSource) {
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
      child: controller.selectedProject.isEmpty
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
                    controller.loadProjectDetails();
                  }
                },
              ),
            ),
    );
  }

  List<GridColumn> _buildColumns() {
    return [
      _buildColumn(columnName: 'sr_no', label: 'Sr. No.', width: 100),
      _buildColumn(columnName: 'project_id', label: 'Project ID', width: 150),
      _buildColumn(columnName: 'title', label: 'Title', width: 180),
      _buildColumn(columnName: 'description', label: 'Description', width: 280),
      _buildColumn(columnName: 'location', label: 'Location', width: 180),
      _buildColumn(
          columnName: 'required_skills', label: 'Required Skills', width: 210),
      _buildColumn(
          columnName: 'time_commitment', label: 'Time Commitment', width: 180),
      _buildColumn(columnName: 'start_date', label: 'Start Date', width: 160),
      _buildColumn(
        columnName: 'application_deadline',
        label: 'Application Deadline',
        width: 180,
      ),
      _buildColumn(columnName: 'status', label: 'Status', width: 150),
      _buildColumn(
        columnName: 'total_applicants',
        label: 'Total Applicants',
        width: 150,
      ),
      _buildColumn(
        columnName: 'max_volunteer',
        label: 'Max Volunteers',
        width: 150,
      ),
      _buildColumn(
        columnName: 'assigned_volunteer',
        label: 'Assigned Volunteer Id',
        width: 200,
      ),
      _buildColumn(columnName: 'created_at', label: 'Created At', width: 150),
      _buildColumn(columnName: 'actions', label: 'Actions', width: 150),
    ];
  }

  GridColumn _buildColumn({
    required String columnName,
    required String label,
    double? width,
  }) {
    return GridColumn(
      columnWidthMode: ColumnWidthMode.fitByColumnName,
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

  void _showApplyConfirmation(Project project) {
    showCustomModal(
      title: 'Apply Project',
      content: 'Are you sure you want to apply to "${project.title}"?',
      buttonTitle: "Apply",
      onSubmit: () async {
        Get.back();
        controller.applyProject(project.projectId ?? '');
      },
      modalState: ModalState.primary,
      alignment: Alignment.center,
    );
  }
}
