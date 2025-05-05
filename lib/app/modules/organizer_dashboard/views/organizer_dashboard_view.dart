import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/organizer_dashboard_controller.dart';

class OrganizerDashboardView extends GetView<OrganizerDashboardController> {
  const OrganizerDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrganizerDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrganizerDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
