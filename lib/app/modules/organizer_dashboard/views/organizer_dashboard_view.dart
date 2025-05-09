import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/models/project_model.dart';

import '../../../constants/app_colors.dart';
import '../controllers/organizer_dashboard_controller.dart';

class OrganizerDashboardView extends GetView<OrganizerDashboardController> {
  const OrganizerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Organizer Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.k806dff,
                  ),
                ),
                const SizedBox(height: 24),

                // Organization Profile Summary Card
                _buildOrganizationProfileCard(),
                const SizedBox(height: 24),

                // Project Statistics Row
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildProjectStatusChart(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildProjectsOverviewCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Applications and Volunteers Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildRecentApplicationsCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildRecentVolunteersCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Projects
                _buildRecentProjectsCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrganizationProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.k806dff,
                  child: Text(
                    controller.organizerProfile['name']
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        'O',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kFFFFFF,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.organizerProfile['name'] ??
                            'Organization Name',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kFFFFFF,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.organizerProfile['email'] ??
                            'email@organization.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.kc6c6c8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Organizer ID: ${controller.organizerProfile['organizerId'] ?? 'ORG000'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.kc6c6c8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatItem(
                  'Total Projects',
                  controller.organizerProfile['totalProjects']?.toString() ??
                      '0',
                  AppColors.k3B7DDD,
                ),
                _buildStatItem(
                  'Active Projects',
                  controller.organizerProfile['activeProjects']?.toString() ??
                      '0',
                  AppColors.k1CBB8C,
                ),
                _buildStatItem(
                  'Completed Projects',
                  controller.organizerProfile['completedProjects']
                          ?.toString() ??
                      '0',
                  AppColors.kFCB92C,
                ),
                _buildStatItem(
                  'Total Volunteers',
                  controller.organizerProfile['totalVolunteers']?.toString() ??
                      '0',
                  AppColors.k806dff,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectStatusChart() {
    final statusColors = {
      'Open': AppColors.k1CBB8C,
      'Closed': AppColors.kFCB92C,
      'Completed': AppColors.k3B7DDD,
    };

    final sections = <PieChartSectionData>[];
    controller.projectStatusCounts.forEach((status, count) {
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$status\n$count',
          color: statusColors[status] ?? AppColors.k17A2B8,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
      );
    });

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kFFFFFF,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: sections.isEmpty
                  ? const Center(
                      child: Text(
                        'No projects data available',
                        style: TextStyle(color: AppColors.kc6c6c8),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Projects Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kFFFFFF,
              ),
            ),
            const SizedBox(height: 20),
            _buildProgressItem(
              'Open Projects',
              controller.openProjects,
              AppColors.k1CBB8C,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Closed Projects',
              controller.closedProjects,
              AppColors.kFCB92C,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Total Applications',
              controller.totalApplications,
              AppColors.k3B7DDD,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.k806dff.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.k806dff,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'You have several open projects. Consider promoting them to attract more volunteers.',
                      style: TextStyle(
                        color: AppColors.kFFFFFF,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, int value, Color color) {
    // Calculate percentage based on a max value of 10 for visualization
    final percentage = (value / 10) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.kFFFFFF,
                fontSize: 14,
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentApplicationsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Applications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to applications page
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.k806dff,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.k1f1d2c),
            const SizedBox(height: 8),
            ...controller.recentApplications
                .take(3)
                .map((application) => _buildApplicationItem(application)),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationItem(Map<String, dynamic> application) {
    Color statusColor;
    IconData statusIcon;

    switch (application['status']) {
      case 'Approved':
        statusColor = AppColors.k1CBB8C;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = AppColors.kFCB92C;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'Rejected':
        statusColor = AppColors.kDC3545;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.k17A2B8;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.k1f1d2c,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application['projectTitle'] ?? 'Project Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      application['status'] ?? 'Unknown',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.kc6c6c8,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                application['volunteerName'] ?? 'Volunteer Name',
                style: const TextStyle(
                  color: AppColors.kc6c6c8,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.kc6c6c8,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Applied: ${_formatDate(application['appliedDate'])}',
                style: const TextStyle(
                  color: AppColors.kc6c6c8,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVolunteersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Volunteers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to volunteers page
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.k806dff,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.k1f1d2c),
            const SizedBox(height: 8),
            ...controller.recentVolunteers
                .take(3)
                .map((volunteer) => _buildVolunteerItem(volunteer)),
          ],
        ),
      ),
    );
  }

  Widget _buildVolunteerItem(Map<String, dynamic> volunteer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.k1f1d2c,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.k806dff,
            radius: 24,
            child: Text(
              volunteer['name']?.substring(0, 1).toUpperCase() ?? 'V',
              style: const TextStyle(
                color: AppColors.kFFFFFF,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer['name'] ?? 'Volunteer Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Skills: ${(volunteer['skills'] as List<dynamic>?)?.join(', ') ?? 'None'}',
                  style: const TextStyle(
                    color: AppColors.kc6c6c8,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Joined: ${_formatDate(volunteer['joinedDate'])}',
                  style: const TextStyle(
                    color: AppColors.kc6c6c8,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjectsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to projects page
                    Get.toNamed('/manage-project');
                  },
                  child: const Text(
                    'Manage Projects',
                    style: TextStyle(
                      color: AppColors.k806dff,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.k1f1d2c),
            const SizedBox(height: 8),
            ...controller.projects
                .take(3)
                .map((project) => _buildProjectItem(project)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(Project project) {
    Color statusColor;
    IconData statusIcon;

    switch (project.status) {
      case 'Open':
        statusColor = AppColors.k1CBB8C;
        statusIcon = Icons.check_circle;
        break;
      case 'Closed':
        statusColor = AppColors.kFCB92C;
        statusIcon = Icons.lock;
        break;
      default:
        statusColor = AppColors.k17A2B8;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.k1f1d2c,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      project.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: const TextStyle(
              color: AppColors.kc6c6c8,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.kc6c6c8,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                project.location,
                style: const TextStyle(
                  color: AppColors.kc6c6c8,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.calendar_today,
                color: AppColors.kc6c6c8,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Deadline: ${_formatDate(project.applicationDeadline)}',
                style: const TextStyle(
                  color: AppColors.kc6c6c8,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.requiredSkills
                .map((skill) => _buildSkillChip(skill))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.k806dff.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.k806dff.withValues(alpha: 0.3)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          color: AppColors.k806dff,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }
}
