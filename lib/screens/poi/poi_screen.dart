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
import '../../providers/api_providers.dart';

class PoiScreen extends HookConsumerWidget {
  const PoiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode = useState<String>('');
    final isLoading = useState<bool>(false);

    return Column(
      children: [
        // App Bar area
        CustomAppBar(
          title: AppString.poiTitle.tr(),
          actions: [
            const LanguageSelector(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.info_outline, color: Colors.white),
            ),
          ],
        ),
        Text(
          AppString.enterKeycodePrompt.tr(),
          style: TextStyle(
            fontSize: AppConstants.fontSizeLabelMedium,
            fontWeight: FontWeight.bold,
            color: currentCode.value.isEmpty
                ? Colors.grey
                : context.colorScheme.onSurface,
          ),
        ),
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
                child: isLoading.value
                    ? SizedBox(
                        height: 32.h,
                        width: 32.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: context.colorScheme.primary,
                        ),
                      )
                    : Text(
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
              currentCode.value = currentCode.value + number;
            }
          },
          onClearTapped: () async {
            if (currentCode.value.isNotEmpty) {
              currentCode.value = currentCode.value.substring(
                0,
                currentCode.value.length - 1,
              );
            }
          },
          onOkTapped: () async {
            if (currentCode.value.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppString.enterCodeError.tr())),
              );
              return;
            }

            isLoading.value = true;
            try {
              // Validate that a POI exists for this code before navigating
              await ref
                  .read(poiServiceProvider)
                  .getPoiByCode(currentCode.value);
              if (context.mounted) {
                Navigator.of(context).pushNamed(
                  RoutesName.audioDetail,
                  arguments: currentCode.value,
                );
              }
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppString.poiNotFound.tr()),
                    backgroundColor: context.colorScheme.error,
                  ),
                );
              }
            } finally {
              if (context.mounted) {
                isLoading.value = false;
              }
            }
          },
        ),
      ],
    );
  }
}
