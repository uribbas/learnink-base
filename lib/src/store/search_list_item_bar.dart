import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class SearchListItemBar extends StatefulWidget {
  SearchListItemBar({this.isCleared,this.onClick});

  final bool isCleared;
  final VoidCallback onClick;

  @override
  _SearchListItemBarState createState() => _SearchListItemBarState();
}

class _SearchListItemBarState extends State<SearchListItemBar> {
  bool _selected=false;
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
              value: _selected,
              activeColor: _selected ? Colors.greenAccent : Colors.black12,
              onChanged: (bool newValue) => _onSelectItem(newValue),
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

  void _onSelectItem(bool newValue)
  {
    setState(() {
      _selected= !_selected;
    });
    widget.onClick();
  }

}

