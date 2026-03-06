import 'package:clone_tour_guide/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../router/routes_name.dart';

import '../../constants/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';
import 'package:clone_tour_guide/shared/widgets/language_selector.dart';

class ListFragment extends StatelessWidget {
  const ListFragment({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold key for showing snackbars if needed later
    return Column(
      children: [
        // App Bar area
        CustomAppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesName.intro);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: AppString.poiListTitle.tr(),
          actions: const [LanguageSelector()],
        ),
        // List content
        Expanded(
          child: ListView.separated(
            padding: context.paddingMD,
            itemCount: 15,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              // Mocking typical POI Items based on generic Tour Guide logic
              final poiCode = 100 + index;
              return Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: context.radiusSM,
                ),

                // padding: context.paddingMD,
                child: Column(
                  children: [
                    Container(
                      width: 50.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerHighest,
                        borderRadius: context.radiusSM,
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: context.radiusSM,
                      ),
                      child: ListTile(
                        title: Text(
                          '$poiCode - ${AppString.attraction.tr()}',
                          style: TextStyle(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${AppString.duration.tr()}: 03:${10 + index}',
                          style: TextStyle(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: context.colorScheme.onPrimary,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesName.audioDetail,
                            arguments: poiCode.toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
