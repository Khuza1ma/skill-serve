import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../modules/projects/controllers/projects_controller.dart';

class ProjectDataSource extends DataGridSource {
  List<String> projects;
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
              DataGridCell<String>(
                  columnName: 'title', value: 'project.name'),
              DataGridCell<String>(
                  columnName: 'organizer_name', value: 'project.state'),
              DataGridCell<String>(columnName: 'location', value: '0'),
              DataGridCell<String>(columnName: 'time_commitment', value: '0'),
              DataGridCell<DateTime>(
                  columnName: 'start_date', value: DateTime.now()),
              DataGridCell<String>(columnName: 'status', value: '0'),
              DataGridCell<String>(
                  columnName: 'assigned_volunteer', value: '0'),
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
}
