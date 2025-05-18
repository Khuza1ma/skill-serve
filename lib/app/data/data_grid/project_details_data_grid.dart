import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_serve/app/data/local/user_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants/app_colors.dart';
import '../../data/models/project_model.dart';
import '../../ui/components/app_button.dart';

class ProjectDetailsDataSource extends DataGridSource {
  final List<Project> projects;
  final Function(Project) onApply;

  ProjectDetailsDataSource({
    required this.projects,
    required this.onApply,
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
            ),
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
            child: AppButton(
              onPressed: () => onApply(project),
              buttonText: 'Apply',
              buttonSize: Size(150, 46),
              isDisabled: project.status != 'Open' ||
                  (project.assignedVolunteerId?.length ?? 0) >=
                      (project.maxVolunteers ?? 0) ||
                  (project.assignedVolunteerId
                          ?.contains(UserProvider.currentUser?.currentUserId) ??
                      false),
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
