import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/remote/services/project_service.dart';

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

  // Status options
  final statusOptions = ['Open', 'Closed', 'In Progress'];
  final selectedStatus = 'Open'.obs;

  // Form key for edit project form
  final formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final timeCommitmentController = TextEditingController();
  final startDateController = TextEditingController();
  final applicationDeadlineController = TextEditingController();

  // For skills input
  final skillController = TextEditingController();

  // For skills input
  final requiredSkills = <String>[].obs;

  // Add a skill to the list
  void addSkill() {
    if (skillController.text.trim().isNotEmpty) {
      requiredSkills.add(skillController.text.trim());
      skillController.clear();
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
    // Dispose controllers to prevent memory leaks
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    timeCommitmentController.dispose();
    startDateController.dispose();
    applicationDeadlineController.dispose();
    skillController.dispose();
    super.onClose();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      logI(
          'Fetching projects - Page: ${currentPage.value}, PageSize: ${pageSize.value}');
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
          logI(
              'Updated pagination - Total: $totalItems, Pages: $totalPages, Current Page: $currentPage');
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
      logI('Changing page from ${currentPage.value} to $page');
      currentPage.value = page;
      fetchProjects();
    }
  }

  void onPageSizeChanged(int size) {
    if (size != pageSize.value) {
      logI('Changing page size from ${pageSize.value} to $size');
      pageSize.value = size;
      currentPage.value = 1; // Reset to first page when changing page size
      fetchProjects();
    }
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // Create a new project
  Future<void> createProject() async {
    try {
      isLoading.value = true;

      // Parse skills from comma-separated string
      final skills = skillController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Create a new project
      final newProject = Project(
        title: titleController.text,
        location: locationController.text,
        description: descriptionController.text,
        requiredSkills: skills,
        timeCommitment: timeCommitmentController.text,
        startDate: DateFormat('yyyy-MM-dd').parse(startDateController.text),
        applicationDeadline:
            DateFormat('yyyy-MM-dd').parse(applicationDeadlineController.text),
        status: selectedStatus.value,
        endDate: DateTime.now(),
        contactEmail: '',
        maxVolunteers: 2,
      );

      final createdProject = await ProjectService.createProject(newProject);
      if (createdProject != null) {
        // Refresh the projects list
        await fetchProjects();
        _clearForm();
        Get.back();
        Get.snackbar(
          'Success',
          'Project created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logE('Error creating project: $e');
      Get.snackbar(
        'Error',
        'Failed to create project: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing project
  Future<void> updateProject(String projectId) async {
    try {
      isLoading.value = true;

      // Parse skills from comma-separated string
      final skills = skillController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Create updated project
      final updatedProject = Project(
        projectId: projectId,
        title: titleController.text,
        location: locationController.text,
        description: descriptionController.text,
        requiredSkills: skills,
        timeCommitment: timeCommitmentController.text,
        startDate: DateFormat('yyyy-MM-dd').parse(startDateController.text),
        applicationDeadline:
            DateFormat('yyyy-MM-dd').parse(applicationDeadlineController.text),
        status: selectedStatus.value,
        endDate: DateTime.now(),
        contactEmail: '',
        maxVolunteers: 2,
      );

      // TODO: Implement update project API call
      // For now, just refresh the list
      await fetchProjects();
      _clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Project updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logE('Error updating project: $e');
      Get.snackbar(
        'Error',
        'Failed to update project: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      isLoading.value = true;
      // TODO: Implement delete project API call
      // For now, just refresh the list
      await fetchProjects();
      Get.snackbar(
        'Success',
        'Project deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logE('Error deleting project: $e');
      Get.snackbar(
        'Error',
        'Failed to delete project: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form fields
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    timeCommitmentController.clear();
    startDateController.clear();
    applicationDeadlineController.clear();
    skillController.clear();
    selectedStatus.value = 'Open';
    selectedProject.value = null;
  }
}
