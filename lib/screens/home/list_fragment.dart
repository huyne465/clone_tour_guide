import 'package:clone_tour_guide/models/poi.dart';
import 'package:clone_tour_guide/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/poi/poi_viewmodel.dart';
import '../../router/routes_name.dart';
import '../../constants/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clone_tour_guide/constants/app_string.dart';
import 'package:clone_tour_guide/shared/widgets/language_selector.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
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
                    ? Image.network(
                        poi.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.error, color: Colors.red),
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
                  borderRadius: context.radiusSM,
                ),
                child: ListTile(
                  title: Text(
                    '${poi.code} - ${poi.title}',
                    style: TextStyle(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    poi.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colorScheme.onPrimary),
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
