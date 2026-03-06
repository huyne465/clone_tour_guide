import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../router/routes_name.dart';
import '../../constants/theme/app_size_config.dart';
import '../../constants/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/dinh_doc_lap.jpg', // Tạm thời dùng placeholder path
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: context.colorScheme.primaryContainer,
                child: const Center(
                  child: Text(
                    'Background Image Placeholder\n(Add assets/images/dinh_doc_lap.jpg)',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Gradient overlay for better text readability and styling
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top spacing
                SizedBox(height: 60.h),

                // Logo placeholder area (Centered)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 20.h,
                  ),
                  color: Colors.white.withValues(alpha: 0.9),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fingerprint, // Tạm thời logo
                        color: context.colorScheme.primary,
                        size: 48.w,
                      ),
                      context.gapMD, // 16px gap
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.guideApp.tr(),
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeHeadlineLarge,
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            AppString.vietnamDiscovery.tr(),
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLabelSmall,
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: CircleAvatar(
                    radius: 30.w,
                    backgroundColor: context.colorScheme.primary,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30.w,
                      ),
                      onPressed: () {
                        // Navigate to Intro screen
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(RoutesName.intro);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
