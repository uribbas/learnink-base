import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class SearchListItemBar extends StatelessWidget {
  SearchListItemBar({this.isSelected,this.onClick});

  final bool isSelected;
  final ValueChanged<bool> onClick;

 @override
  Widget build(BuildContext context) {
    return Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 36.0,
            decoration: BoxDecoration(
              color:Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
            ),
            child: _buildSearchBox()
        ),
        CheckboxListTile(
              title: Container(
                alignment: Alignment.centerRight,
                child: Text("Select All",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ), //    <-- label
              value: isSelected,
              activeColor: isSelected? Colors.greenAccent : Colors.black12,
              onChanged: onClick,
              controlAffinity: ListTileControlAffinity.trailing
        ),
      ],
    );
  }
  TextField _buildSearchBox() {
    return TextField(
//      controller: _passwordController,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12.0),
//        labelText: 'Enter search tags',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintText: 'Search',
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, ) ,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, ) ,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search,color:Colors.black,),
          onPressed: () {},
        ),
      ),
      textInputAction: TextInputAction.next,
    );
  }

}

