import 'package:flutter_flirting/models/user_model.dart';

class ArticleModel {
  final String? slug;
  final String? title;
  final String? description;
  final String? body;
  final List<String>? tagList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? favorited;
  final int? favoritesCount;
  final UserModel? author;

  const ArticleModel({
    this.slug,
    this.title,
    this.description,
    this.body,
    this.tagList,
    this.createdAt,
    this.updatedAt,
    this.favorited,
    this.favoritesCount,
    this.author,
  });

  ArticleModel copyWith({
    String? slug,
    String? title,
    String? description,
    String? body,
    List<String>? tagList,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? favorited,
    int? favoritesCount,
    UserModel? author,
  }) =>
      ArticleModel(
        slug: slug ?? this.slug,
        title: title ?? this.title,
        description: description ?? this.description,
        body: body ?? this.body,
        tagList: tagList ?? this.tagList,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        favorited: favorited ?? this.favorited,
        favoritesCount: favoritesCount ?? this.favoritesCount,
        author: author ?? this.author,
      );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    List<String> tagList = [];
    for (var tag in json['tagList'] as List<dynamic>? ?? []) {
      tagList.add(tag.toString());
    }
    return ArticleModel(
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      body: json['body'],
      tagList: tagList,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      favorited: json['favorited'],
      favoritesCount: json['favoritesCount'],
      author: UserModel.fromJson(json['author']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      'body': body,
      'tagList': tagList,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'favorited': favorited,
      'favoritesCount': favoritesCount,
      'author': author?.toJson(),
    };
  }

  @override
  String toString() {
    return 'ArticleModel(slug: $slug, title: $title, description: $description, body: $body, tagList: ${tagList.toString()}, createdAt: ${createdAt?.toIso8601String()}, updatedAt: ${updatedAt?.toIso8601String()}, favorited: $favorited, favoritesCount: $favoritesCount, author: ${author.toString()})';
  }
}
