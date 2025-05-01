import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/models/project_model.dart';
import '../../modules/projects_details/controllers/projects_details_controller.dart';

class ProjectDetailsDataSource extends DataGridSource {
  final List<Project> project;
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
                columnName: 'project_id', value: proj.projectId),
            DataGridCell<String>(columnName: 'title', value: proj.title),
            DataGridCell<String>(
                columnName: 'organizer_name',
                value: proj.organizerName ?? 'N/A'),
            DataGridCell<String>(columnName: 'location', value: proj.location),
            DataGridCell<String>(
                columnName: 'description', value: proj.description),
            DataGridCell<List<String>>(
                columnName: 'required_skills',
                value: proj.requiredSkills),
            DataGridCell<String>(
                columnName: 'time_commitment', value: proj.timeCommitment),
            DataGridCell<DateTime>(
                columnName: 'start_date', value: proj.startDate),
            DataGridCell<DateTime>(
                columnName: 'application_deadline',
                value: proj.applicationDeadline),
            DataGridCell<String>(columnName: 'status', value: proj.status),
            DataGridCell<String>(
                columnName: 'assigned_volunteer_id',
                value: proj.assignedVolunteerId ?? 'Not Assigned'),
            DataGridCell<DateTime>(
                columnName: 'created_at', value: proj.createdAt),
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
