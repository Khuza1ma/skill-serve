import 'package:skill_serve/app/data/local/user_provider.dart';

import '../../../data/models/applied_project_model.dart';
import '../controllers/volunteer_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/app_colors.dart';

class VolunteerDashboardView extends GetView<VolunteerDashboardController> {
  const VolunteerDashboardView({super.key});

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
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.k806dff,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Summary Card
                _buildProfileSummaryCard(),
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

                // Recent Applied Projects
                _buildRecentAppliedProjectsCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.k262837,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 12,
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
                        'Volunteer ID: ${UserProvider.currentUser?.currentUserId}',
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
            Row(
              spacing: 12,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  'Applied Projects',
                  controller.totalAppliedProjects.toString(),
                  AppColors.k3B7DDD,
                ),
                _buildStatItem(
                  'Approved',
                  controller.getStatusCount('Approved').toString(),
                  AppColors.k1CBB8C,
                ),
                _buildStatItem(
                  'Pending',
                  controller.getStatusCount('Pending').toString(),
                  AppColors.kFCB92C,
                ),
                _buildStatItem(
                  'Rejected',
                  controller.getStatusCount('Rejected').toString(),
                  AppColors.kDC3545,
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
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectStatusChart() {
    final statusColors = {
      'Approved': AppColors.k1CBB8C,
      'Pending': AppColors.kFCB92C,
      'Rejected': AppColors.kDC3545,
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
              child: PieChart(
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
              'Completed Projects',
              controller.userProfile['completedProjects'],
              AppColors.k1CBB8C,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Ongoing Projects',
              controller.userProfile['ongoingProjects'],
              AppColors.k3B7DDD,
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'Applied Projects',
              controller.totalAppliedProjects,
              AppColors.kFCB92C,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.k806dff.withOpacity(0.1),
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
                      'Your profile shows a good balance of completed and ongoing projects.',
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
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAppliedProjectsCard() {
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
                  'Recent Applied Projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/applied-projects');
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
            ...controller.appliedProjects
                .take(3)
                .map((project) => _buildProjectItem(project)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(AppliedProject project) {
    Color statusColor;
    IconData statusIcon;

    switch (project.status) {
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
        statusColor = AppColors.k6C757D;
        statusIcon = Icons.help_outline;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project ID: ${project.projectId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kFFFFFF,
                  ),
                ),
                Text(
                  'Application ID: ${project.applicationId}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.kc6c6c8,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  project.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Applied: ${project.dateApplied}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.kc6c6c8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
