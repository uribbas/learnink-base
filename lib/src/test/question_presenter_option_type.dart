import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:learnink/src/models/to_be_presented_question.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/fluttex_view.dart';
import 'option.dart';

class QuestionPresenterOptionType extends StatelessWidget {
  QuestionPresenterOptionType(
      {this.question,
      this.selectedOption,
      this.selectOption,
      this.skip,
      this.onRenderingComplete,
      this.notifyBuildStart});

  final int selectedOption;
  final ValueChanged<int> selectOption;
  final PresentedStandardQuestion question;
  final VoidCallback skip;
  final VoidCallback onRenderingComplete;
  final VoidCallback notifyBuildStart;

  int childRenderedCount = 0;

  void notifyChildRender() {
    childRenderedCount++;
    if (childRenderedCount == question.presentedOptions.length + 1) {
      onRenderingComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Inside build QuestionPresenterOptionType");
    Widget questionPresenter=FluttexView(texString:question.question['text']);
//    Widget questionPresenter = FluttexView(
//        texString: "What is the formula of water? Is it \\(H_2O\\)?");
//    print("Inside build QuestionPresenterOptionType");
    List<Widget> options = [];

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
                      padding: EdgeInsets.all(40), child: questionPresenter),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(),
                      OutlineButton(
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                        shape: RoundedRectangleBorder(
                          //side: BorderSide(width:1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        onPressed: skip,
                      ),
                    ],
                  )
                ],
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
              child: Option(
                child: FluttexView(texString: question.presentedOptions[index]),
                // child:FluttexView(texString:"\\(<img src=\"https://i.picsum.photos/id/1/200/300.jpg?hmac=jH5bDkLr6Tgy3oAg5khKCHeunZMHq0ehBZr6vGifPLY\"",),
                isSelected: index == selectedOption,
                selectOption: () => selectOption(index),
                isFirst: index == 0,
                isLast: index == question.presentedOptions.length - 1,
              ),
            );
          }, childCount: question.presentedOptions.length),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CustomOutlineButton(
                child: Text(
                  'Save & Next',
                  style: TextStyle(color: Colors.black),
                ),
                borderColor: Colors.black,
                elevationColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ),
        )
      ],
    );
  }
}
