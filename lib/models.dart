import 'package:timeago/timeago.dart' as timeago;

class Model {
  Model({
    required this.source,
    required this.description,
    required this.time,
    required this.image,
  });

  factory Model.fromJson({required Map<String, dynamic> json}) {
    return Model(
      source: (((json['source'] ?? {}) as Map<String, dynamic>)['name'] ?? '')
          as String,
      description: (json['title'] ?? '') as String,
      time: (json['publishedAt'] != '')
          ? timeago.format(DateTime.parse(json['publishedAt'] as String))
          : '0 seconds ago',
      image: (json['urlToImage'] ??
              'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png')
          as String,
    );
  }

  final String source;
  final String description;
  final String time;
  final String image;
}
