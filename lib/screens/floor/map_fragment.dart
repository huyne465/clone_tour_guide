import 'package:clone_tour_guide/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../router/routes_name.dart';
import '../../constants/theme/app_size_config.dart';
import '../../constants/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';
import 'package:clone_tour_guide/shared/widgets/language_selector.dart';

class MapFragment extends HookConsumerWidget {
  const MapFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floorIndex = useState(1);

    final floors = [
      AppString.floorBunker.tr(),
      AppString.floorGround.tr(),
      AppString.floorL1.tr(),
      AppString.floorL2.tr(),
      AppString.floorRooftop.tr(),
    ];

    return Column(
      children: [
        // App Bar area
        CustomAppBar(
          title: AppString.mapTitle.tr(),
          actions: [
            const LanguageSelector(),
            context.gapMD, // SizedBox(width: 16)
            const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ), // Scanner icon as in mockup
          ],
        ),

        // Map Image Area
        Expanded(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Placeholder Map Background
                Container(
                  margin: context.paddingMD,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 100.w,
                          color: Colors.grey.shade300,
                        ),
                        context.gapMD, // SizedBox(height: 16)
                        Text(
                          '${AppString.mapTitle.tr()}: ${floors[floorIndex.value]}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),

                // Example Map Marker POI (Mockup)
                Positioned(
                  top: 150,
                  left: 120,
                  child: _buildMapPin(context, '108'),
                ),
                Positioned(
                  top: 180,
                  left: 200,
                  child: _buildMapPin(context, '113'), // Centered room
                ),
                Positioned(
                  bottom: 120,
                  right: 150,
                  child: _buildMapPin(context, '102'),
                ),
              ],
            ),
          ),
        ),

        // Floor Selector Tab Bar
        Container(
          color: Colors.black, // Dark background from mockup for floors
          height: ScreenUtil().bottomBarHeight * 1.4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: floors.length,
            itemBuilder: (context, index) {
              final isSelected = index == floorIndex.value;
              return InkWell(
                onTap: () => floorIndex.value = index,
                child: Container(
                  width: 65.w,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.layers, // Placeholder for map layers icon
                        color: isSelected ? Colors.amber : Colors.white54,
                        size: 20.sp,
                      ),
                      context.gapXS, // SizedBox(height: 4)
                      Text(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        floors[index],
                        style: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white54,
                          fontSize: AppConstants.fontSizeLabelMedium,

                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMapPin(BuildContext context, String code) {
    return InkWell(
      onTap: () {
        // Navigate directly to audio detail
        Navigator.of(
          context,
        ).pushNamed(RoutesName.audioDetail, arguments: code);
      },
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          code,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppConstants.fontSizeLabelSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
