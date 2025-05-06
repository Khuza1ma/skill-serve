import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/constants/app_colors.dart';
import 'package:skill_serve/app/ui/components/app_button.dart';
import 'package:skill_serve/app/ui/components/app_text_form_field.dart';
import '../controllers/create_project_controller.dart';

class CreateProjectView extends GetView<CreateProjectController> {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to make responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      isDesktop ? 1200 : (isTablet ? 700 : double.infinity),
                ),
                child: Card(
                  margin: EdgeInsets.all(isDesktop ? 32 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  color: AppColors.k262837,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isDesktop ? 32 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Title
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text(
                              'Create New Project',
                              style: TextStyle(
                                color: AppColors.kFFFFFF,
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 28 : 24,
                              ),
                            ),
                          ),
                        ),
                        _buildForm(context, isDesktop, isTablet),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildForm(BuildContext context, bool isDesktop, bool isTablet) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use responsive layout for form fields
          if (isDesktop || isTablet)
            _buildDesktopForm(context, isDesktop)
          else
            _buildMobileForm(context),

          const SizedBox(height: 32),

          // Submit Button - centered and with appropriate width
          Center(
            child: SizedBox(
              width: isDesktop ? 300 : (isTablet ? 250 : double.infinity),
              child: Obx(() => AppButton(
                    buttonText: 'Create Project',
                    onPressed: controller.submitProject,
                    isLoading: controller.isLoading.value,
                    fontSize: isDesktop ? 18 : 16,
                    padding:
                        EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopForm(BuildContext context, bool isDesktop) {
    // Two-column layout for desktop/tablet
    return Column(
      children: [
        // Row 1: Title and Description
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AppTextField(
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
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: AppTextField(
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
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 2: Description
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
        const SizedBox(height: 24),

        // Row 3: Time Commitment and Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AppTextField(
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
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
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
                              horizontal: 12, vertical: 14),
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
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 4: Dates
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AppTextField(
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
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: AppTextField(
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
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 5: Skills
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              name: 'skill',
              label: 'Required Skills',
              hintText: 'Enter a skill and press Add',
              controller: controller.skillController,
              suffix: IconButton(
                icon: const Icon(Icons.add),
                onPressed: controller.addSkill,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.k262837.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Skills:',
                    style: TextStyle(
                      color: AppColors.kFFFFFF.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => controller.requiredSkills.isEmpty
                      ? Text(
                          'No skills added yet',
                          style: TextStyle(
                            color: AppColors.kFFFFFF.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: controller.requiredSkills
                              .map((skill) => Chip(
                                    label: Text(skill),
                                    deleteIcon:
                                        const Icon(Icons.close, size: 18),
                                    onDeleted: () =>
                                        controller.removeSkill(skill),
                                    backgroundColor:
                                        AppColors.k806dff.withOpacity(0.2),
                                    labelStyle:
                                        TextStyle(color: AppColors.kFFFFFF),
                                  ))
                              .toList(),
                        )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileForm(BuildContext context) {
    // Single column layout for mobile
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        // Start Date
        AppTextField(
          name: 'startDate',
          label: 'Start Date',
          hintText: 'YYYY-MM-DD',
          controller: controller.startDateController,
          isRequired: true,
          readOnly: true,
          onTap: (_) =>
              controller.selectDate(context, controller.startDateController),
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        const SizedBox(height: 16),

        // Skills
        AppTextField(
          name: 'skill',
          label: 'Required Skills',
          hintText: 'Enter a skill and press Add',
          controller: controller.skillController,
          suffix: IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.addSkill,
          ),
        ),
        const SizedBox(height: 12),

        // Skills Chips
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.k262837.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Skills:',
                style: TextStyle(
                  color: AppColors.kFFFFFF.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => controller.requiredSkills.isEmpty
                  ? Text(
                      'No skills added yet',
                      style: TextStyle(
                        color: AppColors.kFFFFFF.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.requiredSkills
                          .map((skill) => Chip(
                                label: Text(skill),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => controller.removeSkill(skill),
                                backgroundColor:
                                    AppColors.k806dff.withOpacity(0.2),
                                labelStyle: TextStyle(color: AppColors.kFFFFFF),
                              ))
                          .toList(),
                    )),
            ],
          ),
        ),
      ],
    );
  }
}
