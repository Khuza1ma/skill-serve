import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_serve/app/ui/components/app_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../data/models/applied_project_model.dart';
import '../../modules/applied_projects/controllers/applied_projects_controller.dart';

class AppliedProjectDataSource extends DataGridSource {
  final List<AppliedProject> appliedProjects;
  final Function(AppliedProject) onWithdraw;
  final AppliedProjectsController controller =
      Get.find<AppliedProjectsController>();

  AppliedProjectDataSource({
    required this.appliedProjects,
    required this.onWithdraw,
  });

  @override
  List<DataGridRow> get rows => appliedProjects
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
                  columnName: 'application_id', value: project.id),
              DataGridCell<String>(
                  columnName: 'volunteer_id', value: project.volunteerId),
              DataGridCell<String>(
                  columnName: 'project_id',
                  value: project.projectId?.projectId ?? ''),
              DataGridCell<String>(columnName: 'status', value: project.status),
              DataGridCell<String>(
                columnName: 'date_applied',
                value: project.dateApplied?.toString() ?? '',
              ),
              DataGridCell<AppliedProject>(
                  columnName: 'actions', value: project),
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
      cells: row.getCells().map(
        (DataGridCell cell) {
          if (cell.columnName == 'actions') {
            final project = cell.value as AppliedProject;
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                buttonSize: Size(150, 46),
                onPressed: () => onWithdraw(project),
                buttonText: 'Withdraw',
                isDisabled: project.status != 'pending',
              ),
            );
          } else {
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
          }
        },
      ).toList(),
    );
  }
}
