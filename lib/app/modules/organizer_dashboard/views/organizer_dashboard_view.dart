import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/modules/home/controllers/home_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../data/local/user_provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/organizer_dashboard_controller.dart';

class OrganizerDashboardView extends GetView<OrganizerDashboardController> {
  const OrganizerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
                  Expanded(flex: 1, child: _buildProjectStatusChart()),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: _buildProjectsOverviewCard()),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Projects
              _buildRecentProjectsCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrganizationProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    UserProvider.currentUser?.currentUsername
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        '',
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
                        UserProvider.currentUser?.currentUsername ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kFFFFFF,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        UserProvider.currentUser?.currentUserEmail ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.kc6c6c8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Organizer ID: ${UserProvider.currentUser?.currentUserId ?? ''}',
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
                  controller.totalProjects.toString(),
                  AppColors.k3B7DDD,
                ),
                _buildStatItem(
                  'Open Projects',
                  controller.openProjects.toString(),
                  AppColors.k1CBB8C,
                ),
                _buildStatItem(
                  'Assigned',
                  controller.assignedProjects.toString(),
                  AppColors.kFF9800,
                ),
                _buildStatItem(
                  'Completed',
                  controller.completedProjects.toString(),
                  AppColors.k3B7DDD,
                ),
                _buildStatItem(
                  'Cancelled',
                  controller.cancelledProjects.toString(),
                  AppColors.kFF0000,
                ),
                _buildStatItem(
                  'Closed',
                  controller.closedProjects.toString(),
                  AppColors.kFCB92C,
                ),
                _buildStatItem(
                  'Total Applications',
                  controller.totalApplications.toString(),
                  AppColors.k806dff,
                ),
                _buildStatItem(
                  'Total Volunteers',
                  controller.totalVolunteers.toString(),
                  AppColors.k17A2B8,
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
            style: TextStyle(fontSize: 16, color: color.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectStatusChart() {
    if (controller.totalProjects == 0) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                height: 320,
                child: const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: AppColors.kFFFFFF, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[
      if (controller.openProjects > 0)
        PieChartSectionData(
          value: controller.openProjects.toDouble(),
          title: 'Open\n${controller.openProjects}',
          color: AppColors.k1CBB8C,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
      if (controller.assignedProjects > 0)
        PieChartSectionData(
          value: controller.assignedProjects.toDouble(),
          title: 'Assigned\n${controller.assignedProjects}',
          color: AppColors.kFF9800,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
      if (controller.completedProjects > 0)
        PieChartSectionData(
          value: controller.completedProjects.toDouble(),
          title: 'Completed\n${controller.completedProjects}',
          color: AppColors.k3B7DDD,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
      if (controller.cancelledProjects > 0)
        PieChartSectionData(
          value: controller.cancelledProjects.toDouble(),
          title: 'Cancelled\n${controller.cancelledProjects}',
          color: AppColors.kFF0000,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
      if (controller.closedProjects > 0)
        PieChartSectionData(
          value: controller.closedProjects.toDouble(),
          title: 'Closed\n${controller.closedProjects}',
          color: AppColors.kFCB92C,
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.kFFFFFF,
          ),
        ),
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            (sections.isEmpty)
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: AppColors.kFFFFFF),
                    ),
                  )
                : SizedBox(
                    height: 332,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 55,
                        sectionsSpace: 3,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              'Assigned Projects',
              controller.assignedProjects,
              AppColors.kFF9800,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Completed Projects',
              controller.completedProjects,
              AppColors.k3B7DDD,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Cancelled Projects',
              controller.cancelledProjects,
              AppColors.kFF0000,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Closed Projects',
              controller.closedProjects,
              AppColors.kFCB92C,
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
                  const Icon(Icons.info_outline, color: AppColors.k806dff),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'You have several open projects. Consider promoting them to attract more volunteers.',
                      style: TextStyle(color: AppColors.kFFFFFF),
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
              style: const TextStyle(color: AppColors.kFFFFFF, fontSize: 14),
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

  Widget _buildRecentProjectsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    // Navigate to Manage Projects screen

                    Get.find<HomeController>().selectedTab.value =
                        SideBarTab.manageProject;
                    Get.offNamed(Routes.MANAGE_PROJECT, id: 1);
                  },
                  child: const Text(
                    'Manage Projects',
                    style: TextStyle(color: AppColors.k806dff),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.k1f1d2c),
            const SizedBox(height: 8),
            if (controller.projects.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No projects available',
                    style: TextStyle(color: AppColors.kFFFFFF, fontSize: 16),
                  ),
                ),
              )
            else
              ...controller.projects
                  .take(5)
                  .map((project) => _buildProjectItem(project)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(Project project) {
    Color statusColor;
    IconData statusIcon;
    // 'Assigned',
    // 'Completed',
    // 'Cancelled'
    switch (project.status) {
      case 'Open':
        statusColor = AppColors.k1CBB8C;
        statusIcon = Icons.check_circle;
        break;
      case 'Closed':
        statusColor = AppColors.kFCB92C;
        statusIcon = Icons.lock;
        break;
      case 'Assigned':
        statusColor = AppColors.kFF9800;
        statusIcon = Icons.assignment_turned_in;
        break;
      case 'Completed':
        statusColor = AppColors.k3B7DDD;
        statusIcon = Icons.done_all;
        break;
      case 'Cancelled':
        statusColor = AppColors.kFF0000;
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
                  project.title ?? '',
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
                    Icon(statusIcon, color: statusColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      project.status ?? 'Open',
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
            project.requiredSkills?.join(', ') ?? '',
            style: const TextStyle(color: AppColors.kc6c6c8, fontSize: 14),
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
                project.location ?? '',
                style: const TextStyle(color: AppColors.kc6c6c8, fontSize: 14),
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
                style: const TextStyle(color: AppColors.kc6c6c8, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.requiredSkills
                    ?.map((skill) => _buildSkillChip(skill))
                    .toList() ??
                [],
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
        style: const TextStyle(color: AppColors.k806dff, fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }
}
