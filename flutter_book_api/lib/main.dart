import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_book_api/create_book.dart';
import 'package:flutter_book_api/data/book/book_repository.dart';
import 'package:flutter_book_api/data/book/book_view_model.dart';
import 'package:provider/provider.dart';

import 'data/book.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => BookViewModel())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => MyHomePage(title: "Book"),
        "create_book": (context) => CreateBookPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Book> bookList = List<Book>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    Provider.of<BookViewModel>(context, listen: false).fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<BookViewModel>(
        builder: (context, bookView, child) {
          return ListView.builder(
              itemCount: bookView.books.length,
              itemBuilder: (context, index) {
                return BookWidget(book: bookView.books[index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "create_book");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BookWidget extends StatelessWidget {
  final Book book;

  const BookWidget({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int imgRandom = new Random().nextInt(8) + 1;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/$imgRandom.jpg",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "create_book",
                        arguments: UpdateBookArg(
                            book.id, book.name, book.description));
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.8)),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      )),
                ),
                right: 5,
                top: 5,
              ),
              Positioned(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      book.updatedAt,
                      style: TextStyle(color: Colors.white),
                    )),
                bottom: 5,
                right: 5,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              book.name,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Text(book.description)
        ],
      ),
    );
  }
}
