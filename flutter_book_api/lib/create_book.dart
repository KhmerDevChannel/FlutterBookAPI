import 'package:flutter/material.dart';
import 'package:flutter_book_api/data/book/book_repository.dart';
import 'package:flutter_book_api/data/book/book_view_model.dart';
import 'package:provider/provider.dart';

class UpdateBookArg {
  final String id;
  final String name;
  final String description;

  UpdateBookArg(this.id, this.name, this.description);
}

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({Key? key}) : super(key: key);

  @override
  _CreateBookPageState createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String? bookId;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    final UpdateBookArg? argBook = arg != null ? arg as UpdateBookArg : null;
    bookId = argBook?.id;
    if (argBook?.name != null) {
      nameController.text = argBook!.name;
    }
    if (argBook?.description != null) {
      descriptionController.text = argBook!.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(bookId == null ? "Create Book" : "Update Book"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input description";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Description"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String name = nameController.text;
                        final String description = descriptionController.text;
                        if (bookId != null) {
                          updateBook(bookId!, name, description);
                        } else {
                          createBook(name, description);
                        }
                      }
                    },
                    child: bookId == null ? Text("Create") : Text("Update")),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateBook(String id, String name, String description) async {
    final book = await Provider.of<BookViewModel>(context, listen: false)
        .updateBook(id, name, description);
    print("updateBook $book");
    if (book == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update book failed.")));
    } else {
      Navigator.pop(context);
    }
  }

  void createBook(name, description) async {
    final book = await Provider.of<BookViewModel>(context, listen: false)
        .addBook(name, description);
    print("createdBook $book");
    if (book == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Create book failed.")));
    } else {
      Navigator.pop(context);
    }
  }
}
