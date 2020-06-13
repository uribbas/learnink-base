import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
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
              'Take test',
                style:TextStyle(fontSize: 30.0,color:Colors.blue,),
            ),
            onPressed: ()=>Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder:(context)=>TestManager(database: database,),fullscreenDialog: true)),
          ),
        ),
      ),
    );
  }
}
