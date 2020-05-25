import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/search_list_item_bar.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'package:learnink/src/store/notification_icon_button.dart';
import '../models/subject.dart';
import '../models/cart.dart';
import '../services/database.dart';
import 'subject_page_list_item.dart';
import 'subject_page_model.dart';
import 'package:provider/provider.dart';
import '../services/toastMessage.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({this.subjects,this.database});

  final List<Subject> subjects;
  final Database database;
  List<Subject> filteredSubjects;

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {

  StreamController<SubjectPageModel> _selectedController=StreamController<SubjectPageModel>();
  SubjectPageModel _model=SubjectPageModel(selected: [],isSelected: false, searchText: []);

  StreamSubscription _userCart;
  Cart _userCartData;

  @override
  void dispose() {
    super.dispose();
    _selectedController.close();
  }

  void _onSearch(String searchText){
    String cleanText = searchText.trim().replaceAll(RegExp(r' +'), ' ');
    print("cleanText $cleanText");

    _model = _model.copyWith(selected: _model.selected,
                            isSelected: _model.isSelected ? false : _model.isSelected,
                            searchText: cleanText=='' ? [] : cleanText.split(' ')
                            );
    _selectedController.add(_model);

    setState(() {});
  }

  void _onSelectItem(Subject subject){
//    print("Calling subject ${subject.subjectName} ${subject.documentId} " );
    List<Subject> selectedList=_model.selected;
    selectedList.indexWhere((s)=>s.documentId == subject.documentId) == -1 ?
                selectedList.add(subject)
                :
                selectedList.removeWhere((s) => s.documentId == subject.documentId);
//    print("selected lenth post check ${selectedList.length}");
    _model=_model.copyWith(selected:selectedList,isSelected: false, searchText: _model.searchText);
    _selectedController.add(_model);
  }

  void _onSelectAll(bool newValue){
    List<Subject> selectedList=newValue?List<Subject>.generate(widget.filteredSubjects.length, (i) => widget.filteredSubjects[i] ):[];
    _model=_model.copyWith(selected:selectedList,isSelected:newValue, searchText: _model.searchText);
    _selectedController.add(_model);
  }

  void _onAddtoBag(BuildContext context)
  async {
    if(_model.selected.length > 0 ){
      ToastMessage.showToast(
          '',
          context,
          widget: Center(child: LearninkLoadingIndicator(color:Color(0xff004fe0))),
          backgroundColor: Colors.white70,duration: 20);
      Database database=Provider.of<Database>(context,listen:false);
      //  First create the cart items then set the cart
      List<Subject> _newItems=_userCartData !=null ? _userCartData.items : [];
      _model.selected.forEach((s){
        _newItems.indexWhere((i)=>i.documentId==s.documentId) == -1 ?
        _newItems.add(s)
            :
        null;
      });
      await database.setCart(Cart (
        total: _newItems.length,
        items: _newItems,
      ));
      if(mounted){
        ToastMessage.showToast(
          "${_model.selected.length} ${_model.selected.length>1 ? "items" : "item"} added to cart"
          ,context
          , backgroundColor:Color(0xff8bc34a),);
        _model=_model.copyWith(selected: [],isSelected: false, searchText: []);
        _selectedController.add(_model);
      }
    } else {
      ToastMessage.showToast(
        "No item selected. Please select item(s) to be added to cart"
        , context,
        backgroundColor: Colors.amber,
        duration: 2,
      );
    }

  }

  bool _checkKeywords(List<String> keyWords){
    // print("No of searchText ${_model.searchText}");
    return _model.searchText.length > 0 ?
          keyWords.indexWhere((tag)=>
              _model.searchText.indexWhere((i)=>
                      i.trim()=='' ? false : tag.toLowerCase().startsWith(i.trim().toLowerCase())
                    ) != -1
          ) != -1
          :
          true
    ;

  }

  @override
  Widget build(BuildContext context) {
//    print("searchbar stream ${_model.selected.length} => ${_model.selected}");
    final Database database = Provider.of<Database>(context,listen: false);
    _userCart = database.userCartStream().listen((data)=>_userCartData=data);
    widget.filteredSubjects = widget.subjects.where((s) =>_checkKeywords(s.subjectKeyWords)).toList();
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
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop()),
          actions: <Widget>[
            NotificationIconButton(
              size:50,
              icon:MyFlutterIcons.shopping_cart,
              color:Colors.white,
              ),
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
                List<Subject> _selectedList=[];
                if(snapshot.hasData){
                  print('snapshot value ${snapshot.data.selected.length}');
                  _selectedList=List.from(snapshot.data.selected);
                }

                if(snapshot.hasError){
                  _selectedList=[];
                }
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: _model.searchText.length > 0 && widget.filteredSubjects.length > 0 ? 95.0 : 50.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding:EdgeInsets.all(0),
                            child: SearchListItemBar(
                              onClick:_onSelectAll,
                              isSelected: snapshot.data.isSelected,
                              onSearch: _onSearch,
                              showSearch: true,
                              showSelectAll: _model.searchText.length > 0 && widget.filteredSubjects.length > 0 ? true: false,
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
                          Subject _subject = widget.filteredSubjects[index];
                          return Padding(
                            padding:EdgeInsets.all(0),
                            child: SubjectPageListItem(subject:_subject,
                              isFirst: index==0,
                              isLast: index == widget.filteredSubjects.length -1,
                              onSelectItem:()=>_onSelectItem(_subject),
                              isSelected: _selectedList.indexWhere((s)=>s.documentId==_subject.documentId)!=-1,
                               database:widget.database,
                          ),);
                        },
                        childCount: widget.filteredSubjects.length,
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
                            onPressed: ()=> _onAddtoBag(context),
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
