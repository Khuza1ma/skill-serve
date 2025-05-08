import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:get/get.dart';

class ManageProjectController extends GetxController {
  final isLoading = false.obs;
  RxList<Project> projects = <Project>[].obs;

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
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      {
        projects.value = [
          Project(
            projectId: 'PRJ-001',
            title: 'Community Garden Development',
            organizerName: 'Green Earth Initiative',
            location: 'Downtown Community Center',
            description:
                'Help us develop a community garden that will provide fresh produce for local food banks and teach gardening skills to community members.',
            requiredSkills: [
              'Gardening',
              'Project Management',
              'Community Outreach'
            ],
            timeCommitment: '10 hours per week',
            startDate: DateTime.now().add(const Duration(days: 15)),
            applicationDeadline: DateTime.now().add(const Duration(days: 7)),
            status: 'Open',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          Project(
            projectId: 'PRJ-002',
            title: 'Youth Mentorship Program',
            organizerName: 'Future Leaders Foundation',
            location: 'City Youth Center',
            description:
                'Mentor underprivileged youth in academic subjects and life skills to help them achieve their full potential.',
            requiredSkills: ['Teaching', 'Mentoring', 'Communication'],
            timeCommitment: '5 hours per week',
            startDate: DateTime.now().add(const Duration(days: 10)),
            applicationDeadline: DateTime.now().add(const Duration(days: 5)),
            status: 'Open',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          Project(
            projectId: 'PRJ-003',
            title: 'Homeless Shelter Support',
            organizerName: 'Helping Hands Charity',
            location: 'Downtown Shelter',
            description:
                'Assist in running the local homeless shelter, including meal preparation, distribution of supplies, and administrative support.',
            requiredSkills: ['Organization', 'Food Preparation', 'Compassion'],
            timeCommitment: '8 hours per week',
            startDate: DateTime.now().add(const Duration(days: 7)),
            applicationDeadline: DateTime.now().add(const Duration(days: 3)),
            status: 'Open',
            createdAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
        ];
      }
    } catch (e) {
      logE('Error fetching projects: $e');
    } finally {
      isLoading.value = false;
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
        projectId: 'PRJ-${(projects.length + 1).toString().padLeft(3, '0')}',
        title: titleController.text,
        organizerName:
            'Current Organization', // This would come from user session
        location: locationController.text,
        description: descriptionController.text,
        requiredSkills: skills,
        timeCommitment: timeCommitmentController.text,
        startDate: DateFormat('yyyy-MM-dd').parse(startDateController.text),
        applicationDeadline:
            DateFormat('yyyy-MM-dd').parse(applicationDeadlineController.text),
        status: selectedStatus.value,
        createdAt: DateTime.now(),
      );

      // Add to projects list (in a real app, this would be an API call)
      projects.add(newProject);

      // Clear form
      _clearForm();
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

      // Find the project index
      final index = projects.indexWhere((p) => p.projectId == projectId);
      if (index == -1) {
        throw Exception('Project not found');
      }

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
        organizerName: projects[index].organizerName,
        location: locationController.text,
        description: descriptionController.text,
        requiredSkills: skills,
        timeCommitment: timeCommitmentController.text,
        startDate: DateFormat('yyyy-MM-dd').parse(startDateController.text),
        applicationDeadline:
            DateFormat('yyyy-MM-dd').parse(applicationDeadlineController.text),
        status: selectedStatus.value,
        assignedVolunteerId: projects[index].assignedVolunteerId,
        createdAt: projects[index].createdAt,
      );

      // Update in projects list (in a real app, this would be an API call)
      projects[index] = updatedProject;

      // Clear form
      _clearForm();
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

      // Remove from projects list (in a real app, this would be an API call)
      projects.removeWhere((p) => p.projectId == projectId);
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
