import 'package:clone_tour_guide/shared/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../constants/theme/app_size_config.dart';
import '../../../constants/theme/theme_extensions.dart';

class AudioPlayerSection extends StatelessWidget {
  final AudioPlayer player;
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  const AudioPlayerSection({
    super.key,
    required this.player,
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slider
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 2.0.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.w),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 14.w),
                activeTrackColor: context.colorScheme.onSurface,
                inactiveTrackColor: context.colorScheme.outlineVariant,
                thumbColor: context.colorScheme.onSurface,
              ),
              child: Slider(
                value: position.inMilliseconds.toDouble(),
                min: 0,
                max: duration.inMilliseconds.toDouble() > 0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0,
                onChanged: (value) {
                  player.seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            context.gapSM, // SizedBox(height: 8)
            // Timers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringHelper.formatDuration(position),
                  style: context.textTheme.labelSmall,
                ),
                Text(
                  StringHelper.formatDuration(duration),
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
            context.gapMD, // SizedBox(height: 16)
            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 14.w,
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {
                    final newPosition = position - const Duration(seconds: 10);
                    player.seek(
                      newPosition < Duration.zero ? Duration.zero : newPosition,
                    );
                  },
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
                    iconSize: 24.w,
                    color: Colors.white,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        player.pause();
                      } else {
                        player.play();
                      }
                    },
                  ),
                ),
                context.gapLG, // SizedBox(width: 24)
                IconButton(
                  iconSize: 14.w,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {
                    final newPosition = position + const Duration(seconds: 10);
                    player.seek(
                      newPosition > duration ? duration : newPosition,
                    );
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
