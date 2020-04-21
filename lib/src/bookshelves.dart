import 'package:flutter/material.dart';

class BookShelves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Bookshelves',
              style:TextStyle(fontSize: 30.0,color:Colors.blue,)
          ),
        ),
      ),
    );
  }
}
