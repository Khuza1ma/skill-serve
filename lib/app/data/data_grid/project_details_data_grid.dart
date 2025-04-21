import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/models/project_model.dart';
import '../../modules/projects_details/controllers/projects_details_controller.dart';

class ProjectDetailsDataSource extends DataGridSource {
  final Project project;
  ProjectsDetailsController controller = Get.find<ProjectsDetailsController>();

  ProjectDetailsDataSource({
    required this.project,
  });

  @override
  List<DataGridRow> get rows => [
        DataGridRow(
          cells: [
            DataGridCell<int>(
                columnName: 'sr_no',
                value: (controller.currentPageIndex.value *
                        controller.limit.value) +
                    1),
            DataGridCell<String>(
                columnName: 'ProjectId', value: project.projectId),
            DataGridCell<String>(columnName: 'Title', value: project.title),
            DataGridCell<String>(
                columnName: 'Organizer Name',
                value: project.organizerName ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Location', value: project.location),
            DataGridCell<String>(
                columnName: 'Description', value: project.description),
            DataGridCell<String>(
                columnName: 'Required Skills',
                value: project.requiredSkills.join(', ')),
            DataGridCell<String>(
                columnName: 'Time Commitment', value: project.timeCommitment),
            DataGridCell<DateTime>(
                columnName: 'Start Date', value: project.startDate),
            DataGridCell<DateTime>(
                columnName: 'Application Deadline',
                value: project.applicationDeadline),
            DataGridCell<String>(columnName: 'Status', value: project.status),
            DataGridCell<String>(
                columnName: 'Assigned Volunteer ID',
                value: project.assignedVolunteerId ?? 'Not Assigned'),
            DataGridCell<DateTime>(
                columnName: 'Created At', value: project.createdAt),
          ],
        ),
      ];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: AppColors.k1f1d2c,
      cells: row.getCells().map((DataGridCell cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: cell.value is Widget
              ? cell.value
              : cell.value is DateTime
                  ? Text(
                      _formatDateTime(cell.value),
                      style: GoogleFonts.poppins(
                        color: AppColors.kc6c6c8,
                      ),
                    )
                  : cell.value is List<String>
                      ? Text(
                          cell.value.join(', '),
                          style: GoogleFonts.poppins(
                            color: AppColors.kc6c6c8,
                          ),
                        )
                      : Text(
                          cell.value.toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.kc6c6c8,
                          ),
                        ),
        );
      }).toList(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
