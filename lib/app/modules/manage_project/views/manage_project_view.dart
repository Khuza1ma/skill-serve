import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/constants/app_colors.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/ui/components/app_button.dart';
import 'package:skill_serve/app/ui/components/app_text_form_field.dart';
import 'package:skill_serve/app/ui/components/app_modals.dart';
import '../controllers/manage_project_controller.dart';

class ManageProjectView extends GetView<ManageProjectController> {
  const ManageProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to make responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: AppColors.k1f1d2c,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.project.value == null) {
          return Center(
            child: Text(
              'Project not found',
              style: TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: 18,
              ),
            ),
          );
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.kFFFFFF,
                          size: isDesktop ? 28 : 24,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Manage Project',
                          style: TextStyle(
                            color: AppColors.kFFFFFF,
                            fontSize: isDesktop ? 28 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Edit button
                      AppButton(
                        buttonText: 'Edit Project',
                        onPressed: () {
                          controller.prepareEditForm();
                          _showEditProjectDialog(context, isDesktop);
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        buttonSize: Size(isDesktop ? 150 : 130, 40),
                        leading: const Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.kFFFFFF,
                        ),
                      ),
                    ],
                  ),
                ),

                // Project overview card
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                    vertical: 8,
                  ),
                  child: _buildProjectOverviewCard(isDesktop, isTablet),
                ),

                // Tabs
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                    vertical: 16,
                  ),
                  child: _buildTabs(isDesktop),
                ),

                // Tab content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                    ),
                    child: Obx(() {
                      switch (controller.selectedTabIndex.value) {
                        case 0:
                          return _buildApplicantsTab(isDesktop, isTablet);
                        case 1:
                          return _buildDetailsTab(isDesktop, isTablet);
                        case 2:
                          return _buildActivityTab(isDesktop, isTablet);
                        default:
                          return _buildApplicantsTab(isDesktop, isTablet);
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProjectOverviewCard(bool isDesktop, bool isTablet) {
    return Card(
      elevation: 5,
      color: AppColors.k262837,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project title
            Text(
              controller.projectTitle,
              style: TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Project stats in a row
            isDesktop || isTablet
                ? _buildDesktopProjectStats()
                : _buildMobileProjectStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopProjectStats() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.calendar_today,
          label: 'Start Date',
          value: controller.startDate,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.event_busy,
          label: 'Application Deadline',
          value: controller.applicationDeadline,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.people,
          label: 'Total Applicants',
          value: controller.totalApplicants.toString(),
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.person_pin,
          label: 'Assigned Volunteer',
          value: controller.project.value?.assignedVolunteerId != null
              ? controller.assignedVolunteer
              : 'Not assigned',
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.flag,
          label: 'Status',
          value: controller.project.value?.status ?? 'N/A',
          valueColor: controller.project.value?.status == 'Open'
              ? Colors.green
              : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildMobileProjectStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.calendar_today,
                label: 'Start Date',
                value: controller.startDate,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatItem(
                icon: Icons.event_busy,
                label: 'Application Deadline',
                value: controller.applicationDeadline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.people,
                label: 'Total Applicants',
                value: controller.totalApplicants.toString(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatItem(
                icon: Icons.person_pin,
                label: 'Assigned Volunteer',
                value: controller.project.value?.assignedVolunteerId != null
                    ? controller.assignedVolunteer
                    : 'Not assigned',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          icon: Icons.flag,
          label: 'Status',
          value: controller.project.value?.status ?? 'N/A',
          valueColor: controller.project.value?.status == 'Open'
              ? Colors.green
              : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.k806dff,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.kFFFFFF.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.kFFFFFF,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.k262837,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => Row(
            children: [
              _buildTabItem(
                icon: Icons.people,
                label: 'Applicants',
                isSelected: controller.selectedTabIndex.value == 0,
                onTap: () => controller.changeTab(0),
                isDesktop: isDesktop,
              ),
              _buildTabItem(
                icon: Icons.info_outline,
                label: 'Details',
                isSelected: controller.selectedTabIndex.value == 1,
                onTap: () => controller.changeTab(1),
                isDesktop: isDesktop,
              ),
              _buildTabItem(
                icon: Icons.history,
                label: 'Activity',
                isSelected: controller.selectedTabIndex.value == 2,
                onTap: () => controller.changeTab(2),
                isDesktop: isDesktop,
              ),
            ],
          )),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDesktop,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: isDesktop ? 16 : 8,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.k806dff : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.k806dff
                    : AppColors.kFFFFFF.withOpacity(0.7),
                size: isDesktop ? 20 : 18,
              ),
              SizedBox(width: isDesktop ? 8 : 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.k806dff
                      : AppColors.kFFFFFF.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isDesktop ? 16 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantsTab(bool isDesktop, bool isTablet) {
    return Card(
      elevation: 5,
      color: AppColors.k262837,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applicants',
              style: TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: controller.applicants.isEmpty
                  ? Center(
                      child: Text(
                        'No applicants yet',
                        style: TextStyle(
                          color: AppColors.kFFFFFF.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.applicants.length,
                      itemBuilder: (context, index) {
                        final applicant = controller.applicants[index];
                        return _buildApplicantCard(
                          applicant,
                          isDesktop,
                          isTablet,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantCard(
    Map<String, dynamic> applicant,
    bool isDesktop,
    bool isTablet,
  ) {
    final isAssigned = applicant['status'] == 'Assigned';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.k1f1d2c,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isDesktop || isTablet
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.k806dff.withOpacity(0.2),
                    child: Text(
                      applicant['name']
                          .toString()
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Applicant info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant['name'],
                          style: TextStyle(
                            color: AppColors.kFFFFFF,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          applicant['email'],
                          style: TextStyle(
                            color: AppColors.kFFFFFF.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (applicant['skills'] as List<String>)
                              .map((skill) => Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(
                                        color: AppColors.kFFFFFF,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor:
                                        AppColors.k806dff.withOpacity(0.2),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // Application date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Applied on',
                        style: TextStyle(
                          color: AppColors.kFFFFFF.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(
                          applicant['applicationDate'] as DateTime,
                        ),
                        style: TextStyle(
                          color: AppColors.kFFFFFF,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),

                  // Assign button
                  SizedBox(
                    width: 120,
                    child: isAssigned
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Assigned',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : AppButton(
                            buttonText: 'Assign',
                            onPressed: () =>
                                controller.assignVolunteer(applicant['id']),
                            buttonSize: const Size(120, 36),
                            fontSize: 14,
                          ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.k806dff.withOpacity(0.2),
                        child: Text(
                          applicant['name']
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            color: AppColors.kFFFFFF,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Applicant name and email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              applicant['name'],
                              style: TextStyle(
                                color: AppColors.kFFFFFF,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              applicant['email'],
                              style: TextStyle(
                                color: AppColors.kFFFFFF.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Skills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (applicant['skills'] as List<String>)
                        .map((skill) => Chip(
                              label: Text(
                                skill,
                                style: TextStyle(
                                  color: AppColors.kFFFFFF,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor:
                                  AppColors.k806dff.withOpacity(0.2),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Application date and assign button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Applied on ${DateFormat('MMM dd, yyyy').format(
                          applicant['applicationDate'] as DateTime,
                        )}',
                        style: TextStyle(
                          color: AppColors.kFFFFFF.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      isAssigned
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Assigned',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : AppButton(
                              buttonText: 'Assign',
                              onPressed: () =>
                                  controller.assignVolunteer(applicant['id']),
                              buttonSize: const Size(100, 32),
                              fontSize: 12,
                            ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailsTab(bool isDesktop, bool isTablet) {
    return Card(
      elevation: 5,
      color: AppColors.k262837,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project Details',
                style: TextStyle(
                  color: AppColors.kFFFFFF,
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Project details
              _buildDetailItem(
                label: 'Project ID',
                value: controller.project.value?.projectId ?? 'N/A',
                isDesktop: isDesktop,
              ),
              _buildDetailItem(
                label: 'Organizer',
                value: controller.project.value?.organizerName ?? 'N/A',
                isDesktop: isDesktop,
              ),
              _buildDetailItem(
                label: 'Location',
                value: controller.project.value?.location ?? 'N/A',
                isDesktop: isDesktop,
              ),
              _buildDetailItem(
                label: 'Time Commitment',
                value: controller.project.value?.timeCommitment ?? 'N/A',
                isDesktop: isDesktop,
              ),
              _buildDetailItem(
                label: 'Created At',
                value: controller.project.value != null
                    ? DateFormat('MMM dd, yyyy')
                        .format(controller.project.value!.createdAt)
                    : 'N/A',
                isDesktop: isDesktop,
              ),

              const SizedBox(height: 24),
              Text(
                'Description',
                style: TextStyle(
                  color: AppColors.kFFFFFF,
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.project.value?.description ??
                    'No description available',
                style: TextStyle(
                  color: AppColors.kFFFFFF.withOpacity(0.8),
                  fontSize: isDesktop ? 16 : 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Required Skills',
                style: TextStyle(
                  color: AppColors.kFFFFFF,
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.project.value?.requiredSkills
                        .map((skill) => Chip(
                              label: Text(
                                skill,
                                style: TextStyle(
                                  color: AppColors.kFFFFFF,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor:
                                  AppColors.k806dff.withOpacity(0.2),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ))
                        .toList() ??
                    [
                      Text(
                        'No skills specified',
                        style: TextStyle(
                          color: AppColors.kFFFFFF.withOpacity(0.7),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    required bool isDesktop,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isDesktop ? 150 : 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.kFFFFFF.withOpacity(0.7),
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(bool isDesktop, bool isTablet) {
    // This would show project activity history
    return Card(
      elevation: 5,
      color: AppColors.k262837,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity History',
              style: TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'No activity recorded yet',
                  style: TextStyle(
                    color: AppColors.kFFFFFF.withOpacity(0.7),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProjectDialog(BuildContext context, bool isDesktop) {
    final dialogWidth =
        isDesktop ? 800.0 : MediaQuery.of(context).size.width * 0.9;

    showCustomModal(
      title: 'Edit Project',
      alignment: Alignment.center,
      showButtons: false, // We'll add our own buttons in the form
      child: Container(
        width: dialogWidth,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project Title
                AppTextField(
                  name: 'title',
                  label: 'Project Title',
                  hintText: 'Enter project title',
                  controller: controller.titleController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                AppTextField(
                  name: 'description',
                  label: 'Description',
                  hintText: 'Enter project description',
                  controller: controller.descriptionController,
                  isRequired: true,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location
                AppTextField(
                  name: 'location',
                  label: 'Location',
                  hintText: 'Enter project location',
                  controller: controller.locationController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time Commitment
                AppTextField(
                  name: 'timeCommitment',
                  label: 'Time Commitment',
                  hintText: 'e.g., 10 hours per week',
                  controller: controller.timeCommitmentController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter time commitment';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Skills
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        name: 'skill',
                        label: 'Required Skills',
                        hintText: 'Enter a skill and press Add',
                        controller: controller.skillController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: AppColors.k806dff),
                      onPressed: controller.addSkill,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Skills Chips
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: controller.requiredSkills
                          .map((skill) => Chip(
                                label: Text(
                                  skill,
                                  style: TextStyle(color: AppColors.kFFFFFF),
                                ),
                                backgroundColor:
                                    AppColors.k806dff.withOpacity(0.2),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => controller.removeSkill(skill),
                              ))
                          .toList(),
                    )),
                const SizedBox(height: 16),

                // Start Date
                AppTextField(
                  name: 'startDate',
                  label: 'Start Date',
                  hintText: 'YYYY-MM-DD',
                  controller: controller.startDateController,
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) => controller.selectDate(
                      context, controller.startDateController),
                  suffix: const Icon(Icons.calendar_today),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Application Deadline
                AppTextField(
                  name: 'applicationDeadline',
                  label: 'Application Deadline',
                  hintText: 'YYYY-MM-DD',
                  controller: controller.applicationDeadlineController,
                  isRequired: true,
                  readOnly: true,
                  onTap: (_) => controller.selectDate(
                      context, controller.applicationDeadlineController),
                  suffix: const Icon(Icons.calendar_today),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an application deadline';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.kFFFFFF,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: controller.selectedStatus.value,
                          items: controller.statusOptions
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedStatus.value = value;
                            }
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      buttonText: 'Cancel',
                      onPressed: () => Get.back(),
                      buttonColor: AppColors.k262837,
                      border: BorderSide(color: AppColors.k806dff),
                      buttonSize: const Size(100, 40),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => AppButton(
                          buttonText: 'Update Project',
                          onPressed: controller.updateProject,
                          isLoading: controller.isUpdating.value,
                          buttonSize: const Size(150, 40),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      onSubmit: () {},
    );
  }
}
