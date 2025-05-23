import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../models/project_model.dart';
import '../../modules/manage_project/controllers/manage_project_controller.dart';

class ManageProjectDataSource extends DataGridSource {
  final List<Project> projects;
  final BuildContext context;
  final bool isDesktop;
  final Function(Project) onEdit;
  final Function(Project) onDelete;
  final ManageProjectController controller =
      Get.find<ManageProjectController>();

  ManageProjectDataSource({
    required this.projects,
    required this.context,
    required this.isDesktop,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  List<DataGridRow> get rows => projects
      .asMap()
      .map(
        (index, project) => MapEntry(
          index,
          DataGridRow(
            cells: [
              DataGridCell<int>(
                columnName: 'sr_no',
                value: (controller.currentPageIndex.value *
                        controller.limit.value) +
                    index +
                    1,
              ),
              DataGridCell<String>(
                  columnName: 'project_id', value: project.projectId ?? ''),
              DataGridCell<String>(
                  columnName: 'title', value: project.title ?? ''),
              DataGridCell<String>(
                  columnName: 'description', value: project.description ?? ''),
              DataGridCell<String>(
                  columnName: 'location', value: project.location ?? ''),
              DataGridCell<String>(
                columnName: 'required_skills',
                value: project.requiredSkills?.join(', ') ?? '',
              ),
              DataGridCell<String>(
                columnName: 'time_commitment',
                value: project.timeCommitment ?? '',
              ),
              DataGridCell<String>(
                columnName: 'start_date',
                value: project.startDate?.toString() ?? '',
              ),
              DataGridCell<String>(
                columnName: 'application_deadline',
                value: project.applicationDeadline?.toString() ?? '',
              ),
              DataGridCell<String>(
                  columnName: 'status', value: project.status ?? ''),
              DataGridCell<int>(
                columnName: 'total_applicants',
                value: project.assignedVolunteerId?.length ?? 0,
              ),
              DataGridCell<int>(
                columnName: 'max_volunteer',
                value: project.maxVolunteers ?? 0,
              ),
              DataGridCell<String>(
                columnName: 'assigned_volunteer',
                value: project.assignedVolunteerId?.join(', ') ?? '',
              ),
              DataGridCell<String>(
                columnName: 'created_at',
                value: project.createdAt?.toString() ?? '',
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.k806dff),
                      onPressed: () => onEdit(project),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(project),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      .values
      .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map(
        (DataGridCell cell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: cell.value is Widget
                ? cell.value
                : Text(
                    cell.value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.kc6c6c8,
                    ),
                  ),
          );
        },
      ).toList(),
    );
  }
}
