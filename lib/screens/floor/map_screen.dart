import 'package:clone_tour_guide/models/floor.dart';
import 'package:clone_tour_guide/providers/floor/floor_provider.dart';
import 'package:clone_tour_guide/providers/poi/poi_provider.dart';
import 'package:clone_tour_guide/screens/floor/widgets/map_pin.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

class MapScreen extends HookConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floorsAsyncValue = ref.watch(floorsViewModelProvider);
    final selectedFloor = useState<Floor?>(null);

    useEffect(() {
      if (floorsAsyncValue is AsyncData &&
          (floorsAsyncValue.value?.isNotEmpty ?? false)) {
        selectedFloor.value = floorsAsyncValue.value!.first;
      }
      return null;
    }, [floorsAsyncValue]);

    return Column(
      children: [
        CustomAppBar(
          title: AppString.mapTitle.tr(),
          actions: [
            const LanguageSelector(),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: () {
                // Handle QR Scan
              },
            ),
          ],
        ),
        Expanded(
          child: floorsAsyncValue.when(
            data: (floors) {
              if (selectedFloor.value == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final poisAsyncValue = ref.watch(
                poisViewModelProvider(selectedFloor.value!.id),
              );
              return LayoutBuilder(
                builder: (context, constraints) {
                  return InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    constrained: false,
                    boundaryMargin: EdgeInsets.all(constraints.maxWidth),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (selectedFloor.value!.mapImageUrl != null)
                          ColoredBox(
                            color: Colors.white,
                            child: Image.network(
                              selectedFloor.value!.mapImageUrl!,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxWidth * 0.75,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(
                                    width: constraints.maxWidth,
                                    height: constraints.maxWidth * 0.75,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.broken_image,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Không tải được ảnh bản đồ',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ),
                          )
                        else
                          Container(
                            width: constraints.maxWidth,
                            height: 400.h,
                            margin: context.paddingMD,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
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
                                  context.gapMD,
                                  Text(
                                    '${AppString.mapTitle.tr()}: ${selectedFloor.value!.name}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // Overlays on exact constraints of the image
                        Positioned.fill(
                          child: poisAsyncValue.when(
                            data: (pois) {
                              return Stack(
                                children: pois
                                    .where(
                                      (p) =>
                                          p.positionX != null &&
                                          p.positionY != null,
                                    )
                                    .map((poi) {
                                      // Using relative percentages. Assuming the original coordinates were based on
                                      // an example canvas size like width 400x300.
                                      // We normalize the coordinates (x/width, y/height) and multiply by constraints
                                      // This ensures the points remain responsive on screen.
                                      // We are dividing by an arbitrary 400 factor assuming original layout, let user tune this

                                      final normalizedX =
                                          poi.positionX!.toDouble() / 400.0;
                                      final normalizedY =
                                          poi.positionY!.toDouble() / 300.0;

                                      final leftPos =
                                          constraints.maxWidth * normalizedX;
                                      final topPos =
                                          (constraints.maxWidth * 0.75) *
                                          normalizedY; // Keep 4:3 aspect ratio roughly

                                      return Positioned(
                                        top: topPos,
                                        left: leftPos,
                                        child: MapPin(
                                          context: context,
                                          code: poi.code,
                                        ),
                                      );
                                    })
                                    .toList(),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (e, s) =>
                                Center(child: Text('Failed to load POIs')),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => Skeletonizer(
              enabled: true,
              child: Container(
                margin: context.paddingMD,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 100.w),
                      context.gapMD,
                      Text(
                        'Loading Floor Map...',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            error: (e, s) => Center(child: Text('Failed to load floors')),
          ),
        ),
        floorsAsyncValue.when(
          data: (floors) => Container(
            color: Colors.black,
            height: ScreenUtil().screenHeight * 0.08,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: floors.length,
              itemBuilder: (context, index) {
                final floor = floors[index];
                final isSelected = floor.id == selectedFloor.value?.id;
                return InkWell(
                  onTap: () => selectedFloor.value = floor,
                  child: Container(
                    width: 65.w,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.layers,
                          color: isSelected ? Colors.amber : Colors.white54,
                          size: 20.sp,
                        ),
                        context.gapXS,
                        Text(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          floor.name,
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
          loading: () => Skeletonizer(
            enabled: true,
            child: Container(
              color: Colors.black,
              height: ScreenUtil().screenHeight * 0.08,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 65.w,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers, color: Colors.white54, size: 20.sp),
                        context.gapXS,
                        Text(
                          'Floor',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppConstants.fontSizeLabelMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
