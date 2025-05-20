import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/utils/data_grid_utils.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/app_colors.dart';
import '../../../data/data_grid/manage_project_data_grid.dart';
import '../../../data/models/project_model.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/app_modals.dart';
import '../../../ui/components/app_text_form_field.dart';
import '../../home/controllers/home_controller.dart';
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
          onDelete: (Project project) => _showDeleteConfirmation(project),
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
                    onPressed: () {
                      Get.offNamed(Routes.CREATE_PROJECT, id: 1);
                      Get.find<HomeController>().selectedTab.value =
                          SideBarTab.createProject;
                    },
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
                            rowsPerPage: controller.limit.value,
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
          color: AppColors.ka1a5b7,
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
                pageCount: controller.totalPages.value,
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
                    controller.fetchProjects(
                      skip: newPageIndex * controller.limit.value,
                      limit: controller.limit.value,
                    );
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
          width: 150),
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
      controller.selectedStatus.value = project.status ?? 'Open';
      controller.requiredSkills.value = project.requiredSkills ?? [];
    }

    final dialogWidth = isDesktop ? 800.0 : Get.width * 0.9;

    showCustomModal(
      title: project != null ? 'Edit Project' : 'Add New Project',
      alignment: Alignment.center,
      buttonTitle: 'Update Project',
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: Get.height * 0.6),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: controller.formKey,
            initialValue: project != null
                ? {
                    'title': project.title,
                    'description': project.description,
                    'location': project.location,
                    'timeCommitment': project.timeCommitment,
                    'startDate': DateFormat('yyyy-MM-dd')
                        .format(project.startDate ?? DateTime.now()),
                    'applicationDeadline': DateFormat('yyyy-MM-dd')
                        .format(project.applicationDeadline ?? DateTime.now()),
                    'endDate': DateFormat('yyyy-MM-dd')
                        .format(project.endDate ?? DateTime.now()),
                    'category': project.category ?? 'General',
                    'maxVolunteers': project.maxVolunteers?.toString() ?? '2',
                    'contactEmail': project.contactEmail ?? '',
                  }
                : {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                AppTextField(
                  name: 'title',
                  label: 'Project Title',
                  hintText: 'Enter project title',
                  isRequired: true,
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter a title',
                  ),
                ),
                AppTextField(
                  name: 'description',
                  label: 'Description',
                  hintText: 'Enter project description',
                  isRequired: true,
                  maxLines: 5,
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter a description',
                  ),
                ),
                AppTextField(
                  name: 'location',
                  label: 'Location',
                  hintText: 'Enter project location',
                  isRequired: true,
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter a location',
                  ),
                ),
                AppTextField(
                  name: 'skill',
                  label: 'Required Skills',
                  hintText: 'Enter a skill and press Add',
                  suffix: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final skill = controller
                          .formKey.currentState?.fields['skill']?.value;
                      if (skill != null) {
                        controller.addSkill(skill);
                        controller.formKey.currentState?.fields['skill']
                            ?.reset();
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.k262837.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Skills:',
                        style: TextStyle(
                          color: AppColors.kFFFFFF.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(
                        () => controller.requiredSkills.isEmpty
                            ? Text(
                                'No skills added yet',
                                style: TextStyle(
                                  color:
                                      AppColors.kFFFFFF.withValues(alpha: 0.5),
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: controller.requiredSkills
                                    .map(
                                      (skill) => Chip(
                                        label: Text(skill),
                                        deleteIcon:
                                            const Icon(Icons.close, size: 18),
                                        onDeleted: () =>
                                            controller.removeSkill(skill),
                                        backgroundColor: AppColors.k806dff
                                            .withValues(alpha: 0.2),
                                        labelStyle:
                                            TextStyle(color: AppColors.kFFFFFF),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                ),
                AppTextField(
                  name: 'timeCommitment',
                  label: 'Time Commitment',
                  hintText: 'e.g., 10 hours per week',
                  isRequired: true,
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter time commitment',
                  ),
                ),
                AppTextField(
                  name: 'startDate',
                  label: 'Start Date',
                  hintText: 'YYYY-MM-DD',
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) => controller.selectDate(context, 'startDate'),
                  suffix: const Icon(Icons.calendar_today),
                  validator: FormBuilderValidators.required(
                    errorText: 'Please select a start date',
                  ),
                ),
                AppTextField(
                  name: 'applicationDeadline',
                  label: 'Application Deadline',
                  hintText: 'YYYY-MM-DD',
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) =>
                      controller.selectDate(context, 'applicationDeadline'),
                  suffix: const Icon(Icons.calendar_today),
                  validator: FormBuilderValidators.required(
                    errorText: 'Please select an application deadline',
                  ),
                ),
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
                    Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.kFFFFFF,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: controller.selectedStatus.value,
                        style: TextStyle(
                          color: AppColors.k262837,
                          fontSize: 16,
                        ),
                        items: controller.statusOptions
                            .map((status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: AppColors.k262837,
                                      fontSize: 16,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedStatus.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                AppTextField(
                  name: 'category',
                  label: 'Category',
                  hintText: 'Enter project category',
                  isRequired: true,
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter a category',
                  ),
                ),
                AppTextField(
                  name: 'maxVolunteers',
                  label: 'Max Volunteers',
                  hintText: 'Enter maximum number of volunteers',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: 'Please enter max volunteers',
                      ),
                      FormBuilderValidators.numeric(
                        errorText: 'Please enter a valid number',
                      ),
                    ],
                  ),
                ),
                AppTextField(
                  name: 'contactEmail',
                  label: 'Contact Email',
                  hintText: 'Enter contact email',
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: 'Please enter contact email',
                      ),
                      FormBuilderValidators.email(
                        errorText: 'Please enter a valid email',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onSubmit: () {
        if (project != null) {
          controller.updateProject(project.projectId ?? '');
        }
      },
    );
  }

  void _showDeleteConfirmation(Project project) {
    showCustomModal(
      title: 'Delete Project',
      content: 'Are you sure you want to delete "${project.title}"?',
      buttonTitle: "Delete",
      onSubmit: () async {
        Get.back();
        controller.deleteProject(project.projectId ?? '');
      },
      modalState: ModalState.DANGER,
      alignment: Alignment.center,
    );
  }
}
