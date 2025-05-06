import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/models/project_model.dart';

class CreateProjectController extends GetxController {
  // Form key to validate the form
  final formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final timeCommitmentController = TextEditingController();

  // For skills input
  final skillController = TextEditingController();
  final requiredSkills = <String>[].obs;

  // Date fields
  final startDateController = TextEditingController();
  final applicationDeadlineController = TextEditingController();

  // Status options
  final statusOptions = ['Open', 'Closed'];
  final selectedStatus = 'Open'.obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose all controllers
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    timeCommitmentController.dispose();
    skillController.dispose();
    startDateController.dispose();
    applicationDeadlineController.dispose();
    super.onClose();
  }

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

  // Select date helper method
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

  // Submit the form
  Future<void> submitProject() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // In a real app, you would generate a unique ID or get it from the backend
        final projectId = DateTime.now().millisecondsSinceEpoch.toString();
        final organizerId =
            'current-user-id'; // This would come from auth service

        final project = Project(
          projectId: projectId,
          title: titleController.text,
          organizerName: 'Current User', // This would come from user profile
          location: locationController.text,
          description: descriptionController.text,
          requiredSkills: requiredSkills,
          timeCommitment: timeCommitmentController.text,
          startDate: DateTime.parse(startDateController.text),
          applicationDeadline:
              DateTime.parse(applicationDeadlineController.text),
          status: selectedStatus.value,
          createdAt: DateTime.now(),
        );

        // Here you would save the project to your backend
        // await projectService.createProject(project);

        Get.snackbar(
          'Success',
          'Project created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate back or to project details
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to create project: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
