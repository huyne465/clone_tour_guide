import 'package:dio/dio.dart';
import 'package:clone_tour_guide/models/poi.dart';
import 'package:clone_tour_guide/services/api_client.dart';

class PoisService {
  final ApiClient _apiClient;

  PoisService(this._apiClient);

  Future<List<Poi>> getPois({String? floorId}) async {
    try {
      final response = await _apiClient.dio.get(
        '/pois',
        queryParameters: {if (floorId != null) 'floorId': floorId},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Poi.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pois');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load pois: ${e.message}');
    }
  }

  Future<Poi> getPoiByCode(String code) async {
    try {
      final response = await _apiClient.dio.get('/pois/code/$code');
      if (response.statusCode == 200) {
        return Poi.fromJson(response.data);
      } else {
        throw Exception('Failed to get POI by code');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get POI by code: ${e.message}');
    }
  }
}
