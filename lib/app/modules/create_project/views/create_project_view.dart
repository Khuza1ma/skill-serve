import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/constants/app_colors.dart';
import 'package:skill_serve/app/ui/components/app_button.dart';
import 'package:skill_serve/app/ui/components/app_text_form_field.dart';

import '../controllers/create_project_controller.dart';

class CreateProjectView extends GetView<CreateProjectController> {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 1200 : (isTablet ? 700 : double.infinity),
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
    );
  }

  Widget _buildForm(BuildContext context, bool isDesktop, bool isTablet) {
    return FormBuilder(
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

          Obx(
            () => AppButton(
              buttonText: 'Create Project',
              onPressed: controller.submitProject,
              isLoading: controller.isLoading.value,
              fontSize: isDesktop ? 18 : 16,
              padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
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
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter a title',
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: AppTextField(
                name: 'location',
                label: 'Location',
                hintText: 'Enter project location',
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter a location',
                ),
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
          isRequired: true,
          maxLines: 5,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter a description',
          ),
        ),
        const SizedBox(height: 24),

        // Row 3: Time Commitment and Max Volunteers
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AppTextField(
                name: 'timeCommitment',
                label: 'Time Commitment',
                hintText: 'e.g., 10 hours per week',
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter time commitment',
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: AppTextField(
                name: 'maxVolunteers',
                label: 'Max Volunteers',
                hintText: 'Enter maximum number of volunteers',
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Please enter max volunteers',
                  ),
                  FormBuilderValidators.numeric(
                    errorText: 'Please enter a valid number',
                  ),
                ]),
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
                isRequired: true,
                readOnly: true,
                onTap: (_) => controller.selectDate(context, 'startDate'),
                suffix: const Icon(Icons.calendar_today),
                validator: FormBuilderValidators.required(
                  errorText: 'Please select a start date',
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: AppTextField(
                name: 'endDate',
                label: 'End Date',
                hintText: 'YYYY-MM-DD',
                isRequired: true,
                readOnly: true,
                onTap: (_) => controller.selectDate(context, 'endDate'),
                suffix: const Icon(Icons.calendar_today),
                validator: FormBuilderValidators.required(
                  errorText: 'Please select an end date',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 5: Application Deadline and Contact Email
        AppTextField(
          name: 'applicationDeadline',
          label: 'Application Deadline',
          hintText: 'YYYY-MM-DD',
          isRequired: true,
          readOnly: true,
          onTap: (_) => controller.selectDate(context, 'applicationDeadline'),
          suffix: const Icon(Icons.calendar_today),
          validator: FormBuilderValidators.required(
            errorText: 'Please select an application deadline',
          ),
        ),
        const SizedBox(height: 24),

        // Row 6: Skills
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              name: 'skill',
              label: 'Required Skills',
              hintText: 'Enter a skill and press Add',
              suffix: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final skill =
                      controller.formKey.currentState?.fields['skill']?.value;
                  if (skill != null) {
                    controller.addSkill(skill);
                    controller.formKey.currentState?.fields['skill']?.reset();
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.k262837.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Skills:',
                    style: TextStyle(
                      color: AppColors.kFFFFFF.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => controller.requiredSkills.isEmpty
                      ? Text(
                          'No skills added yet',
                          style: TextStyle(
                            color: AppColors.kFFFFFF.withValues(alpha: 0.5),
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
                                    backgroundColor: AppColors.k806dff
                                        .withValues(alpha: 0.2),
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
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter a title',
          ),
        ),
        const SizedBox(height: 16),

        // Description
        AppTextField(
          name: 'description',
          label: 'Description',
          hintText: 'Enter project description',
          isRequired: true,
          maxLines: 5,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter a description',
          ),
        ),
        const SizedBox(height: 16),

        // Location
        AppTextField(
          name: 'location',
          label: 'Location',
          hintText: 'Enter project location',
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter a location',
          ),
        ),
        const SizedBox(height: 16),

        // Time Commitment
        AppTextField(
          name: 'timeCommitment',
          label: 'Time Commitment',
          hintText: 'e.g., 10 hours per week',
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter time commitment',
          ),
        ),
        const SizedBox(height: 16),

        // Max Volunteers
        AppTextField(
          name: 'maxVolunteers',
          label: 'Max Volunteers',
          hintText: 'Enter maximum number of volunteers',
          isRequired: true,
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(
                errorText: 'Please enter max volunteers',
              ),
              FormBuilderValidators.numeric(
                errorText: 'Please enter a valid number',
              ),
            ],
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 16),

        // Start Date
        AppTextField(
          name: 'startDate',
          label: 'Start Date',
          hintText: 'YYYY-MM-DD',
          isRequired: true,
          readOnly: true,
          onTap: (_) => controller.selectDate(context, 'startDate'),
          suffix: const Icon(Icons.calendar_today),
          validator: FormBuilderValidators.required(
            errorText: 'Please select a start date',
          ),
        ),
        const SizedBox(height: 16),

        // End Date
        AppTextField(
          name: 'endDate',
          label: 'End Date',
          hintText: 'YYYY-MM-DD',
          isRequired: true,
          readOnly: true,
          onTap: (_) => controller.selectDate(context, 'endDate'),
          suffix: const Icon(Icons.calendar_today),
          validator: FormBuilderValidators.required(
            errorText: 'Please select an end date',
          ),
        ),
        const SizedBox(height: 16),

        // Application Deadline
        AppTextField(
          name: 'applicationDeadline',
          label: 'Application Deadline',
          hintText: 'YYYY-MM-DD',
          isRequired: true,
          readOnly: true,
          onTap: (_) => controller.selectDate(context, 'applicationDeadline'),
          suffix: const Icon(Icons.calendar_today),
          validator: FormBuilderValidators.required(
            errorText: 'Please select an application deadline',
          ),
        ),
        const SizedBox(height: 16),

        // Contact Email
        AppTextField(
          name: 'contactEmail',
          label: 'Contact Email',
          hintText: 'Enter contact email',
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'Please enter contact email',
            ),
            FormBuilderValidators.email(
              errorText: 'Please enter a valid email',
            ),
          ]),
        ),
        const SizedBox(height: 16),

        // Skills
        AppTextField(
          name: 'skill',
          label: 'Required Skills',
          hintText: 'Enter a skill and press Add',
          suffix: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final skill =
                  controller.formKey.currentState?.fields['skill']?.value;
              if (skill != null) {
                controller.addSkill(skill);
                controller.formKey.currentState?.fields['skill']?.reset();
              }
            },
          ),
        ),
        const SizedBox(height: 12),

        // Skills Chips
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.k262837.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Skills:',
                style: TextStyle(
                  color: AppColors.kFFFFFF.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.requiredSkills.isEmpty
                    ? Text(
                        'No skills added yet',
                        style: TextStyle(
                          color: AppColors.k6C757D,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: controller.requiredSkills
                            .map(
                              (skill) => Chip(
                                label: Text(skill),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => controller.removeSkill(skill),
                                backgroundColor:
                                    AppColors.k806dff.withValues(alpha: 0.2),
                                labelStyle: TextStyle(color: AppColors.kFFFFFF),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
