import 'dart:collection';
import 'dart:convert';

import 'package:flutter_book_api/data/book.dart';
import 'package:http/http.dart' as http;

final String baseUrl = "http://192.168.0.109:3000";

class ApiHelper {
  //create api helper as singleton class
  static ApiHelper? _instance;

  static ApiHelper get instance {
    if (_instance == null) {
      _instance = ApiHelper._internal();
    }
    return _instance!;
  }

  ApiHelper._internal();

  Future<Book?> addBook(String name, String description) async {
    try {
      print("addBook $name $description");
      final response = await http.post(Uri.parse("$baseUrl/create_book"),
          body: {"name": name, "description": description});
      print("response ${response.body} ${response.statusCode}");
      return Book.fromJson(jsonDecode(response.body));
    } catch (ex) {
      return null;
    }
  }

  Future<Book?> updateBook(String id, String name, String description) async {
    try {
      print("updateBook $id $name $description");
      final response = await http.post(Uri.parse("$baseUrl/update_book"),
          body: {"id": id, "name": name, "description": description});
      print("response ${response.body} ${response.statusCode}");
      return Book.fromJson(jsonDecode(response.body));
    } catch (ex) {
      return null;
    }
  }

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_books"));
      if (response.statusCode == 200) {
        final bookJsonList = jsonDecode(response.body);
        List<Book> books =
            List<Book>.from(bookJsonList.map((book) => Book.fromJson(book)));
        return books;
      } else {
        throw Exception("response error");
      }
    } catch (ex) {
      return List.empty();
    }
  }
}
