class Floor {
  final String id;
  final String name;
  final int level;
  final String? mapImageUrl;

  Floor({
    required this.id,
    required this.name,
    required this.level,
    this.mapImageUrl,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      mapImageUrl: json['map_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'map_image_url': mapImageUrl,
    };
  }
}
