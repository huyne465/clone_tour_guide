import 'package:clone_tour_guide/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone_tour_guide/models/poi.dart';

final poisViewModelProvider = FutureProvider.family<List<Poi>, String?>((
  ref,
  floorId,
) async {
  final poiService = ref.watch(poiServiceProvider);
  return poiService.getPois(floorId: floorId);
});

final poiByCodeViewModelProvider = FutureProvider.family<Poi, String>((
  ref,
  code,
) async {
  final poiService = ref.watch(poiServiceProvider);
  return poiService.getPoiByCode(code);
});
