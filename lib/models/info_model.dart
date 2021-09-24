import 'package:news/models/auth_model.dart';

class InfoModel {
  final ApiModel api;
  final StatusModel status;
  final DataModel data;

  InfoModel({
    required this.api,
    required this.status,
    required this.data,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      api: ApiModel.fromJson(json['api'] ?? {}),
      status: StatusModel.fromJson(json['status'] ?? {}),
      data: DataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class DataModel {
  final List<NewsModel> news;

  DataModel({required this.news});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    final list = <NewsModel>[];
    final listInfo = json['list_info'] ?? [];

    for (var item in listInfo) {
      list.add(NewsModel.fromJson(item));
    }

    return DataModel(news: list);
  }
}

class NewsModel {
  final String id, isi, tglTampil, img, author;

  NewsModel({
    required this.id,
    required this.isi,
    required this.tglTampil,
    required this.img,
    required this.author,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      isi: json['isi'] ?? '',
      tglTampil: json['tgl_tampil'] ?? '',
      img: json['img'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
