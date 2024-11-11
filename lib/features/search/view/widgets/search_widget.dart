import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/routes/app_routes_name.dart';
import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/app_textfieds.dart';
import '../search.dart';

Widget searchBar(BuildContext context, WidgetRef ref, TextEditingController searchController) {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Row(
      children: [
        Expanded(
          child: appSearchBar(context: context,
            hintText: 'Tìm kiếm sản phẩm...',
            searchController: searchController,
            onSearch: (value) {
              if (value.isNotEmpty) {
                // Điều hướng tới SearchPage khi nhấn vào thanh tìm kiếm
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(keyword: value),
                ));
              }
            },
            onVoiceSearchTap: () {
              print("Microphone tapped");
            },
            isOnSearchPage: false, // Chỉ cần điều hướng từ ProductPage
          ),
        ),
        SizedBox(width: 10.w),
      ],
    ),
  );
}