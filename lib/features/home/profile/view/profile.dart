import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/home/profile/view/widgets/profile_widget.dart';
import '../../../auth/update_profile/view/update_profile.dart';
import '../provider/profile_notifier.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider); // Lấy trạng thái từ Notifier

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: text20Bold(text: "Profile", color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: false, // Loại bỏ nút back mặc định
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundImage: profileState.imagePath != null
                          ? NetworkImage(profileState.imagePath!)
                          : const AssetImage("assets/images/default_avatar.png")
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => print("Edit Profile Picture tapped"),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                text20Bold(
                  text: profileState.userName ?? "Default User",
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // Danh sách các mục
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                profileOption(
                  icon: Icons.person_outline,
                  title: "Thông tin cá nhân",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpdateProfilePage(),
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
                  icon: Icons.shopping_bag_outlined,
                  title: "Phiếu đặt lịch",
                  onTap: () => print("My Orders tapped"),
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

                    // Hiển thị hộp thoại xác nhận trước khi đăng xuất
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
                      // Thực hiện logout
                      await notifier.logout();

                      // Kiểm tra trạng thái isLoggedOut
                      if (ref.read(profileNotifierProvider).isLoggedOut) {
                        // Điều hướng về màn hình SignIn
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/sign-in', // Route màn hình SignIn
                              (route) => false, // Xóa toàn bộ stack
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
