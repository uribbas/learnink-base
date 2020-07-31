import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:learnink/src/create_test/duration_widget.dart';
import 'package:learnink/src/models/chapter.dart';
import 'package:learnink/src/models/question.dart';
import 'package:learnink/src/models/question_distribution.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/models/subscription.dart';
import 'package:learnink/src/models/test.dart';
import 'package:learnink/src/services/auth.dart';
import 'package:learnink/src/services/toast_message.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'package:learnink/src/widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
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
  List<Subscription> _activeSubscriptions;
  String _title;
  GlobalKey<FormFieldState> _titleKey=GlobalKey<FormFieldState>();
  String _grade;
  List<String> _gradeList;
  Map<String,List<String>>_gradeSubject={};
  GlobalKey<FormFieldState> _gradeKey=GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _subjectKey = GlobalKey<FormFieldState>();
  String _subject;
  List<String> _subjectList;
  List<Chapter> _addedChapters = [];
  List<int> _addedChapterWeights=[];
  bool _chapterError=false;
  List<Chapter> _chapters=[];//['Integers','Fraction','Numbers','Decimal'];
  Map<String,int> _difficultyWeightage={"easy":34,"moderate":33,"difficult":33,};
  int _numberOfQuestions=15;
  GlobalKey<FormFieldState> _noQKey=GlobalKey<FormFieldState>();
  bool _isAdaptive=false;
  bool _isTimed=true;
  int _duration=0;
  User _user;
  GlobalKey<FormFieldState> _durationKey=GlobalKey<FormFieldState>();
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
    print(_activeSubscriptions);
  }

  Future<void> _fetchCurrentUser(BuildContext context) async{
    _user=await Provider.of<AuthBase>(context,listen: false).currentUser();
    }

  Future<void> _fetchSubscriptions() async{
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ToastMessage.showToast('', context,
          widget:LearninkLoadingIndicator(color:Colors.blue),duration: 20);
      _fetchCurrentUser(context);
    });

    _activeSubscriptions=await widget.database.activeSubscriptionList();
    _gradeList=[];
    for(Subscription sub in _activeSubscriptions){
      if(!_gradeList.contains(sub.gradeId)){
        _gradeList.add(sub.gradeId);
        _gradeSubject[sub.gradeId]=[];
        _gradeSubject[sub.gradeId].add(sub.subjectId);
      }else{
        _gradeSubject[sub.gradeId].add(sub.subjectId);
      }
    }
    if(_gradeList.length ==1){
      _grade=_gradeList[0];
      _subjectList=_gradeSubject[_grade];
      if(_subjectList.length==1) {
        _subject = _subjectList[0];
        _chapters=await widget.database.selectedGradeSubjectChapters(_grade, _subject);
      }
      else{
        _subject=null;
      }
    }
    setState(() {
      ToastMessage.dismissToast();
    });

  }

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
                          gradeList: _gradeList,
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
                          subjectList:_subjectList,
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

  Future<void> _onGradeChange(String grade) async {
    String oldGrade=_grade;
    if(oldGrade!=grade) {
      _grade = grade;
      _subjectList = _gradeSubject[grade];
      _subject = _subjectList.length == 1 ? _subjectList[0] : null;
      await _resetChapters();

      setState(() {});
    }
  }
  void _onWeightageChange(Map<String,int> weightage) {
    _overlayEntry?.remove();
//    String key = weightage.keys.toList()[0];
//    int value = weightage[key];
//
//    void adjust(bool isDifferencePositive, String key) {
//      if (isDifferencePositive) {
//        _difficultyWeightage[key] += 1;
//      } else {
//        _difficultyWeightage[key] -= 1;
//      }
//    }
//
//    _difficultyWeightage[key] = value;
//    int sum = _difficultyWeightage.values.toList().reduce((a, b) => a + b);
//    if (sum != 100) {
//      int difference = 100 - sum;
//      int differenceAbs=difference.abs();
//      List<String> wKeys=_difficultyWeightage.keys.toList();
//      for (int i = 0; i < differenceAbs; i++) {
//        String wKey=wKeys[i % wKeys.length];
//        if(key!=wKey){
//          adjust(difference>0,wKey);
//        }else{
//          differenceAbs++;
//        }
//      }
//    }
   _difficultyWeightage=weightage;
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
                onPressed: _onSaveTest,),
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
            ChapterWeightDisplay(
              chapters: _addedChapters,
              chapterWeights: _addedChapterWeights,
              onModifyWeights:_onModifyChapterWeights,
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
        builder: (BuildContext context) => DifficultyDisplay(
          difficultyWeightage: _difficultyWeightage,
          onWeightageChange: _onWeightageChange,
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
            ChapterDisplayWidget(
              chapters: _chapters,
              selectedChapters: _addedChapters,
              onAddChapters: _onAddChapters,
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
    }else{
      _overlayState = Overlay.of(context);
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

  void _onAddChapters(List<Chapter> chapters){
   setState(() {
     _addedChapters=chapters;
     _overlayEntry?.remove();
     _calculateEqualWeights();
   });
  }
   void _onTitleChange(String title){
    _title=title;
    }

  Future<void> _onSubjectChange(String subject) async{
    String oldSubject=_subject;
    if(oldSubject!=subject) {
      _subject = subject;
      await _resetChapters();
      setState(() {});
    }
  }

  Future<void> _resetChapters() async{
    ToastMessage.showToast('', context,
        widget:LearninkLoadingIndicator(color:Colors.blue),duration: 20);

    _chapters=await widget.database.selectedGradeSubjectChapters(_grade, _subject);
    _addedChapters=[];
    ToastMessage.dismissToast();
  }

  bool _validateCreateTest(){
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

  }

  Map<String,int> _calculateChapterWiseQ(){
    Map<String,int> chaptersCovered=Map<String,int>();
    int sum=0;
    for(int i=0;i<_addedChapters.length;i++){
      chaptersCovered[_addedChapters[i].chapterId]=
      (_numberOfQuestions*_addedChapterWeights[i]*0.01).floor();
      sum+=chaptersCovered[_addedChapters[i].chapterId];
    }
    int diff=_numberOfQuestions-sum;

    var sortedEntries = chaptersCovered.entries.toList()
      ..sort((e1, e2) {
      var diff = e1.value.compareTo(e2.value);
      if (diff == 0) diff = e1.key.compareTo(e2.key);
      return diff;
    });
    Map<String,int> newMap=Map.fromEntries(sortedEntries);
    for(int i=0;i<diff;i++){
     newMap[sortedEntries[i%sortedEntries.length].key]=
         sortedEntries[i%sortedEntries.length].value+1;
    }

    return newMap;
  }

  Future<String> _findTestImageUrl() async{
    if(_addedChapters.length==1){
      return _addedChapters[0].chapterImageUrl;
    }
    List<Subject> subjects=await widget.database.subjectById(_grade, _subject);
    return subjects[0].subjectImageUrl;
  }

  Future<Map<String,List<String>>> _findQuestionsSelected(Map<String,int> chapterWiseQ) async {
    Map<String, List<int>> chapterBreakup = Map<String, List<int>>();
    if (!_isAdaptive) {
      for (String chap in chapterWiseQ.keys.toList()) {
        List<int> chapBreakList = [];
        chapBreakList.add(
            (chapterWiseQ[chap] * _difficultyWeightage['easy']*.01).floor());
        chapBreakList.add(
            (chapterWiseQ[chap] * _difficultyWeightage['moderate']*.01).floor());
        chapBreakList.add(
            (chapterWiseQ[chap] * _difficultyWeightage['difficult']*.01).floor());
        int sum = chapBreakList.reduce((a, b) => a + b);
        int diff = chapterWiseQ[chap] - sum;
        for (int i = 0; i < diff; i++) {
          chapBreakList[i % chapBreakList.length] += 1;
        }
        chapterBreakup[chap] = chapBreakList;
      }
    } else {
      for (String chap in chapterWiseQ.keys.toList()) {
        List<int> chapBreakList = [
          chapterWiseQ[chap],
          chapterWiseQ[chap],
          chapterWiseQ[chap]
        ];
        chapterBreakup[chap] = chapBreakList;
      }
    }
    print('_findQuestionsSelected:After chapterBreakup:$chapterBreakup');
      Map<String,Map<String,List<String>>> chapterQuestions=Map<String,Map<String,List<String>>>();
      for (String chap in chapterBreakup.keys.toList()) {
        QuestionDistribution qDist = (await widget.database
            .questionDistributionList(
            _grade, _subject, chap))[0];
        print('_finsQuestionsSelecetd:questionDistribution:${qDist.easy},${qDist.moderate},${qDist.difficult}');
        int ms=DateTime.now().microsecondsSinceEpoch+1;
        Random rand = Random(ms);
        //generate easy indices
        int easyCount = chapterBreakup[chap][0];
        List<int> easyIndices = [];
        for (int i = 0; i < easyCount; i++) {
          int randIndex = rand.nextInt(qDist.easy);
          if (easyIndices.contains(randIndex)) {
            easyCount++;
          } else {
            easyIndices.add(randIndex);
          }
        }
        print('_findQuestionsSelected,easyIndices:$easyIndices');

        //genarate moderate indices
        //ms=DateTime.now().microsecondsSinceEpoch+2;
        //rand = Random(ms);
        int moderateCount = chapterBreakup[chap][1];
        List<int> moderateIndices = [];
        for (int i = 0; i < moderateCount; i++) {
          int randIndex = rand.nextInt(qDist.moderate);
          if (moderateIndices.contains(randIndex)) {
            moderateCount++;
          } else {
            moderateIndices.add(randIndex);
          }
        }
        print('_findQuestionsSelected,moderateIndices:$moderateIndices');
          //genarate difficult indices
        //ms=DateTime.now().microsecondsSinceEpoch+3;
        //rand = Random(ms);
        int difficultCount = chapterBreakup[chap][2];
        List<int> difficultIndices = [];
        for (int i = 0; i < difficultCount; i++) {
          int randIndex = rand.nextInt(qDist.difficult);
          if (difficultIndices.contains(randIndex)) {
            difficultCount++;
          } else {
            difficultIndices.add(randIndex);
          }
        }
        print('_findQuestionsSelected,difficultIndices:$difficultIndices');

        chapterQuestions[chap]=Map<String,List<String>>();
        chapterQuestions[chap]['easy']=easyIndices.map((int e)=>'${_grade}_${_subject}_${chap}_easy_${e}').toList();
        chapterQuestions[chap]['moderate']=moderateIndices.map((int e)=>'${_grade}_${_subject}_${chap}_moderate_${e}').toList();
        chapterQuestions[chap]['difficult']=difficultIndices.map((int e)=>'${_grade}_${_subject}_${chap}_difficult_${e}').toList();
      }

      print('_findQuestionsSelected,after chapterQuestions:$chapterQuestions');

      Map<String,List<String>> selectedQuestions=Map<String,List<String>>();
      selectedQuestions['easy']=[];
      selectedQuestions['moderate']=[];
      selectedQuestions['difficult']=[];
      for(String chap in chapterQuestions.keys.toList()){
        selectedQuestions['easy'].addAll(chapterQuestions[chap]['easy']);
        selectedQuestions['moderate'].addAll(chapterQuestions[chap]['moderate']);
        selectedQuestions['difficult'].addAll(chapterQuestions[chap]['difficult']);
      }

      return selectedQuestions;
  }

  void _resetForm(){
    _grade=null;
    _subject=null;
    _title=null;
    _chapters=[];
    _addedChapters=[];
    _chapterError=false;
     _difficultyWeightage={"easy":34,"moderate":33,"difficult":33,};
    _numberOfQuestions=15;
    _isAdaptive=false;
    _isTimed=true;
    _duration=0;
    setState(() {});
  }



  void _onSaveTest() async{
    ToastMessage.showToast('', context,
        widget:LearninkLoadingIndicator(color:Colors.blue),duration: 20);
    bool isValid=_validateCreateTest();
    String testId;
    if(isValid){
       String testImageUrl=await _findTestImageUrl();
       print('_onSaveTest,testImageUrl:${testImageUrl}');
       Map<String,int> chapterWiseQ=_calculateChapterWiseQ();
       print('_onSaveTest,chapterwiseQ:$chapterWiseQ');
       Map<String,List<String>> questionSelected=await _findQuestionsSelected(chapterWiseQ);
       print('_onSaveTest,questionSelected:$questionSelected');
       Test test=Test(
        uid:_user?.uid,
        subjectId: _subject,
        gradeId: _grade,
        testTitle: _title,
        isAdaptive: _isAdaptive,
        isTimed: _isTimed,
        status:'new',
        chaptersCovered: chapterWiseQ,
        testImageUrl: testImageUrl,
        testDate: null,
        categoryWeights: _difficultyWeightage,
        totalQuestions: _numberOfQuestions,
         totalMarks: null,
         allottedTime: _duration,
         elapsedTime:null,
         questionSelected:questionSelected,
         questionPresented: null
       );
       testId=await widget.database.createTest(test);
       _resetForm();
    }
   ToastMessage.dismissToast();
  }

}
