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
          SliverList (
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                       padding:EdgeInsets.all(40),
                        child:
//                        Text("With the code above, you can see that you are creating your children with delegate. There are basically two ways to create the list elements. You can either specify the whole list in the delegate by using SliverChildListDelegateor you can load them dynamically by using SliverChildBuilderDelegate",
//                        style: TextStyle(color: Colors.black),)
                        questionPresenter
                    ),
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
          SliverList (
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.only(top: index==0 ? 20: 0),
                  child: Option(
                  child:
//                  Text("With the code above, you can see that you are creating your children with delegate. There are basically two ways to create the list elements. You can either specify the whole list in the delegate by using SliverChildListDelegateor you can load them dynamically by using SliverChildBuilderDelegate",
//                  style: TextStyle(color: Colors.black),),
                          TeXView(renderingEngine:TeXViewRenderingEngine.katex(),
                            child:TeXViewDocument(question.presentedOptions[index],
                              style: TeXViewStyle(
                                margin: TeXViewMargin.all(10),
                                ),),),
                isSelected: index==selectedOption,
                selectOption: ()=>selectOption(index),
                isFirst: index==0,
                isLast: index==question.presentedOptions.length-1,
                )
//                  ListView.separated(
//                     shrinkWrap: true,
//                      itemBuilder: (BuildContext context,int index){
//                       print(question.presentedOptions[index]);
//                        return Option(
//                          child: Text("With the code above, you can see that you are creating your children with delegate. There are basically two ways to create the list elements. You can either specify the whole list in the delegate by using SliverChildListDelegateor you can load them dynamically by using SliverChildBuilderDelegate",
//                            style: TextStyle(color: Colors.black),),
////                          TeXView(renderingEngine:TeXViewRenderingEngine.katex(),
////                            child:TeXViewDocument(question.presentedOptions[index],
////                              style: TeXViewStyle(
////                                margin: TeXViewMargin.all(10),
////                                ),),),
//                          isSelected: index==selectedOption,
//                          selectOption: ()=>selectOption(index),
//                        );
//                      },
//                      separatorBuilder: (BuildContext context,int index)=>Divider(thickness:0.5,color:Colors.black),
//                      itemCount: question.presentedOptions.length),
                );
              },
              childCount:question.presentedOptions.length
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
