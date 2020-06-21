class News {
  String author;
  String title;
  String urlRawValue;
  String urlToImageRawValue;
  String publishedAtRawValue;
  DateTime get publishedAt => DateTime.parse(publishedAtRawValue);

  News() {
    this.author = "@GIGAZINE";
    this.title = "題名と前の人が書いた内容から続きを書いていくリレー小説制作ゲーム「じゃれ本」を遊んでみた";
    this.urlRawValue = "https://gigazine.net/news/20200502-jarebon-review/";
    this.urlToImageRawValue = "http://i.gzn.jp/img/2020/05/02/jarebon-review/00.jpg";
    this.publishedAtRawValue = "2020-05-02T12:30:00Z";
  }

  News.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        title = json['title'],
        urlRawValue = json['url'],
        urlToImageRawValue = json['urlToImage'],
        publishedAtRawValue = json['publishedAt'];
}