import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learnink/src/models/presented_question.dart';
import 'package:learnink/src/models/question.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'question_presenter_option_type.dart';

class TestManager extends StatefulWidget {
  TestManager({this.database});
  final Database database;
  @override
  _TestManagerState createState() => _TestManagerState();
}

class _TestManagerState extends State<TestManager> {

  int selectedOption;
  int sequenceNumber=0;
  int lastAccessedNumber=0;
  List<PresentedQuestion> presentedQuestions=[];
  Database get database=>widget.database;

  void selectOption(int index)
  {
    setState(() {
      selectedOption=(selectedOption??-1)==index?null:index;
    });
  }

  @override
  void initState(){
    formPresentableQuestions();
  }

  Future<void> formPresentableQuestions() async {
    List<Question> questions=await database.questionList();

    //temporary code for generating multiple questions
    for(int i=1;i<10;i++){
      questions.add(questions[0]);
    }

    Random random=Random(748);

    for(Question q in questions){
      //final bool randomBool=random.nextBool();
      final bool randomBool=true;
      final String type=randomBool?'OPTIONS':'BLANKS';
      if(q.type=='STANDARD'){
        PresentedStandardQuestion presentedQuestion=PresentedStandardQuestion.fromQuestion(
            question:q, type:type);
        if(type=='OPTIONS'){
         List<String> options=presentedQuestion.answer.values.toList();
         options.shuffle();
         presentedQuestion.presentedOptions.addAll(options);
        }
        else if(type=='BLANKS') {}
        presentedQuestions.add(presentedQuestion);
      }
    }
    setState(() {});
  }

  void skip()
  {
    if(sequenceNumber < presentedQuestions.length-1){
      setState(() {
        sequenceNumber++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   Widget presenter=LearninkLoadingIndicator(color: Colors.blue,);
    if(presentedQuestions.isNotEmpty && presentedQuestions[sequenceNumber].type=='OPTIONS'){
      presenter=QuestionPresenterOptionType(
        selectOption: selectOption,
        selectedOption: selectedOption,
        question:(presentedQuestions[sequenceNumber] as PresentedStandardQuestion),
        skip:skip
      );
      lastAccessedNumber=sequenceNumber;
    }
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
            title: Text('${sequenceNumber+1} of ${presentedQuestions.length}'),
            leading: lastAccessedNumber>0? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                  sequenceNumber--;
                  });
                },)
                :Container(),

            actions: [
              lastAccessedNumber <presentedQuestions.length -1? IconButton(
                icon:Icon(Icons.arrow_forward_ios,
                  color:Colors.white,),
              onPressed: (){
                setState(() {
                  sequenceNumber++;
                });
              },
              ) :Container()
              ,

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
            child: presenter,
          ),
        ),
      ],
      );

  }
}