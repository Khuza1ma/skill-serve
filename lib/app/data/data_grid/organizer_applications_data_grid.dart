import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_serve/app/constants/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/organizer_application_model.dart';

class OrganizerApplicationDataSource extends DataGridSource {
  OrganizerApplicationDataSource({
    required List<OrganizerApplication> applications,
    required Function(Application) onAccept,
    required Function(Application) onReject,
  }) {
    _applications = applications;
    _onAccept = onAccept;
    _onReject = onReject;
    _buildDataGridRows();
  }

  List<OrganizerApplication> _applications = [];
  late Function(Application) _onAccept;
  late Function(Application) _onReject;
  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = _applications.expand((project) {
      return project.applications.map((application) {
        final index =
            _applications.indexWhere((p) => p.projectId == project.projectId);
        return DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'sr_no', value: (index + 1).toString()),
          DataGridCell<String>(
              columnName: 'application_id', value: application.applicationId),
          DataGridCell<String>(
              columnName: 'project_id', value: project.projectId),
          DataGridCell<String>(
              columnName: 'project_title', value: project.projectTitle),
          DataGridCell<String>(
              columnName: 'volunteer_name',
              value: application.volunteer.username),
          DataGridCell<String>(
              columnName: 'volunteer_email',
              value: application.volunteer.email),
          DataGridCell<String>(columnName: 'status', value: application.status),
          DataGridCell<String>(
              columnName: 'date_applied', value: application.dateApplied),
          DataGridCell<Application>(columnName: 'actions', value: application),
        ]);
      });
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          final application = cell.value as Application;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: application.status != 'pending' ? 0.5 : 1,
            child: IgnorePointer(
              ignoring: application.status != 'pending',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _onAccept(application),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _onReject(application),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: AppColors.kc6c6c8,
            ),
          ),
        );
      }).toList(),
    );
  }
}
