import 'package:clone_tour_guide/services/floors_service.dart';
import 'package:clone_tour_guide/services/pois_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone_tour_guide/services/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final poiServiceProvider = Provider<PoisService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PoisService(apiClient);
});

final floorServiceProvider = Provider<FloorsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FloorsService(apiClient);
});
