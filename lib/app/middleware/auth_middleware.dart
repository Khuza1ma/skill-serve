import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/local/user_provider.dart';
import '../routes/app_pages.dart';

class RouteMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return UserProvider.isLoggedIn
        ? null
        : const RouteSettings(name: Routes.LOGIN);
  }
}
