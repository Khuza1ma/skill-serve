import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants/app_colors.dart';
import '../models/project_model.dart';

class ManageProjectDataSource extends DataGridSource {
  final List<Project> projects;
  final BuildContext context;
  final bool isDesktop;
  final Function(Project) onEdit;
  final Function(Project) onDelete;

  ManageProjectDataSource({
    required this.projects,
    required this.context,
    required this.isDesktop,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  List<DataGridRow> get rows => projects.asMap().entries.map((entry) {
        final index = entry.key;
        final project = entry.value;

        return DataGridRow(
          cells: [
            DataGridCell<int>(columnName: 'sr_no', value: index + 1),
            DataGridCell<String>(
                columnName: 'project_id', value: project.projectId),
            DataGridCell<String>(columnName: 'title', value: project.title),
            DataGridCell<String>(
                columnName: 'description', value: project.description),
            DataGridCell<String>(
                columnName: 'location', value: project.location),
            DataGridCell<List<String>>(
                columnName: 'required_skills', value: project.requiredSkills),
            DataGridCell<String>(
                columnName: 'time_commitment', value: project.timeCommitment),
            DataGridCell<DateTime>(
                columnName: 'start_date', value: project.startDate),
            DataGridCell<DateTime>(
                columnName: 'application_deadline',
                value: project.applicationDeadline),
            DataGridCell<String>(columnName: 'status', value: project.status),
            DataGridCell<int>(
              columnName: 'total_applicants',
              value: project.assignedVolunteerId?.length,
            ),
            DataGridCell<int>(
              columnName: 'max_volunteer',
              value: project.maxVolunteers,
            ), // Mock data
            DataGridCell<List<String>>(
                columnName: 'assigned_volunteer',
                value: project.assignedVolunteerId),
            DataGridCell<DateTime>(
                columnName: 'created_at', value: project.createdAt),
            DataGridCell<Project>(columnName: 'actions', value: project),
          ],
        );
      }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: AppColors.k1f1d2c,
      cells: row.getCells().map((DataGridCell cell) {
        if (cell.columnName == 'actions') {
          final project = cell.value as Project;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.k806dff, size: 20),
                  onPressed: () => onEdit(project),
                  tooltip: 'Edit',
                  constraints: BoxConstraints.tight(Size(30, 30)),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => onDelete(project),
                  tooltip: 'Delete',
                  constraints: BoxConstraints.tight(Size(30, 30)),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: cell.value is DateTime
                ? Text(
                    _formatDateTime(cell.value),
                    style: GoogleFonts.poppins(
                      color: AppColors.kc6c6c8,
                    ),
                  )
                : cell.value is List<String> || cell.value is List<int>
                    ? Text(
                        cell.value.join(', '),
                        style: GoogleFonts.poppins(
                          color: AppColors.kc6c6c8,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    : Text(
                        cell.value.toString(),
                        style: GoogleFonts.poppins(
                          color: AppColors.kc6c6c8,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
          );
        }
      }).toList(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
