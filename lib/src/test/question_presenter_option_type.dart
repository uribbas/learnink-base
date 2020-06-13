import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:learnink/src/models/presented_question.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'option.dart';

class QuestionPresenterOptionType extends StatelessWidget {

QuestionPresenterOptionType({this.question,this.selectedOption, this.selectOption,this.skip});

  final int selectedOption;
  final ValueChanged<int> selectOption;
  final PresentedStandardQuestion question;
  final VoidCallback skip;

  @override
  Widget build(BuildContext context) {
    Widget questionPresenter=TeXView(renderingEngine:TeXViewRenderingEngine.katex(),
      child:TeXViewDocument(question.question['text'],));
    List<Widget> options=[];

    // Widget questionPresenter=Text('This is a question',style:TextStyle(color:Colors.black),);
    return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                       padding:EdgeInsets.all(40),
                        child: questionPresenter),
                    Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(),
                       OutlineButton(
                        child:Text('Skip',style:TextStyle(color:Colors.red,fontSize: 18.0),),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                        shape: RoundedRectangleBorder(
                          //side: BorderSide(width:1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        onPressed: skip,),
                    ],)
                  ],
                );
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.only(top:40),
                  child: ListView.separated(
                     shrinkWrap: true,
                      itemBuilder: (BuildContext context,int index){
                       print(question.presentedOptions[index]);
                        return Option(
                          child:TeXView(renderingEngine:TeXViewRenderingEngine.katex(),
                            child:TeXViewDocument(question.presentedOptions[index],
                              style: TeXViewStyle(
                                margin: TeXViewMargin.all(10),
                                ),),),
                          isSelected: index==selectedOption,
                          selectOption: ()=>selectOption(index),
                        );
                      },
                      separatorBuilder: (BuildContext context,int index)=>Divider(thickness:0.5,color:Colors.black),
                      itemCount: question.presentedOptions.length),
                );
              },
              childCount:1
              ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top:10.0),
                child:
                CustomOutlineButton(
                      child: Text('Save & Next',
                        style:TextStyle(color:Colors.black),
                      ),
                      borderColor: Colors.black,
                      elevationColor: Colors.black,
                      onPressed: (){},
                    ),

                ),

            ),

          )
        ],
    );

  }
}
