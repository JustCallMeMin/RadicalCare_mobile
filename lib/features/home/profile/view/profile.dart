import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/home/profile/view/widgets/profile_widget.dart';
import '../../../../common/routes/app_routes_name.dart';
import '../../../auth/update_profile/view/update_profile.dart';
import '../provider/profile_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: text20Bold(text: "Profile", color: AppColors.secondary),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: profileState.userName == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: profileState.imagePath != null
                        ? NetworkImage(profileState.imagePath!)
                        : const AssetImage("assets/images/default_avatar.png")
                    as ImageProvider,
                  ),
                  SizedBox(height: 10.h),
                  text20Bold(
                    text: profileState.userName ?? "Default User",
                    color: Colors.black,
                  ),
                  SizedBox(height: 5.h),
                  text14Normal(
                    text: profileState.email ?? "No Email Provided",
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // Danh sách các mục
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                profileOption(
                  icon: Icons.person_outline,
                  title: "Thông tin cá nhân",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateProfilePage(),
                      ),
                    );
                  },
                ),
                profileOption(
                  icon: Icons.payment,
                  title: "Payment Methods",
                  onTap: () => print("Payment Methods tapped"),
                ),
                profileOption(
                  icon: Icons.calendar_today_outlined,
                  title: "Phiếu đặt lịch",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutesNames.APPOINTMENT_LIST,
                  ),
                ),
                profileOption(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () => print("Settings tapped"),
                ),
                profileOption(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  onTap: () => print("Help Center tapped"),
                ),
                profileOption(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () => print("Privacy Policy tapped"),
                ),
                profileOption(
                  icon: Icons.logout,
                  title: "Log out",
                  onTap: () async {
                    final notifier = ref.read(profileNotifierProvider.notifier);
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Log out"),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldLogout == true) {
                      await notifier.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/sign-in',
                            (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

