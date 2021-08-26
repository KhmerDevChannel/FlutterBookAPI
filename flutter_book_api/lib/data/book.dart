import 'package:flutter_book_api/data/date_utils.dart';

class Book {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  Book(this.id, this.name, this.description, this.createdAt, this.updatedAt);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final String createdAt = DateUtils.formatToLocalDate(json["createdAt"]);
    final String updatedAt = DateUtils.formatToLocalDate(json["updatedAt"]);
    return Book(
        json["id"], json["name"], json["description"], createdAt, updatedAt);
  }
}
