import 'package:flutter/material.dart';
import 'package:flutter_book_api/data/book/book_repository.dart';

import '../book.dart';
import '../database_helper.dart';

class BookViewModel extends ChangeNotifier {
  final List<Book> books = [];

  Future<Book?> addBook(name, description) async {
    try {
      final book = await BookRepository.instance.createBook(name, description);
      if (book != null) {
        books.insert(0, book);
      }
      notifyListeners();
      return book;
    } catch (ex) {
      return null;
    }
  }

  Future<Book?> updateBook(String id, String name, String description) async {
    try {
      final book =
          await BookRepository.instance.updateBook(id, name, description);
      if (book != null) {
        int index = books.indexWhere((book) => book.id == id);
        books[index] = book;
      }
      books.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notifyListeners();
      return book;
    } catch (ex) {
      return null;
    }
  }

  void fetchBooks() async {
    try {
      //update ui with local data
      final dbBooks = await DatabaseHelper.instance.getBooks();
      books.clear();
      books.addAll(dbBooks);
      notifyListeners();
      //update ui with data that request from server
      final mBooks = await BookRepository.instance.getBooks();
      if (mBooks.isNotEmpty) {
        books.clear();
        books.addAll(mBooks);
        books.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        notifyListeners();
      }
    } catch (ex) {
      print("fetchBookError $ex");
    }
  }
}
