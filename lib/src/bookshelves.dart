import 'package:flutter/material.dart';
import './services/database.dart';
import './create_test/create_test.dart';
import 'package:provider/provider.dart';
import 'test/test_manager.dart';

class BookShelves extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Database database=Provider.of<Database>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(
            child: Text(
              'Create test',
                style:TextStyle(fontSize: 30.0,color:Colors.blue,),
            ),
            onPressed: ()=>Navigator.of(context)
                .push(MaterialPageRoute(
                builder:(context)=>CreateTest(database: database,),
                fullscreenDialog: true),
            ),
          ),
        ),
      ),
    );
  }
}
