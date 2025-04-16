import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/projects_details_controller.dart';

class ProjectsDetailsView extends GetView<ProjectsDetailsController> {
  const ProjectsDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ProjectsDetailsView'));
  }
}
