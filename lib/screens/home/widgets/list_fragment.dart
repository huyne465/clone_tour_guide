import 'package:clone_tour_guide/constants/theme/theme_extensions.dart';
import 'package:clone_tour_guide/models/poi.dart';
import 'package:clone_tour_guide/providers/poi/poi_provider.dart';
import 'package:clone_tour_guide/router/routes_name.dart';
import 'package:clone_tour_guide/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';
import 'package:clone_tour_guide/shared/widgets/language_selector.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListFragment extends ConsumerWidget {
  const ListFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poisAsyncValue = ref.watch(poisViewModelProvider(null));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          title: AppString.poiListTitle.tr(),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesName.intro);
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          actions: const [LanguageSelector()],
        ),
      ),
      body: poisAsyncValue.when(
        data: (pois) => buildPoiList(context, pois),
        loading: () {
          final dummyPois = List.generate(
            5,
            (index) => Poi(
              id: 'dummy_$index',
              code: '00$index',
              title: 'Loading Title $index',
              audioUrl: '',
              duration: 0,
              floorId: '',
              imageUrl:
                  '', // ensures the image box is rendered as a skeleton block
            ),
          );
          return Skeletonizer(
            enabled: true,
            child: buildPoiList(context, dummyPois),
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget buildPoiList(BuildContext context, List<Poi> pois) {
    if (pois.isEmpty) {
      return const Center(child: Text('No points of interest found.'));
    }
    return ListView.separated(
      padding: context.paddingMD,
      itemCount: pois.length,
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final poi = pois[index];
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: context.radiusSM,
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200.h,
                child: poi.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: context.radiusSM.topLeft,
                          topRight: context.radiusSM.topRight,
                        ),
                        child: Image.network(
                          poi.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: context.radiusSM.bottomLeft,
                    bottomRight: context.radiusSM.bottomRight,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    '${poi.code} - ${poi.title}',
                    style: TextStyle(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Icon(
                    Icons.chevron_right,
                    color: context.colorScheme.onPrimary,
                  ),
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(RoutesName.audioDetail, arguments: poi.code);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
