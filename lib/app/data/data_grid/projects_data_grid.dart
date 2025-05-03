import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/models/project_model.dart';
import '../../modules/projects/controllers/projects_controller.dart';

class ProjectDataSource extends DataGridSource {
  final List<Project> projects;
  ProjectsController controller = Get.find<ProjectsController>();

  ProjectDataSource({
    required this.projects,
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
                      1),
              DataGridCell<String>(columnName: 'title', value: project.title),
              DataGridCell<String>(
                  columnName: 'organizer_name',
                  value: project.organizerName ?? 'N/A'),
              DataGridCell<String>(
                  columnName: 'location', value: project.location),
              DataGridCell<String>(
                  columnName: 'time_commitment', value: project.timeCommitment),
              DataGridCell<DateTime>(
                  columnName: 'start_date', value: project.startDate),
              DataGridCell<String>(columnName: 'status', value: project.status),
              DataGridCell<String>(
                  columnName: 'assigned_volunteer',
                  value: project.assignedVolunteerId ?? 'Not Assigned'),
            ],
          ),
        ),
      )
      .values
      .toList();

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
