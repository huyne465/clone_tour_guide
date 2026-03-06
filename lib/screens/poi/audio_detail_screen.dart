import 'package:clone_tour_guide/router/routes_name.dart';
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

class AudioDetailScreen extends HookConsumerWidget {
  const AudioDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Expected arguments: String representing POI ID
    final poiId = ModalRoute.of(context)?.settings.arguments as String? ?? '00';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '$poiId - ${AppString.historyTitle.tr()}',
          style: TextStyle(fontSize: AppConstants.fontSizeTitleMedium),
        ),
        actions: [
          const LanguageSelector(),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Color / Default space
          Column(
            children: [
              // Top Image Section
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: context.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 100.w,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Mockup style overlay for vintage look
                    Container(color: Colors.white.withValues(alpha: 0.1)),
                  ],
                ),
              ),
              // Bottom Audio Player Control Section
              Expanded(
                flex: 4,
                child: Container(
                  color: context.colorScheme.surface,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLG,
                    vertical: AppConstants.spacingXL,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Slider
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2.0.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 6.w,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 14.w,
                          ),
                          activeTrackColor: context.colorScheme.onSurface,
                          inactiveTrackColor:
                              context.colorScheme.outlineVariant,
                          thumbColor: context.colorScheme.onSurface,
                        ),
                        child: Slider(
                          value: 45,
                          min: 0,
                          max: 100,
                          onChanged: (value) {},
                        ),
                      ),
                      context.gapSM, // SizedBox(height: 8)
                      // Timers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('00:45', style: context.textTheme.labelSmall),
                          Text('05:07', style: context.textTheme.labelSmall),
                        ],
                      ),
                      context.gapXL, // SizedBox(height: 32)
                      // Playback Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 32.w,
                            icon: const Icon(Icons.replay_10),
                            onPressed: () {},
                          ),
                          context.gapLG, // SizedBox(width: 24)
                          Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: context.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              iconSize: 48.w,
                              color: Colors.white,
                              icon: const Icon(Icons.play_arrow_rounded),
                              onPressed: () {},
                            ),
                          ),
                          context.gapLG, // SizedBox(width: 24)
                          IconButton(
                            iconSize: 32.w,
                            icon: const Icon(Icons.forward_10),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // OVERLAY KEYPAD Trigger Button
          Positioned(
            right: 16.w,
            bottom: 300.h,
            child: FloatingActionButton.small(
              heroTag: 'show_overlay_numpad',
              onPressed: () {
                _showNumpadOverlay(context);
              },
              child: const Icon(Icons.apps),
            ),
          ),
        ],
      ),
    );
  }

  void _showNumpadOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _NumpadOverlaySheet(),
    );
  }
}

class _NumpadOverlaySheet extends HookConsumerWidget {
  const _NumpadOverlaySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Temporary local state for overlay
    final codeState = useState<String>('');

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
            ),
          ),
          context.gapLG, // SizedBox(height: 24)
          CustomNumpad(
            onNumberTapped: (number) =>
                codeState.value = codeState.value + number,
            onClearTapped: () {
              if (codeState.value.isNotEmpty) {
                codeState.value = codeState.value.substring(
                  0,
                  codeState.value.length - 1,
                );
              }
            },
            onOkTapped: () {
              Navigator.pop(context); // close sheet
              if (codeState.value.isNotEmpty) {
                // push replacement so it doesn't pile up the backstack infinitely
                Navigator.of(context).pushReplacementNamed(
                  RoutesName.audioDetail,
                  arguments: codeState.value,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
