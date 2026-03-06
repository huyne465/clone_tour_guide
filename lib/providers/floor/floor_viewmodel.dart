import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone_tour_guide/models/floor.dart';
import 'package:clone_tour_guide/providers/api_providers.dart';

final floorsViewModelProvider = FutureProvider<List<Floor>>((ref) async {
  final floorsService = ref.watch(floorServiceProvider);
  return floorsService.getFloors();
});
