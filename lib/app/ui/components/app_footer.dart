import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});
  final String adminPanelVersion = 'v1.0.0';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade50,
      surfaceTintColor: Colors.blueGrey.shade50,
      elevation: 3,
      shadowColor: AppColors.k3b7ddd.withOpacity(0.1),
      centerTitle: false,
      titleSpacing: 30,
      title: Text(
        'Click2Cater \u00a9',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.k000000,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            adminPanelVersion,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
