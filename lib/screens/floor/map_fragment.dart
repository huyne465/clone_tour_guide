import 'package:clone_tour_guide/models/floor.dart';
import 'package:clone_tour_guide/providers/floor/floor_viewmodel.dart';
import 'package:clone_tour_guide/providers/poi/poi_viewmodel.dart';
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
            context.gapMD,
            const Icon(Icons.qr_code_scanner, color: Colors.white),
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
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (selectedFloor.value!.mapImageUrl != null)
                      Image.network(selectedFloor.value!.mapImageUrl!)
                    else
                      Container(
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
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    poisAsyncValue.when(
                      data: (pois) => Stack(
                        children: pois
                            .where(
                              (p) => p.positionX != null && p.positionY != null,
                            )
                            .map(
                              (poi) => Positioned(
                                top: poi.positionY,
                                left: poi.positionX,
                                child: _buildMapPin(context, poi.code),
                              ),
                            )
                            .toList(),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (e, s) =>
                          Center(child: Text('Failed to load POIs')),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Failed to load floors')),
          ),
        ),
        floorsAsyncValue.when(
          data: (floors) => Container(
            color: Colors.black,
            height: ScreenUtil().bottomBarHeight * 1.4,
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
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMapPin(BuildContext context, String code) {
    return InkWell(
      onTap: () {
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
              color: Colors.black.withOpacity(0.3),
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
