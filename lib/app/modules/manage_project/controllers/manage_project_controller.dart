import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:intl/intl.dart';

class ManageProjectController extends GetxController {
  // Loading state
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Project data
  final project = Rx<Project?>(null);

  // Applicants data
  final applicants = <Map<String, dynamic>>[].obs;

  // Selected tab
  final selectedTabIndex = 0.obs;

  // Form key for edit project form
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

  // Formatted values for display
  String get projectTitle => project.value?.title ?? 'N/A';
  String get startDate => project.value != null
      ? DateFormat('MMM dd, yyyy').format(project.value!.startDate)
      : 'N/A';
  String get applicationDeadline => project.value != null
      ? DateFormat('MMM dd, yyyy').format(project.value!.applicationDeadline)
      : 'N/A';
  int get totalApplicants => applicants.length;
  String get assignedVolunteer =>
      'John Doe'; // This would come from a real service

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
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

  // Projects list
  RxList<Project> projects = <Project>[].obs;

  // Selected project ID
  final selectedProjectId = RxnString();

  // Fetch projects list
  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;

      // In a real app, this would be fetched from a service
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
      print('Error fetching projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch project data for a specific project
  Future<void> fetchProjectData(String projectId) async {
    try {
      isLoading.value = true;
      selectedProjectId.value = projectId;

      // Find the selected project from the list
      final selectedProject = projects.firstWhere(
        (p) => p.projectId == projectId,
        orElse: () => Project(
          projectId: '',
          title: '',
          location: '',
          description: '',
          requiredSkills: [],
          timeCommitment: '',
          startDate: DateTime.now(),
          applicationDeadline: DateTime.now(),
          status: '',
          createdAt: DateTime.now(),
        ),
      );

      project.value = selectedProject;

      // In a real app, you would fetch applicants for this specific project
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));

      // Mock applicants data
      applicants.value = [
        {
          'id': 'USR-001',
          'name': 'Alice Johnson',
          'email': 'alice@example.com',
          'skills': ['Gardening', 'Teaching', 'Community Outreach'],
          'applicationDate': DateTime.now().subtract(const Duration(days: 2)),
          'status': 'Pending',
        },
        {
          'id': 'USR-002',
          'name': 'Bob Smith',
          'email': 'bob@example.com',
          'skills': ['Project Management', 'Gardening'],
          'applicationDate': DateTime.now().subtract(const Duration(days: 3)),
          'status': 'Pending',
        },
        {
          'id': 'USR-003',
          'name': 'Carol Williams',
          'email': 'carol@example.com',
          'skills': ['Community Outreach', 'Social Media'],
          'applicationDate': DateTime.now().subtract(const Duration(days: 1)),
          'status': 'Pending',
        },
      ];
    } catch (e) {
      print('Error fetching project data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Prepare edit form with current project data
  void prepareEditForm() {
    if (project.value != null) {
      titleController.text = project.value!.title;
      descriptionController.text = project.value!.description;
      locationController.text = project.value!.location;
      timeCommitmentController.text = project.value!.timeCommitment;

      requiredSkills.clear();
      requiredSkills.addAll(project.value!.requiredSkills);

      startDateController.text =
          DateFormat('yyyy-MM-dd').format(project.value!.startDate);
      applicationDeadlineController.text =
          DateFormat('yyyy-MM-dd').format(project.value!.applicationDeadline);

      selectedStatus.value = project.value!.status;
    }
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

  // Update project with edited data
  Future<void> updateProject() async {
    if (formKey.currentState!.validate()) {
      try {
        isUpdating.value = true;

        // In a real app, you would call an API to update the project
        await Future.delayed(const Duration(seconds: 1));

        // Update the project with new values
        if (project.value != null) {
          final updatedProject = Project(
            projectId: project.value!.projectId,
            title: titleController.text,
            organizerName: project.value!.organizerName,
            location: locationController.text,
            description: descriptionController.text,
            requiredSkills: requiredSkills,
            timeCommitment: timeCommitmentController.text,
            startDate: DateTime.parse(startDateController.text),
            applicationDeadline:
                DateTime.parse(applicationDeadlineController.text),
            status: selectedStatus.value,
            assignedVolunteerId: project.value!.assignedVolunteerId,
            createdAt: project.value!.createdAt,
          );

          project.value = updatedProject;

          Get.back(); // Close the dialog

          Get.snackbar(
            'Success',
            'Project updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update project: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isUpdating.value = false;
      }
    }
  }

  // Assign volunteer to project
  void assignVolunteer(String volunteerId) {
    // In a real app, this would call a service to update the project
    print(
        'Assigning volunteer $volunteerId to project ${project.value?.projectId}');

    // Update the applicant status
    final index =
        applicants.indexWhere((applicant) => applicant['id'] == volunteerId);
    if (index != -1) {
      final updatedApplicant = Map<String, dynamic>.from(applicants[index]);
      updatedApplicant['status'] = 'Assigned';
      applicants[index] = updatedApplicant;

      // Update project status
      if (project.value != null) {
        final updatedProject = Project(
          projectId: project.value!.projectId,
          title: project.value!.title,
          organizerName: project.value!.organizerName,
          location: project.value!.location,
          description: project.value!.description,
          requiredSkills: project.value!.requiredSkills,
          timeCommitment: project.value!.timeCommitment,
          startDate: project.value!.startDate,
          applicationDeadline: project.value!.applicationDeadline,
          status: 'Assigned',
          assignedVolunteerId: volunteerId,
          createdAt: project.value!.createdAt,
        );
        project.value = updatedProject;
      }
    }
  }

  // Change selected tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
