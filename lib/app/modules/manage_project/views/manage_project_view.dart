import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/ui/components/app_snackbar.dart';
import 'package:skill_serve/app/utils/data_grid_utils.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/config/logger.dart';
import '../../../data/data_grid/manage_project_data_grid.dart';
import '../../../data/models/project_model.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/app_modals.dart';
import '../../../ui/components/app_text_form_field.dart';
import '../controllers/manage_project_controller.dart';

class ManageProjectView extends GetView<ManageProjectController> {
  const ManageProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final isDesktop = screenWidth > 1024;
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final projectDataSource = ManageProjectDataSource(
          projects: controller.projects,
          context: context,
          isDesktop: isDesktop,
          onEdit: (Project project) =>
              _showEditProjectDialog(context, isDesktop, project),
          onDelete: (Project project) =>
              _showDeleteConfirmation(context, project),
          onViewDetails: (Project project) =>
              _navigateToProjectDetails(project),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manage Projects',
                    style: TextStyle(
                      color: AppColors.kFFFFFF,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppButton(
                    buttonText: 'Add New Project',
                    onPressed: () =>
                        _showEditProjectDialog(context, isDesktop, null),
                    buttonSize: const Size(150, 40),
                    leading: Icon(
                      Icons.add,
                      color: AppColors.kFFFFFF,
                    ),
                  ),
                ],
              ),
            ),
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
                    Expanded(
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
                            source: projectDataSource,
                            onQueryRowHeight: (details) {
                              return 65;
                            },
                            columnWidthMode: ColumnWidthMode.fitByColumnName,
                            headerGridLinesVisibility: GridLinesVisibility.none,
                            gridLinesVisibility: GridLinesVisibility.horizontal,
                            isScrollbarAlwaysShown: true,
                            showHorizontalScrollbar: true,
                            rowsPerPage: controller.pageSize.value,
                            columns: _buildColumns(),
                          ),
                        ),
                      ),
                    ),
                    _buildDataPager(context, projectDataSource),
                  ],
                ).paddingOnly(top: 16, right: 16, left: 16, bottom: 16),
              ),
            ),
          ],
        ).paddingAll(16);
      },
    );
  }

  Widget _buildDataPager(
      BuildContext context, ManageProjectDataSource dataSource) {
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
                pageCount: controller.totalPages.value.toDouble(),
                onPageNavigationStart: (int pageIndex) {
                  if (pageIndex + 1 != controller.currentPage.value) {
                    controller.onPageChanged(pageIndex + 1);
                  }
                },
                onRowsPerPageChanged: (int? rowsPerPage) {
                  if (rowsPerPage != null &&
                      rowsPerPage != controller.pageSize.value) {
                    controller.onPageSizeChanged(rowsPerPage);
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
          width: 180),
      _buildColumn(columnName: 'status', label: 'Status', width: 150),
      _buildColumn(
          columnName: 'total_applicants',
          label: 'Total Applicants',
          width: 150),
      _buildColumn(
          columnName: 'assigned_volunteer', label: 'Assigned', width: 150),
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
      columnName: label,
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

  void _showEditProjectDialog(
      BuildContext context, bool isDesktop, Project? project) {
    // If editing an existing project, populate the form fields
    if (project != null) {
      controller.titleController.text = project.title ?? '';
      controller.descriptionController.text = project.description ?? '';
      controller.locationController.text = project.location ?? '';
      controller.timeCommitmentController.text = project.timeCommitment ?? '';
      controller.startDateController.text =
          DateFormat('yyyy-MM-dd').format(project.startDate ?? DateTime.now());
      controller.applicationDeadlineController.text = DateFormat('yyyy-MM-dd')
          .format(project.applicationDeadline ?? DateTime.now());

      // For skills, we need to handle the list
      controller.skillController.text =
          project.requiredSkills?.join(', ') ?? '';
    }

    final dialogWidth = isDesktop ? 800.0 : Get.width * 0.9;

    showCustomModal(
      title: project != null ? 'Edit Project' : 'Add New Project',
      alignment: Alignment.center,
      showButtons: false,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project Title
                AppTextField(
                  name: 'title',
                  label: 'Project Title',
                  hintText: 'Enter project title',
                  controller: controller.titleController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                AppTextField(
                  name: 'description',
                  label: 'Description',
                  hintText: 'Enter project description',
                  controller: controller.descriptionController,
                  isRequired: true,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location
                AppTextField(
                  name: 'location',
                  label: 'Location',
                  hintText: 'Enter project location',
                  controller: controller.locationController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Required Skills
                AppTextField(
                  name: 'skills',
                  label: 'Required Skills',
                  hintText: 'Enter skills separated by commas',
                  controller: controller.skillController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one skill';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time Commitment
                AppTextField(
                  name: 'timeCommitment',
                  label: 'Time Commitment',
                  hintText: 'e.g., 10 hours per week',
                  controller: controller.timeCommitmentController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter time commitment';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Start Date
                AppTextField(
                  name: 'startDate',
                  label: 'Start Date',
                  hintText: 'YYYY-MM-DD',
                  controller: controller.startDateController,
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) => controller.selectDate(
                      context, controller.startDateController),
                  suffix: const Icon(Icons.calendar_today),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Application Deadline
                AppTextField(
                  name: 'applicationDeadline',
                  label: 'Application Deadline',
                  hintText: 'YYYY-MM-DD',
                  controller: controller.applicationDeadlineController,
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) => controller.selectDate(
                      context, controller.applicationDeadlineController),
                  suffix: const Icon(Icons.calendar_today),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an application deadline';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.kFFFFFF,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: controller.selectedStatus.value,
                          items: controller.statusOptions
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedStatus.value = value;
                            }
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      buttonText: 'Cancel',
                      onPressed: () => Get.back(),
                      buttonColor: AppColors.k262837,
                      border: BorderSide(color: AppColors.k806dff),
                      buttonSize: const Size(100, 40),
                    ),
                    const SizedBox(width: 16),
                    AppButton(
                      buttonText:
                          project != null ? 'Update Project' : 'Create Project',
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          if (project != null) {
                            // Update existing project
                            controller
                                .updateProject(project.projectId ?? '')
                                .then((_) {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Project updated successfully',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            });
                          } else {
                            // Create new project
                            controller.createProject().then((_) {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Project created successfully',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            });
                          }
                        }
                      },
                      buttonSize: const Size(150, 40),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      onSubmit: () {},
    );
  }

  void _showDeleteConfirmation(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteProject(project.projectId ?? '').then((_) {
                appSnackbar(
                  title: 'Success',
                  message: 'Project deleted successfully',
                  snackBarState: SnackBarState.SUCCESS,
                );
              });
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToProjectDetails(Project project) {
    // Navigate to project details page
    logW('Navigating to project details: ${project.projectId}');
  }
}
