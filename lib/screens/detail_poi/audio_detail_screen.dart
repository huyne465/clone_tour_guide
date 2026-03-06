import 'package:clone_tour_guide/screens/detail_poi/widgets/audio_player_section.dart';
import 'package:clone_tour_guide/screens/detail_poi/widgets/numpad_overlay_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../constants/theme/app_size_config.dart';
import '../../constants/theme/theme_extensions.dart';
import '../../providers/poi/poi_provider.dart';
import '../../shared/widgets/language_selector.dart';

import '../../constants/app_string.dart';
import 'package:easy_localization/easy_localization.dart';

class AudioDetailScreen extends HookConsumerWidget {
  const AudioDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Expected arguments: String representing POI Code
    final poiCode = ModalRoute.of(context)?.settings.arguments as String;
    final poiAsyncValue = ref.watch(poiByCodeViewModelProvider(poiCode));

    return poiAsyncValue.when(
      loading: () {
        return Skeletonizer(
          enabled: true,
          child: Scaffold(
            appBar: AppBar(title: Text(AppString.loading.tr())),
            body: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(color: Colors.grey.shade300),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 4.h, color: Colors.grey),
                        SizedBox(height: 8.h),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('00:00'), Text('03:00')],
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.replay_10, size: 32.w),
                            SizedBox(width: 24.w),
                            Icon(Icons.play_circle, size: 48.w),
                            SizedBox(width: 24.w),
                            Icon(Icons.forward_10, size: 32.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(AppString.loadError.tr()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: context.colorScheme.error,
                size: 64.w,
              ),
              context.gapMD,
              Text(
                AppString.poiNotFound.tr(),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
      data: (poi) {
        // Initialize AudioPlayer using hooks
        final player = useMemoized(() => AudioPlayer());

        useEffect(() {
          if (poi.audioUrl.isNotEmpty) {
            player.setUrl(poi.audioUrl).catchError((error) {
              debugPrint("Error loading audio: $error");
              return null;
            });
          }
          return player.dispose;
        }, [poi.audioUrl]);

        // Stream hooks
        final playerState = useStream(player.playerStateStream);
        final positionStream = useStream(player.positionStream);
        final durationStream = useStream(player.durationStream);

        final isPlaying = playerState.data?.playing ?? false;
        final position = positionStream.data ?? Duration.zero;
        final duration = durationStream.data ?? Duration(seconds: poi.duration);

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.h,
                pinned: true,
                backgroundColor: context.colorScheme.surface,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.3),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  const LanguageSelector(),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: AppConstants.spacingSM.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    poi.title,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeTitleMedium,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: context.colorScheme.surfaceContainerHighest,
                        child: poi.imageUrl != null
                            ? Image.network(
                                poi.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                              )
                            : const Center(
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                      ),
                      // Overlay gradient for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Mockup style overlay for vintage look
                      Container(color: Colors.white.withValues(alpha: 0.1)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLG,
                    vertical: AppConstants.spacingXL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (poi.description != null &&
                          poi.description!.isNotEmpty)
                        Text(
                          poi.description!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: AppConstants.fontSizeBodyMedium,
                            height: 1.6,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      // Extra spacing for floating action button
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AudioPlayerSection(
            player: player,
            position: position,
            duration: duration,
            isPlaying: isPlaying,
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'show_overlay_numpad',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => const NumpadOverlaySheet(),
              );
            },
            child: const Icon(Icons.apps),
          ),
        );
      },
    );
  }
}
