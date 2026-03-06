import 'package:clone_tour_guide/router/routes_name.dart';
import 'package:clone_tour_guide/shared/widgets/custom_appbar.dart';
import 'package:clone_tour_guide/shared/widgets/custom_numpad.dart';
import '../../constants/theme/app_size_config.dart';
import '../../constants/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';
import 'package:clone_tour_guide/shared/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeypadFragment extends HookConsumerWidget {
  const KeypadFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode = useState<String>('');

    return Column(
      children: [
        // App Bar area
        CustomAppBar(
          title: AppString.poiTitle.tr(),
          actions: [
            const LanguageSelector(),
            context.gapMD, // SizedBox(width: 16)
            const Icon(Icons.info_outline, color: Colors.white),
          ],
        ),
        // Container(
        //   color: context.colorScheme.primary,
        //   padding: context.paddingMD,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const Icon(Icons.arrow_back, color: Colors.white),
        //       Text(
        //         'POI',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: AppConstants.fontSizeTitleLarge,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       Row(
        //         children: [
        //           const Icon(Icons.language, color: Colors.white),
        //           context.gapMD, // SizedBox(width: 16)
        //           const Icon(Icons.info_outline, color: Colors.white),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),

        // Input Display Area
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colorScheme.primary,
                      width: 2.h,
                    ),
                  ),
                ),
                child: Text(
                  currentCode.value.isEmpty
                      ? AppString.enterCode.tr()
                      : currentCode.value,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeDisplayMedium,
                    fontWeight: FontWeight.bold,
                    color: currentCode.value.isEmpty
                        ? Colors.grey
                        : context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        context.gapXS,
        // Numpad Area
        CustomNumpad(
          onNumberTapped: (number) {
            if (currentCode.value.length < 4) {
              // Limit length if needed
              currentCode.value = currentCode.value + number;
            }
          },
          onClearTapped: () {
            if (currentCode.value.isNotEmpty) {
              currentCode.value = currentCode.value.substring(
                0,
                currentCode.value.length - 1,
              );
            }
          },
          onOkTapped: () {
            if (currentCode.value.isNotEmpty) {
              Navigator.of(
                context,
              ).pushNamed(RoutesName.audioDetail, arguments: currentCode.value);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppString.enterCodeError.tr())),
              );
            }
          },
        ),
      ],
    );
  }
}
