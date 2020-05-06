import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
import 'grade_page_list_item.dart';
import 'search_list_item_bar.dart';
import '../models/grade.dart';
import '../models/subject.dart';
import '../models/cart.dart';
import '../widgets/my_flutter_icons.dart';
import 'notification_icon_button.dart';
import '../widgets/custom_outline_button.dart';
import 'grade_page_model.dart';
import '../services/toastMessage.dart';


class GradePage extends StatefulWidget {
  GradePage({ this.grades,this.database});
  final List<Grade> grades;
  final Database database;

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {

  StreamController<GradePageModel> _selectedController=StreamController<GradePageModel>();
  GradePageModel _model=GradePageModel(selected: [],isSelected: false);

  StreamSubscription _userCart;
  Cart _userCartData;

  @override
  void dispose(){
    super.dispose();
    _selectedController.close();
  }

  void _onSelectItem(String documentId){
    List<String> selectedList=_model.selected;
    selectedList.contains(documentId)?selectedList.remove(documentId):selectedList.add(documentId);
    _model=_model.copyWith(selected:selectedList,isSelected: false);
    _selectedController.add(_model);
   }

  void _onSelectAll(bool newValue){
    List<String> selectedList=newValue?List<String>.generate(widget.grades.length, (i) => widget.grades[i].documentId ):[];
    _model=_model.copyWith(selected:selectedList,isSelected:newValue);
    _selectedController.add(_model);
  }


  void _onAddtoBag() async
  {
    // Get the existing userCartstream then add all subjects linked to the grade
    //  First create the cart items then set the cart
    final subjectRef=await widget.database.getCollectionRef('subjects');
    List<Subject> _newItems= _userCartData != null ? _userCartData.items : [];
    // used for loop instead of forEach as we need to use the async function for geting subjects for the selected grade
    for(int i=0; i < widget.grades.length; i++ ){
      Grade _grade = widget.grades[i];
      if(_model.selected.contains(_grade.gradeId)){
        List<Subject> _gradeSubjects = await widget.database.selectedSubjectsRefList(subjectRef.where('gradeId', isEqualTo: _grade.gradeId));
        // print("Processing grade ${_grade.gradeId}  : ${_gradeSubjects}");
        _gradeSubjects.forEach((s){
          _newItems.indexWhere((i)=>i.documentId==s.documentId) == -1 ?
          _newItems.add(s)
              :
          null;
        });
        // print("Processing grade ${_grade.gradeId}  newItems : ${_newItems}");
      }
    }
    // print("New list of items in cart is ${_newItems.length}");

    await widget.database.setCart(Cart (
      total: _newItems.length,
      items: _newItems,
    ));
    ToastMessage.showToast("${_model.selected.length} ${_model.selected.length >1 ? "itemss" : "item"} added to cart", Color(0xff8bc34a),);

    _model=_model.copyWith(selected: [],isSelected: false);
    _selectedController.add(_model);
  }



  @override
  Widget build(BuildContext context) {
    _userCart = widget.database.userCartStream().listen((data)=>_userCartData=data);
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
          title: Text('All Classes'),
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
                   List<String> _selectedList=[];
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
                         itemExtent: 60.0,
                         delegate: SliverChildBuilderDelegate(
                               (BuildContext context, int index) {
                             return Padding(
                               padding:EdgeInsets.all(0),
                               child: SearchListItemBar(
                                 onClick:_onSelectAll,
                                 isSelected: snapshot.data.isSelected,
                                 showSearch: false,
                                 showSelectAll: true,
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
                               child: GradePageListItem(grade:widget.grades[index],
                                 isFirst: index==0,
                                 isLast: index == widget.grades.length -1,
                                 onSelectItem:()=>_onSelectItem(widget.grades[index].documentId),
                                 isSelected:_selectedList.contains(widget.grades[index].documentId),
                               database: widget.database,),
                             );
                           },
                           childCount: widget.grades.length,
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
