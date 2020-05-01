import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/search_list_item_bar.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'package:learnink/src/widgets/notification_icon_button.dart';
import '../models/subject.dart';
import 'subject_page_list_item.dart';

class SubjectPageModel{
  SubjectPageModel({this.selected,this.isSelected});
  List<int> selected;
  bool isSelected;

  SubjectPageModel copyWith({List<int> selected, bool isSelected}){
    return SubjectPageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
    );
  }
}


class SubjectPage extends StatefulWidget {
  SubjectPage({this.subjects,this.database});

  final List<Subject> subjects;
  final Database database;

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {

  StreamController<SubjectPageModel> _selectedController=StreamController<SubjectPageModel>();
  SubjectPageModel _model=SubjectPageModel(selected: [],isSelected: false);

  @override
  void dispose() {
    super.dispose();
    _selectedController.close();
  }

  void _onSelectItem(int index){
    List<int> selectedList=_model.selected;
    selectedList.contains(index)?selectedList.remove(index):selectedList.add(index);
    _model=_model.copyWith(selected:selectedList,isSelected: false);
    _selectedController.add(_model);
  }

  void _onSelectAll(bool newValue){
    List<int> selectedList=newValue?List<int>.generate(widget.subjects.length, (i) => i ):[];
    _model=_model.copyWith(selected:selectedList,isSelected:newValue);
    _selectedController.add(_model);
  }

  void _onAddtoBag()
  {
    _model=_model.copyWith(selected: [],isSelected: false);
    _selectedController.add(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff004fe0),
              Color(0xff002d7f),
            ],
            stops: [0.2, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.repeated,
          ),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: SafeArea(
          top: true,
          child: Container(
            color: Colors.transparent,
//                height: 50,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/icons/bg-art.png',
            ),
          ),
        ),
      ),
      Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text('All Subjects'),
          actions: <Widget>[
            NotificationIconButton(
              size:50,
              icon:MyFlutterIcons.shopping_cart,
              color:Colors.white,
              onPressed: (){},),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color:Colors.white,
              border: Border.all(
                  color: Colors.white, width: 2.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            //color: Colors.white,
            child: StreamBuilder(
              stream:_selectedController.stream,
              initialData:_model,
              builder:(context,snapshot){
                List<int> _selectedList=[];
                if(snapshot.hasData){
                  print('snapshot value ${snapshot.data}');
                  _selectedList=List.from(snapshot.data.selected);
                }

                if(snapshot.hasError){
                  _selectedList=[];
                }
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: 95.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding:EdgeInsets.all(0),
                            child: SearchListItemBar(
                              onClick:_onSelectAll,
                              isSelected: snapshot.data.isSelected,
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 120.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding:EdgeInsets.all(0),
                            child: SubjectPageListItem(subject:widget.subjects[index],
                              isFirst: index==0,
                              isLast: index == widget.subjects.length -1,
                              onSelectItem:()=>_onSelectItem(index),
                              isSelected:_selectedList.contains(index),
                               database:widget.database,
                          ),);
                        },
                        childCount: widget.subjects.length,
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      // fillOverscroll: true, // Set true to change overscroll behavior. Purely preference.
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: CustomOutlineButton(
                            child:Text('Add to Bag',
                              style:TextStyle(color:Colors.black),
                            ),
                            borderColor: Colors.black,
                            elevationColor: Colors.black,
                            onPressed: _onAddtoBag,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            )
        ),
      ),
    ]);

  }
}
