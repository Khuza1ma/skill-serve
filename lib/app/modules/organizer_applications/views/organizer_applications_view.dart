import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/data_grid/organizer_applications_data_grid.dart';
import '../controllers/organizer_applications_controller.dart';
import '../../../data/models/organizer_application_model.dart';
import '../../../ui/components/app_modals.dart';
import '../../../utils/data_grid_utils.dart';
import '../../../constants/app_colors.dart';

class OrganizerApplicationsView
    extends GetView<OrganizerApplicationsController> {
  const OrganizerApplicationsView({super.key});

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
                      'Organizer Applications',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => controller.applications.isEmpty
                          ? Expanded(
                              child: const Center(
                                child: Text(
                                  'No applications available',
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
                                    source: OrganizerApplicationDataSource(
                                      applications: controller.applications,
                                      onAccept: (Application application) {
                                        _showApplicationConfirmation(
                                            application: application,
                                            title: 'Accept');
                                      },
                                      onReject: (Application application) {
                                        _showApplicationConfirmation(
                                            application: application,
                                            title: 'Reject');
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
                      OrganizerApplicationDataSource(
                        applications: controller.applications,
                        onAccept: (Application application) {
                          _showApplicationConfirmation(
                              application: application, title: 'Accept');
                        },
                        onReject: (Application application) {
                          _showApplicationConfirmation(
                              application: application, title: 'Reject');
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
      BuildContext context, OrganizerApplicationDataSource dataSource) {
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
      child: controller.applications.isEmpty
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
                    controller.loadApplications();
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
      _buildColumn(columnName: 'project_id', label: 'Project ID'),
      _buildColumn(columnName: 'project_title', label: 'Project Title'),
      _buildColumn(columnName: 'volunteer_name', label: 'Volunteer Name'),
      _buildColumn(columnName: 'volunteer_email', label: 'Volunteer Email'),
      _buildColumn(columnName: 'status', label: 'Status'),
      _buildColumn(columnName: 'date_applied', label: 'Date Applied'),
      _buildColumn(columnName: 'actions', label: 'Actions', width: 200),
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

  void _showApplicationConfirmation({
    required Application application,
    required String title,
  }) {
    showCustomModal(
      title: '$title Application',
      content:
          'Are you sure you want to ${title.toLowerCase()} this \napplication of "${application.volunteer.username.capitalizeFirst}"?',
      buttonTitle: title,
      onSubmit: () async {
        Get.back();
        if (application.applicationId.isNotEmpty) {
          controller.manageApplication(
            application: application,
            status: title,
          );
        }
      },
      modalState: title == 'Accept' ? ModalState.success : ModalState.danger,
      alignment: Alignment.center,
    );
  }
}
