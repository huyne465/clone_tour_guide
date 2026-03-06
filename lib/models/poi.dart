class Poi {
  final String id;
  final String code;
  final String title;
  final String? description;
  final String audioUrl;
  final int duration;
  final String? imageUrl;
  final double? positionX;
  final double? positionY;
  final String floorId;

  Poi({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    required this.audioUrl,
    required this.duration,
    this.imageUrl,
    this.positionX,
    this.positionY,
    required this.floorId,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audio_url'],
      duration: json['duration'],
      imageUrl: json['image_url'],
      positionX: json['position_x'] != null
          ? (json['position_x'] as num).toDouble()
          : null,
      positionY: json['position_y'] != null
          ? (json['position_y'] as num).toDouble()
          : null,
      floorId: json['floor_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'audio_url': audioUrl,
      'duration': duration,
      'image_url': imageUrl,
      'position_x': positionX,
      'position_y': positionY,
      'floor_id': floorId,
    };
  }
}
