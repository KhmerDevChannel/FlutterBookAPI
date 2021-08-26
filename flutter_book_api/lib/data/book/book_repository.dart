import 'package:flutter_book_api/data/api_helper.dart';
import 'package:flutter_book_api/data/database_helper.dart';

import '../book.dart';

class BookRepository {
  static BookRepository? _instance;

  static BookRepository get instance {
    if (_instance == null) {
      _instance = BookRepository._internal();
    }
    return _instance!;
  }

  BookRepository._internal();

  Future<Book?> createBook(String name, String description) async {
    try {
      final book = await ApiHelper.instance.addBook(name, description);

      if (book != null) {
        print("createBook ${book.name}");
        //add to database
        await DatabaseHelper.instance.insertBook(book);
      }
      return book;
    } catch (ex) {
      return null;
    }
  }

  Future<Book?> updateBook(String id, String name, String description) async {
    try {
      final book = await ApiHelper.instance.updateBook(id, name, description);
      if (book != null) {
        //update book to database
        await DatabaseHelper.instance.updateBook(book);
      }
      return book;
    } catch (ex) {
      return null;
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final bookList = await ApiHelper.instance.fetchBooks();
      if (bookList.isNotEmpty){
        //add to database
        bookList.forEach((element) async{
          await DatabaseHelper.instance.insertBook(element);
        });
      }
      return bookList;
    } catch (ex) {
      return List.empty();
    }
  }
}
