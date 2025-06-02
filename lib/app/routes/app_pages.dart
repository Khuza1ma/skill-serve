import 'package:get/get.dart';

import '../modules/applied_projects/bindings/applied_projects_binding.dart';
import '../modules/applied_projects/views/applied_projects_view.dart';
import '../modules/create_project/bindings/create_project_binding.dart';
import '../modules/create_project/views/create_project_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/manage_project/bindings/manage_project_binding.dart';
import '../modules/manage_project/views/manage_project_view.dart';
import '../modules/organizer_applications/bindings/organizer_applications_binding.dart';
import '../modules/organizer_applications/views/organizer_applications_view.dart';
import '../modules/organizer_dashboard/bindings/organizer_dashboard_binding.dart';
import '../modules/organizer_dashboard/views/organizer_dashboard_view.dart';
import '../modules/projects_details/bindings/projects_details_binding.dart';
import '../modules/projects_details/views/projects_details_view.dart';
import '../modules/volunteer_dashboard/bindings/volunteer_dashboard_binding.dart';
import '../modules/volunteer_dashboard/views/volunteer_dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VOLUNTEER_DASHBOARD,
      page: () => const VolunteerDashboardView(),
      binding: VolunteerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROJECTS_DETAILS,
      page: () => const ProjectsDetailsView(),
      binding: ProjectsDetailsBinding(),
    ),
    GetPage(
      name: _Paths.APPLIED_PROJECTS,
      page: () => const AppliedProjectsView(),
      binding: AppliedProjectsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ORGANIZER_DASHBOARD,
      page: () => const OrganizerDashboardView(),
      binding: OrganizerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROJECT,
      page: () => const CreateProjectView(),
      binding: CreateProjectBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_PROJECT,
      page: () => const ManageProjectView(),
      binding: ManageProjectBinding(),
    ),
    GetPage(
      name: _Paths.ORGANIZER_APPLICATIONS,
      page: () => const OrganizerApplicationsView(),
      binding: OrganizerApplicationsBinding(),
    ),
  ];
}
