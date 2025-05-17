import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/remote/services/project_service.dart';

import '../../../data/config/logger.dart';
import '../../../ui/components/app_snackbar.dart';

class CreateProjectController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  final isLoading = false.obs;
  final requiredSkills = <String>[].obs;

  void addSkill(String skill) {
    if (skill.trim().isNotEmpty) {
      requiredSkills.add(skill.trim());
    }
  }

  void removeSkill(String skill) {
    requiredSkills.remove(skill);
  }

  Future<void> selectDate(BuildContext context, String fieldName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      formKey.currentState?.fields[fieldName]?.didChange(formattedDate);
    }
  }

  Future<void> submitProject() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      try {
        isLoading.value = true;
        final formData = formKey.currentState!.value;

        final project = Project(
          projectId: '',
          title: formData['title'],
          location: formData['location'],
          description: formData['description'],
          requiredSkills: requiredSkills,
          timeCommitment: formData['timeCommitment'],
          startDate: DateTime.parse(formData['startDate']),
          endDate: DateTime.parse(formData['endDate']),
          applicationDeadline: DateTime.parse(formData['applicationDeadline']),
          maxVolunteers: int.parse(formData['maxVolunteers']),
        );

        Project? projectResponse = await ProjectService.createProject(project);

        if (projectResponse != null) {
          appSnackbar(
            title: 'Success',
            message: 'Project created successfully!',
            snackBarState: SnackBarState.SUCCESS,
          );
          formKey.currentState?.reset();
          requiredSkills.clear();
        } else {
          appSnackbar(
            title: 'Error',
            message: 'Failed to create project. Please try again.',
            snackBarState: SnackBarState.DANGER,
          );
        }
      } catch (e, st) {
        appSnackbar(
          title: 'Error',
          message: 'Failed to create project: $e',
          snackBarState: SnackBarState.DANGER,
        );
        logE('Error creating project: $e $st');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
