import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnink/src/widgets/learnink_empty_content.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import '../services/database.dart';
import 'subject_page_list_item.dart';
import '../models/grade.dart';
import '../widgets/custom_outline_button.dart';
import '../widgets/learnink_network_image.dart';
import '../models/subject.dart';
import '../models/cart.dart';
import '../widgets/my_flutter_icons.dart';
import 'notification_icon_button.dart';
import 'subject_page_model.dart';
import '../services/toastMessage.dart';

class GradeDetailHeader implements SliverPersistentHeaderDelegate {
  GradeDetailHeader({
    this.grade,
    this.maxExtent,
    this.minExtent,
  });

  final Grade grade;
  final double maxExtent;
  final double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LearninkNetworkImage(grade.gradeImageUrl, height: 200, width: 200),
          SizedBox(height: 5.0),
          Text(
            'Class ${grade.gradeId}',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

class GradeDetail extends StatefulWidget {
  GradeDetail({this.grade, this.subjects,this.database});

  final Grade grade;
  final List<Subject> subjects;
  final Database database;

  @override
  _GradeDetailState createState() => _GradeDetailState();
}

class _GradeDetailState extends State<GradeDetail> {

  StreamController<SubjectPageModel> _selectedController=StreamController<SubjectPageModel>();
  SubjectPageModel _model=SubjectPageModel(selected: [],isSelected: false, searchText: []);

  StreamSubscription _userCart;
  Cart _userCartData;

  @override
  void dispose(){
    super.dispose();
    _selectedController.close;
  }
  void _onSelectItem(Subject subject) {
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

  void _onAddtoBag(BuildContext context)
  async {
    //  First create the cart items then set the cart
    List<Subject> _newItems=_userCartData !=null ? _userCartData.items : [];
    _model.selected.forEach((s){
      _newItems.indexWhere((i)=>i.documentId==s.documentId) == -1 ?
      _newItems.add(s)
          :
      null;
    });
    await widget.database.setCart(Cart (
      total: _newItems.length,
      items: _newItems,
    ));
    ToastMessage.showToast(
      "${_model.selected.length} ${_model.selected.length>1 ? "items" : "item"} added to cart"
      ,context
      , backgroundColor:Color(0xff8bc34a),
    );
    _model=_model.copyWith(selected: [],isSelected: false, searchText: []);
    _selectedController.add(_model);
  }

  @override
  Widget build(BuildContext context) {
    _userCart = widget.database.userCartStream().listen((data)=>_userCartData=data);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
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
            title: Text('Class ${widget.grade.gradeId}'),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop()),
            actions: <Widget>[
              NotificationIconButton(
                size: 50,
                icon: MyFlutterIcons.shopping_cart,
                color: Colors.white,

              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: _selectedController.stream,
            initialData: _model,
            builder: (context, snapshot) {
              List<Subject> _selectedList = [];
              bool _loading=true;
              bool _error= false;
              if (snapshot.hasData) {
                print('snapshot value ${snapshot.data}');
                _selectedList = List.from(snapshot.data.selected);
                _loading=false;
              }

              if (snapshot.hasError) {
                _selectedList = [];
                _error=true;
              }

              return Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                //color: Colors.white,
                child: !_loading
                       ?( !_error
                            ? _buildCustomScrollView( _selectedList )
                            : LearninkEmptyContent(primaryText:'Check your connectivity.',
                                imageUrl: 'assets/icons/evs.png',)
                        )
                       :Center(child:LearninkLoadingIndicator(color:Color(0xff004fe0)),)
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCustomScrollView( List<Subject> selectedList ){
    return widget.subjects.isEmpty
        ?LearninkEmptyContent(primaryText:'This class currently has no subject being offerred.',
          imageUrl: 'assets/icons/evs.png',)
        :CustomScrollView(
         slivers: <Widget>[
          SliverPersistentHeader(
          pinned: false,
          delegate: GradeDetailHeader(
            grade: widget.grade,
            maxExtent: 250.0,
            minExtent: 250.0,
          ),
        ),
         SliverFixedExtentList(
          itemExtent: 120.0,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              Subject _subject = widget.subjects[index];
              return SubjectPageListItem(
                subject: widget.subjects[index],
                isFirst: index == 0,
                isLast: index == widget.subjects.length - 1,
                isSelected: selectedList.indexWhere((s)=>s.documentId==_subject.documentId)!=-1,
                onSelectItem: ()=>_onSelectItem(_subject),
                database: widget.database,
              );
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
              padding: const EdgeInsets.only(top: 10.0),
              child: CustomOutlineButton(
                child: Text(
                  'Add to Bag',
                  style: TextStyle(color: Colors.black),
                ),
                borderColor: Colors.black,
                elevationColor: Colors.black,
                onPressed: ()=>_onAddtoBag(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
}
