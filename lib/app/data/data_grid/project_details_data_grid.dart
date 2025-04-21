import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/models/project_model.dart';
import '../../modules/projects_details/controllers/projects_details_controller.dart';

class ProjectDetailsDataSource extends DataGridSource {
  final List<Project?> project;
  ProjectsDetailsController controller = Get.find<ProjectsDetailsController>();

  ProjectDetailsDataSource({
    required this.project,
  });

  @override
  List<DataGridRow> get rows => project.map((proj) {
        return DataGridRow(
          cells: [
            DataGridCell<int>(
                columnName: 'sr_no',
                value: (controller.currentPageIndex.value *
                        controller.limit.value) +
                    project.indexOf(proj) +
                    1),
            DataGridCell<String>(
                columnName: 'ProjectId', value: proj?.projectId),
            DataGridCell<String>(columnName: 'Title', value: proj?.title),
            DataGridCell<String>(
                columnName: 'Organizer Name',
                value: proj?.organizerName ?? 'N/A'),
            DataGridCell<String>(columnName: 'Location', value: proj?.location),
            DataGridCell<String>(
                columnName: 'Description', value: proj?.description),
            DataGridCell<String>(
                columnName: 'Required Skills',
                value: proj?.requiredSkills.join(', ')),
            DataGridCell<String>(
                columnName: 'Time Commitment', value: proj?.timeCommitment),
            DataGridCell<DateTime>(
                columnName: 'Start Date', value: proj?.startDate),
            DataGridCell<DateTime>(
                columnName: 'Application Deadline',
                value: proj?.applicationDeadline),
            DataGridCell<String>(columnName: 'Status', value: proj?.status),
            DataGridCell<String>(
                columnName: 'Assigned Volunteer ID',
                value: proj?.assignedVolunteerId ?? 'Not Assigned'),
            DataGridCell<DateTime>(
                columnName: 'Created At', value: proj?.createdAt),
          ],
        );
      }).toList();
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
