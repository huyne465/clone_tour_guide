import 'package:clone_tour_guide/shared/widgets/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../router/routes_name.dart';
import '../../constants/theme/theme_extensions.dart';
import '../../constants/theme/app_size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 600.h,
              backgroundColor: context.colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/dinh_doc_lap.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(Icons.image, size: 50.w, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusXL),
                  ),
                ),
                // Optional: slightly pull up the container over the image
                transform: Matrix4.translationValues(0, -30.h, 0),
                child: Padding(
                  padding: context.paddingXL,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppString.introTitle.tr(),
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.primary,
                                fontSize: AppConstants.fontSizeHeadlineSmall,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            context.gapLG,
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

                        SizedBox(height: 300.h),
                        Align(
                          alignment: AlignmentGeometry.bottomCenter,
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Download button
                                Expanded(
                                  child: CustomFilledButton(
                                    label: AppString.download.tr(),
                                    icon: Icon(
                                      Icons.download,
                                      color: context.colorScheme.onPrimary,
                                    ),
                                    onPressed: () {
                                      //download func
                                    },
                                  ),
                                ),
                                context.gapMD, // width 16
                                // Start Tour button
                                Expanded(
                                  child: CustomFilledButton(
                                    label: AppString.startTour.tr(),
                                    icon: Icon(
                                      Icons.play_circle_fill,
                                      color: context.colorScheme.onPrimary,
                                    ),
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed(RoutesName.main);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            backgroundColor: context.colorScheme.primary,
            heroTag: 'map_btn',
            onPressed: () {},
            child: Icon(Icons.map, color: context.colorScheme.onPrimary),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
