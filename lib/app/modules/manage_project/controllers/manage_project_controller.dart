import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/remote/services/project_service.dart';

import '../../../ui/components/app_snackbar.dart';

class ManageProjectController extends GetxController {
  final isLoading = false.obs;
  RxList<Project> projects = <Project>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalItems = 0.obs;
  final pageSize = 10.obs;

  // Selected project for editing
  Rx<Project?> selectedProject = Rx<Project?>(null);

  // Form key for edit project form
  final formKey = GlobalKey<FormBuilderState>();

  // Status options
  final statusOptions = [
    'Open',
    'Closed',
    'Assigned',
    'Completed',
    'Cancelled'
  ];
  final selectedStatus = 'Open'.obs;

  // For skills input
  final requiredSkills = <String>[].obs;

  // Add a skill to the list
  void addSkill(String skill) {
    if (skill.trim().isNotEmpty) {
      requiredSkills.add(skill.trim());
    }
  }

  // Remove a skill from the list
  void removeSkill(String skill) {
    requiredSkills.remove(skill);
  }

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;

      final result = await ProjectService.fetchProjects(
        page: currentPage.value,
        limit: pageSize.value,
      );

      if (result != null &&
          result.containsKey('projects') &&
          result.containsKey('pagination')) {
        final projectsList = result['projects'];
        final pagination = result['pagination'];

        if (projectsList is List<Project> &&
            pagination is Map<String, dynamic>) {
          projects.value = projectsList;
          totalPages.value = pagination['pages'] as int? ?? 1;
          totalItems.value = pagination['total'] as int? ?? 0;
        } else {
          logE('Invalid data structure received from service');
          Get.snackbar(
            'Error',
            'Invalid data structure received from server',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        logE('No data received from service');
        Get.snackbar(
          'Error',
          'No data received from server',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, st) {
      logE('Error fetching projects: $e\n$st');
      Get.snackbar(
        'Error',
        'Failed to fetch projects: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int page) {
    if (page != currentPage.value) {
      currentPage.value = page;
      fetchProjects();
    }
  }

  void onPageSizeChanged(int size) {
    if (size != pageSize.value) {
      pageSize.value = size;
      currentPage.value = 1; // Reset to first page when changing page size
      fetchProjects();
    }
  }

  Future<void> selectDate(BuildContext context, String fieldName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      formKey.currentState?.fields[fieldName]?.didChange(
        DateFormat('yyyy-MM-dd').format(picked),
      );
    }
  }

  // Update an existing project
  Future<void> updateProject(String projectId) async {
    try {
      if (!formKey.currentState!.saveAndValidate()) {
        return;
      }

      isLoading.value = true;
      final formData = formKey.currentState!.value;

      // Create updated project
      final updatedProject = Project(
        projectId: projectId,
        title: formData['title'],
        location: formData['location'],
        description: formData['description'],
        requiredSkills: requiredSkills,
        timeCommitment: formData['timeCommitment'],
        startDate: DateFormat('yyyy-MM-dd').parse(formData['startDate']),
        applicationDeadline:
            DateFormat('yyyy-MM-dd').parse(formData['applicationDeadline']),
        status: selectedStatus.value,
        endDate: DateFormat('yyyy-MM-dd').parse(formData['endDate'] ??
            DateFormat('yyyy-MM-dd').format(DateTime.now())),
        contactEmail: formData['contactEmail'] ?? '',
        maxVolunteers: int.tryParse(formData['maxVolunteers'] ?? '2') ?? 2,
        category: formData['category'] ?? 'General',
      );

      final result =
          await ProjectService.updateProject(projectId, updatedProject);
      if (result != null) {
        // Update the project locally in the projects list
        final index = projects.indexWhere((p) => p.projectId == projectId);
        if (index != -1) {
          projects[index] = result;
        }

        _clearForm();
        Get.back();
        appSnackbar(
          title: 'Success',
          message: 'Project updated successfully',
          snackBarState: SnackBarState.SUCCESS,
        );
      } else {
        throw Exception('Failed to update project');
      }
    } catch (e) {
      logE('Error updating project: $e');
      appSnackbar(
        title: 'Error',
        message: 'Failed to update project: $e',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      isLoading.value = true;
      final result = await ProjectService.deleteProject(projectId);
      if (result) {
        projects.removeWhere((project) => project.projectId == projectId);
        Get.back();
        appSnackbar(
          title: 'Success',
          message: 'Project deleted successfully',
          snackBarState: SnackBarState.SUCCESS,
        );
      } else {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      logE('Error deleting project: $e');
      appSnackbar(
        title: 'Error',
        message: 'Failed to delete project: $e',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form fields
  void _clearForm() {
    formKey.currentState?.reset();
    requiredSkills.clear();
    selectedStatus.value = 'Open';
    selectedProject.value = null;
  }
}
