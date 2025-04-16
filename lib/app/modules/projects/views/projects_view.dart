import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/projects_controller.dart';

class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ProjectsView'));
  }
}
