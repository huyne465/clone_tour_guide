import 'package:clone_tour_guide/providers/poi/poi_provider.dart';
import 'package:clone_tour_guide/shared/widgets/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../router/routes_name.dart';
import '../../constants/theme/theme_extensions.dart';
import '../../constants/theme/app_size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';

// POI code for the main introduction attraction (Dinh Độc Lập)
const String _kIntroPOICode = '113';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poiAsync = ref.watch(poiByCodeViewModelProvider(_kIntroPOICode));

    return poiAsync.when(
      loading: () => Skeletonizer(
        enabled: true,
        child: _buildScaffold(
          context: context,
          imageWidget: Container(
            color: context.colorScheme.surfaceContainerHighest,
          ),
          title: AppString.loading.tr(),
          description: AppString.loadingDesc.tr(),
          onStart: () {},
        ),
      ),
      error: (err, _) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: context.paddingXL,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: context.colorScheme.error,
                  ),
                  context.gapLG,
                  Text(
                    AppString.loadError.tr(),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium,
                  ),
                  context.gapLG,
                  CustomFilledButton(
                    label: AppString.retry.tr(),
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.invalidate(
                      poiByCodeViewModelProvider(_kIntroPOICode),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (poi) => _buildScaffold(
        context: context,
        imageWidget: poi.imageUrl != null
            ? Image.network(
                poi.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderImage(context),
              )
            : _placeholderImage(context),
        title: poi.title,
        description: poi.description,
        onStart: () =>
            Navigator.of(context).pushReplacementNamed(RoutesName.main),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) => Container(
    color: context.colorScheme.surfaceContainerHighest,
    child: Center(
      child: Icon(
        Icons.image_outlined,
        size: 60.w,
        color: Colors.grey.shade400,
      ),
    ),
  );

  Widget _buildScaffold({
    required BuildContext context,
    required Widget imageWidget,
    required String title,
    String? description,
    required VoidCallback onStart,
  }) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: CustomFilledButton(
                  label: AppString.download.tr(),
                  icon: Icon(
                    Icons.download,
                    color: context.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    // download func
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomFilledButton(
                  label: AppString.startTour.tr(),
                  icon: Icon(
                    Icons.play_circle_fill,
                    color: context.colorScheme.onPrimary,
                  ),
                  onPressed: onStart,
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: context.colorScheme.surface,
            floating: true,
            pinned: true,
            expandedHeight: 300.h,
            backgroundColor: context.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(background: imageWidget),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: BoxDecoration(color: context.colorScheme.surface),
                padding: context.paddingXS,
                child: Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                    fontSize: AppConstants.fontSizeHeadlineSmall,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusXL),
                ),
              ),
              transform: Matrix4.translationValues(0, -30.h, 0),
              child: Padding(
                padding: context.paddingXL,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      context.gapLG,
                      if (description != null && description.isNotEmpty)
                        Text(
                          description,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: AppConstants.fontSizeBodyMedium,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        )
                      else
                        Text(
                          AppString.introDesc.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: AppConstants.fontSizeBodyMedium,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.colorScheme.primary,
        heroTag: 'map_btn',
        onPressed: () {},
        child: Icon(Icons.map, color: context.colorScheme.onPrimary),
      ),
    );
  }
}
