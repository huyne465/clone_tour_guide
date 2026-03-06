import 'package:dio/dio.dart';
import 'package:clone_tour_guide/models/floor.dart';
import 'package:clone_tour_guide/services/api_client.dart';

class FloorsService {
  final ApiClient _apiClient;

  FloorsService(this._apiClient);

  Future<List<Floor>> getFloors() async {
    try {
      final response = await _apiClient.dio.get('/floors');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Floor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load floors');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load floors: ${e.message}');
    }
  }
}
