import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pms_module/ui/controller/auth_controller.dart';
import 'package:pms_module/ui/widgets/snack_bar.dart';
import '../utils/app_color.dart';

class PMSAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PMSAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

  final TextTheme textTheme;
  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    //final AuthController authController = Get.find<AuthController>();
    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AuthController.userModel?.photo != null &&
                    AuthController.userModel!.photo!.isNotEmpty
                ? MemoryImage(base64Decode(AuthController.userModel!.photo!))
                : null,
            child: AuthController.userModel?.photo == null ||
                    AuthController.userModel!.photo!.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (fromUpdateProfile == true) {
                  //Get.toNamed(UpdateProfileScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _logOutFromTaskListScreen(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _logOutFromTaskListScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () async {
                await AuthController.clearUserData();

                showSnackBarMessage(context, 'Logged Out successfully');

                //Get.offAllNamed(SignInScreen.name);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
