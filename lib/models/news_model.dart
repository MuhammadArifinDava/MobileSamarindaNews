class NewsModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String image;
  final String categories;
  final String content;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.image,
    required this.categories,
    required this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      image: json['image'],
      categories: json['categories'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'image': image,
      'categories': categories,
      'content': content,
    };
  }
}
