import 'package:flutter_book_api/data/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper? _instance;

  static DatabaseHelper get instance {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
    }
    return _instance!;
  }

  DatabaseHelper._internal();

  var database;

  Future<Database> getDatabase() async {
    if (database == null) {
      database = openDatabase(join(await getDatabasesPath(), "books.db"),
          onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE books(id TEXT PRIMARY KEY,name TEXT,description TEXT,createdAt Text,updatedAt TEXT);");
      }, version: 1);
    }
    return database;
  }

  Future<Book?> insertBook(Book book) async {
    try {
      final db = await getDatabase();
      int status = await db.insert("books", book.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("insertBook ${book.id}");
      return book;
    } catch (ex) {
      print("bookError $ex");
      return null;
    }
  }

  Future<Book?> updateBook(Book book) async {
    try {
      final db = await getDatabase();
      int status = await db.update(
          "books",
          {
            "name": book.name,
            "description": book.description,
            "updatedAt": book.updatedAt
          },
          where: "id=?",
          whereArgs: [book.id]);
      print("updated $status");
      return book;
    } catch (ex) {
      return null;
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final db = await getDatabase();
      List<Map<String, dynamic>> bookMap =
          await db.query("books", orderBy: "updatedAt DESC");
      return List.generate(bookMap.length, (index) {
        final book = bookMap[index];
        return Book(book["id"], book["name"], book["description"],
            book["createdAt"], book["updatedAt"]);
      });
    } catch (ex) {
      return List.empty();
    }
  }
}
