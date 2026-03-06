import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../constants/app_string.dart';
import '../../../constants/theme/app_size_config.dart';
import '../../../constants/theme/theme_extensions.dart';
import '../../../providers/api_providers.dart';
import '../../../router/routes_name.dart';
import '../../../shared/widgets/custom_numpad.dart';

class NumpadOverlaySheet extends HookConsumerWidget {
  const NumpadOverlaySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Temporary local state for overlay
    final codeState = useState<String>('');
    final isLoading = useState<bool>(false);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      padding: context.paddingLG,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: context.radiusXS,
            ),
          ),
          context.gapLG, // SizedBox(height: 24)
          Text(
            AppString.enterKeycodePrompt.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeTitleMedium,
            ),
          ),
          context.gapMD, // SizedBox(height: 16)
          Text(
            codeState.value.isEmpty ? '---' : codeState.value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeDisplaySmall,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: isLoading.value
                  ? context.colorScheme.outline
                  : context.colorScheme.onSurface,
            ),
          ),
          context.gapLG, // SizedBox(height: 24)
          CustomNumpad(
            onNumberTapped: (number) async =>
                codeState.value = codeState.value + number,
            onClearTapped: () async {
              if (codeState.value.isNotEmpty) {
                codeState.value = codeState.value.substring(
                  0,
                  codeState.value.length - 1,
                );
              }
            },
            onOkTapped: () async {
              if (codeState.value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppString.enterCodeError.tr())),
                );
                return;
              }
              isLoading.value = true;
              final code = codeState.value;
              try {
                await ref.read(poiServiceProvider).getPoiByCode(code);
                if (context.mounted) {
                  Navigator.pop(context); // close sheet
                  Navigator.of(context).pushReplacementNamed(
                    RoutesName.audioDetail,
                    arguments: code,
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
      ),
    );
  }
}
