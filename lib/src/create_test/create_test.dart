import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/create_test/duration_widget.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'package:learnink/src/widgets/platform_alert_dialog.dart';
import 'number_of_question_widget.dart';
import 'test_feature_widget.dart';
import 'chapter_list_widget.dart';
import 'grade_widget.dart';
import 'subject_widget.dart';
import 'title_widget.dart';
import '../services/database.dart';
import 'chapter_display_widget.dart';
import 'chapter_weight_display.dart';
import 'difficulty_display.dart';
import '../widgets/custom_outline_button.dart';
import 'dart:core';

class CreateTest extends StatefulWidget {
  CreateTest({this.database});
  final Database database;
  @override
  _CreateTestState createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  String _title;
  GlobalKey<FormFieldState> _titleKey=GlobalKey<FormFieldState>();
  int _grade;
  GlobalKey<FormFieldState> _gradeKey=GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _subjectKey = GlobalKey<FormFieldState>();
  String _subject;
  List<String> _addedChapters = ['Integers'];
  List<int> _addedChapterWeights=[100];
  bool _chapterError=false;
  List<String> _chapters=[];//['Integers','Fraction','Numbers','Decimal'];
  Map<String,int> _difficultyWeightage={"easy":34,"moderate":33,"difficult":33,};
  int _numberOfQuestions=15;
  GlobalKey<FormFieldState> _noQKey=GlobalKey<FormFieldState>();
  String _numberErrorText;
  bool _isAdaptive=false;
  bool _isTimed=true;
  int _duration=0;
  GlobalKey<FormFieldState> _durationKey=GlobalKey<FormFieldState>();
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
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
            title: Text('Create Test'),
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, width: 2.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            //color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return TitleWidget(
                          title: _title,
                          onTitleChange: _onTitleChange,
                          titleKey:_titleKey,
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GradeWidget(
                          selectedGrade:_grade,
                          gradeKey: _gradeKey,
                          onGradeChange:_onGradeChange,
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return SubjectWidget(
                          selectedSubject:_subject,
                          subjectKey: _subjectKey,
                          onSubjectChange:_onSubjectChange,
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ChapterListWidget(
                          chapters: _chapters,
                          addedChapters: _addedChapters,
                          addChapters:()=>_addChapters(context),
                          removeChapter: _removeChapter,
                          modifyWeights: ()=>_modifyWeights(context),
                          error:  _chapterError,
                        );
                      },
                      childCount: 1,
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return NumberOfQuestionWidget(
                          noOfQuestions: _numberOfQuestions,
                          onNumberChange: _onNumberChange,
                          noQKey:_noQKey,
                        );
                      },
                      childCount: 1,
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return TestFeatureWidget(
                          isAdaptive: _isAdaptive,
                          isTimed: _isTimed,
                          onSelectAdaptive: _onSelectAdaptive,
                          onSelectTimed: _onSelectTimed,
                          onEditDifficulty:() =>_onEditDifficulty(context),
                          onEditTime: ()=>_onEditTime(context),

                          );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _buildButtonRow(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSelectTimed(){
    setState(() {
      _isTimed=!_isTimed;
    });
  }
  void _onSelectAdaptive(){
    setState(() {
    _isAdaptive=!_isAdaptive;
    });
  }
  void _onNumberChange(int questions){
    _numberOfQuestions=questions;
//    if(_numberOfQuestions==0){
//      _numberErrorText='Total questions can\'t be zero';
//      setState(() {});
//    }
  }

  void _onGradeChange(int grade){
    _grade=grade;
    setState(() {});
  }
  void _onWeightageChange(Map<String,int> weightage) {
    _overlayEntry?.remove();
    String key = weightage.keys.toList()[0];
    int value = weightage[key];

    void adjust(bool isDifferencePositive, String key) {
      if (isDifferencePositive) {
        _difficultyWeightage[key] += 1;
      } else {
        _difficultyWeightage[key] -= 1;
      }
    }

    _difficultyWeightage[key] = value;
    int sum = _difficultyWeightage.values.toList().reduce((a, b) => a + b);
    if (sum != 100) {
      int difference = 100 - sum;
      int differenceAbs=difference.abs();
      List<String> wKeys=_difficultyWeightage.keys.toList();
      for (int i = 0; i < differenceAbs; i++) {
        String wKey=wKeys[i % wKeys.length];
        if(key!=wKey){
          adjust(difference>0,wKey);
        }else{
          differenceAbs++;
        }
      }
    }
    setState(() {});
  }

  Widget _buildButtonRow(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top:15.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2 -50,
              child: CustomOutlineButton(
                  child:Text('Start Test',style:
                  TextStyle(color:Colors.black,fontSize: 16),),
              borderColor: Colors.red,
              elevationColor: Colors.red,
              onPressed: _onStartTest,),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width/2 -50,
              child: CustomOutlineButton(
                child:Text('Save Test',style:
                TextStyle(color:Colors.black,fontSize: 16),),
                borderColor:Colors.green,
                elevationColor: Colors.green,
                onPressed: (){},),
            )

        ],),
      ),
    );
  }


  void _calculateEqualWeights(){
    if(_addedChapters.isNotEmpty){
    double equalWeights=100/_addedChapters.length;

    _addedChapterWeights=[];
     for(int i =0;i<_addedChapters.length;i++){
      _addedChapterWeights.add(equalWeights.floor());
      print('calculateEqualWeights:${_addedChapterWeights[i]}');
     }

    int sumOfWeights=_addedChapterWeights.reduce((a,b)=>a+b);
    int remainingWeight= 100 -sumOfWeights;

    for(int i=0; i<remainingWeight;i++ ){
      _addedChapterWeights[i]+=1;
    }
    }
  }

  void _removeChapter(int i) {
    setState(() {
      _addedChapters.removeAt(i);
      _calculateEqualWeights();
    });
  }

  void _modifyWeights(BuildContext context){
    if(_addedChapters.isEmpty){
      PlatformAlertDialog(
        title:'Modify Weights',
        content: 'Please add chapters first to modify their weights.',
        cancelActionText:'OK',
      ).show(context);
    } else {
      //print('_modifyWeights:${_addedChapterWeights.length}');
      _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              alignment: Alignment.center,
              color: Colors.black45,

              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                color: Colors.transparent,
                child: Card(
                  color: Colors.white,
                  elevation: 20.0,
                  child: ChapterWeightDisplay(
                    chapters: _addedChapters,
                    chapterWeights: _addedChapterWeights,
                    onModifyWeights:_onModifyChapterWeights,
                  ),
                ),
              ),
            ),
      );
      _overlayState.insert(_overlayEntry);
    }
  }

  void _onModifyChapterWeights(List<int> weights){
    _overlayEntry.remove();
    _addedChapterWeights=weights;
  }



  void _onEditDifficulty(BuildContext context){
    if(_isAdaptive){
      PlatformAlertDialog(
        title:'Modify Difficulty',
        content: 'Difficulty level of adaptive tests are not modifiable.'
                  +'Unselect adaptive test to change difficulty level.',
        cancelActionText:'OK',
      ).show(context);
   } else {
      _overlayState=Overlay.of(context);
      _overlayEntry=  OverlayEntry(
        builder: (BuildContext context) => Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          color: Colors.black45,

          child: Container(
            width:MediaQuery.of(context).size.width-100,
            color: Colors.transparent,
            child: Card(
              color: Colors.white,
              elevation: 20.0,
              child: DifficultyDisplay(
                difficultyWeightage: _difficultyWeightage,
                onWeightageChange: _onWeightageChange,
              ),
            ),
          ),
        ),
      );
      _overlayState.insert(_overlayEntry);

    }
  }

  void _addChapters(BuildContext context) {
    if(_chapters.isEmpty){
      PlatformAlertDialog(
        title:'Add Chapters',
        content: 'Select chapters after selecting subject and grade.',
           cancelActionText:'OK',
      ).show(context);

    }else {
      _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              alignment: Alignment.center,
              color: Colors.black45,

              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                color: Colors.transparent,
                child: Card(
                  color: Colors.white,
                  elevation: 20.0,
                  child: ChapterDisplayWidget(
                    chapters: _chapters,
                    selectedChapters: _addedChapters,
                    onAddChapters: _onAddChapters,
                  ),
                ),
              ),
            ),
      );
      _overlayState.insert(_overlayEntry);
    }
  }

  void _onDurationChange(int duration){
    _overlayEntry?.remove();
    _duration=duration;
    print("Duration:${_duration}");
  }

  void _onEditTime(BuildContext context){
    if(!_isTimed){
      PlatformAlertDialog(
        title:'Modify Duration',
        content: 'Duration of untimed tests are not modifiable.'
            +'Select timed test to customise duration.'
           +'Otherwise system itself will decide the duration.',
        cancelActionText:'OK',
      ).show(context);
    }else{_overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) =>
          DurationWidget(
            duration: _duration,
            durationKey:_durationKey,
            onDurationChange:_onDurationChange ,
          )
    );
    _overlayState.insert(_overlayEntry);
    }

  }

  void _onAddChapters(List<String> chapters){
   setState(() {
     _addedChapters=chapters;
     _overlayEntry?.remove();
     _calculateEqualWeights();
   });
  }
   void _onTitleChange(String title){
    _title=title;
    }

  void _onSubjectChange(String subject){
    _subject=subject;
    setState(() {});
  }

  bool validateCreateTest(){
    bool _isValid=true;
    _isValid &=_titleKey.currentState.validate();
    _isValid &=_gradeKey.currentState.validate();
    _isValid &=_subjectKey.currentState.validate();
    _isValid &=_noQKey.currentState.validate();

    if(_addedChapters.isEmpty){
      _chapterError=true;
      _isValid=false;
    }
    if(!_isValid) {
      setState(() {});
    }
    return _isValid;
  }

  void _onStartTest(){
    validateCreateTest();
  }

}
