import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/applied_projects_controller.dart';

class AppliedProjectsView extends GetView<AppliedProjectsController> {
  const AppliedProjectsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('AppliedProjectsView'));
  }
}
