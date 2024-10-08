class MyImage {
  MyImage({
    required this.id,
    required this.webformatURL,
    required this.largeImageURL,
    required this.views,
    required this.likes,
  });
  late final int id;
  late final String webformatURL;
  late final String largeImageURL;
  late final int views;
  late final int likes;

  MyImage.fromJson(Map<String, dynamic> json){
    id = json['id'];
    webformatURL = json['webformatURL'];
    largeImageURL = json['largeImageURL'];
    views = json['views'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['webformatURL'] = webformatURL;
    data['largeImageURL'] = largeImageURL;
    data['views'] = views;
    data['likes'] = likes;
    return data;
  }
}
