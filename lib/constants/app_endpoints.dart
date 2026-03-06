import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEndpoints {
  AppEndpoints._();

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  static const String pois = '/pois';
  static const String poisCode = '/pois/code';
  static const String floors = '/floors';

  static String floorMapImage(String floorId) => '/floors/$floorId/map-image';
}
