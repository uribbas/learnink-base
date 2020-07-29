import 'package:flutter/material.dart';
import 'package:learnink/src/models/chapter.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';

class ChapterWeightDisplay extends StatefulWidget {
  ChapterWeightDisplay(
      {this.chapters, this.chapterWeights, this.onModifyWeights});

  final List<Chapter> chapters;
  final ValueChanged<List<int>> onModifyWeights;
  List<int> chapterWeights;

  @override
  _ChapterWeightDisplayState createState() => _ChapterWeightDisplayState();
}


class _ChapterWeightDisplayState extends State<ChapterWeightDisplay> {
  List<TextEditingController> _chapterWeightControllers=[];
  bool _isTouched=false;
  bool _isValid=false;
  String _errorText='';

  @override
  void initState(){
    super.initState();

    for(int i=0;i<widget.chapters.length;i++){
      _chapterWeightControllers.add(TextEditingController());
      print('Chapter Weights:${widget.chapterWeights[i]}');
      _chapterWeightControllers[i].text='${widget.chapterWeights[i]}';
      _chapterWeightControllers[i].value=TextEditingValue(
        text:'${widget.chapterWeights[i]}',
        selection: TextSelection.collapsed(
            offset: '${widget.chapterWeights[i]}'.length),
        );

    }

    for(int i=0;i<widget.chapters.length;i++){
      _chapterWeightControllers[i].addListener(() {
        double chapterWeight=double.tryParse(_chapterWeightControllers[i].text)??0;
        print("chapter weight ${chapterWeight}");
        if(chapterWeight> 100.0){
          chapterWeight=100;
          }
        widget.chapterWeights[i]=chapterWeight.round();
        print("chapter weight ${chapterWeight}");
        _chapterWeightControllers[i].value=TextEditingValue(
             text:'${chapterWeight.round()}',
        selection: TextSelection.collapsed(offset:'${chapterWeight.round()}'.length),);
        print("Listener-index ${i},${_chapterWeightControllers[i].text}");
        setState(() {
            _isTouched=true;
        });
      });
    }
  }


  @override
  void dispose(){
    super.dispose();
    for(TextEditingController controller in _chapterWeightControllers){
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
//    if(_isTouched) {
//      for (int i = 0; i < widget.chapters.length; i++) {
//        _chapterWeightControllers[i].text = '${widget.chapterWeights[i]}';
//        _chapterWeightControllers[i].value = TextEditingValue(
//          text: '${widget.chapterWeights[i]}',
//         selection: TextSelection.collapsed(
//             offset: '${widget.chapterWeights[i]}'.length),
//          );
//      }
//    }

    print('Chapter Weight length:${widget.chapterWeights.length}');

    return Container(
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
          child: Padding(
            padding: const EdgeInsets.only(left:20.0,right:20,bottom:30),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder:(BuildContext context,int index){
                  if(index==0){
                    return Text('Modify Chapter Weights',style:TextStyle(color:Colors.black,fontSize: 18.0),);
                  }
                  else if(index < widget.chapters.length+1) {
                    return Row(
                      children: [
                        Text('${widget.chapters[index-1].chapterTitle}',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Spacer(),
                        Container(
                          width:50,
                            child: TextField(
                              controller: _chapterWeightControllers[index-1],
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
//                            labelText: 'Test',
//                            labelStyle: TextStyle(
//                              color: Colors.grey,
//                            ),
                                  //hintText: 'Integers ',
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never),
                              keyboardType: TextInputType.numberWithOptions(decimal: false),
                              autocorrect: false,
                              //onTap: (){_isTouched=true;},
//                        onChanged: (value){
//                          int chapterWeight=double.tryParse(value).round();
//                          chapterWeight=chapterWeight>100?100:chapterWeight;
//                          widget.chapterWeights[index-1]=chapterWeight;
//                          },
                            ),
                        ),
                        Text('%',style: TextStyle(color:Colors.black,fontSize: 18.0),),

                      ],
                    );
                  }else if(index==widget.chapters.length+1) {
                    return (_isTouched && !_isValid)?Text(_errorText,
                      style: TextStyle(color: Colors.red, fontSize: 12.0),):
                    Container();
                  } else{
                    return Row(
                      children:[
                        Spacer(),
                        FlatButton(
                        child:Text('Modify',style: TextStyle(color:Colors.blue,fontSize: 16.0),),
                        onPressed: _onModify
                      ),]
                    );
                  }
                },
                separatorBuilder: (BuildContext context,int index){
                  return index <widget.chapters.length+1?
                      Divider(color: Colors.black45,)
                      :Container();
                },
                itemCount: widget.chapters.length+3
            ),
          ),
        ),
      ),
    );
  }

  bool validateWeightage(){
    print("Inside validateWeightage");
    for(int value in widget.chapterWeights){
      if (value >100)
      {
        _errorText='Weightage can\'t be greater thatn 100';
        return false;
      }else if (value <0)
      {
        _errorText='Weightage can\'t be negative';
        return false;
      }

    }
    int sum =widget.chapterWeights.reduce((a,b) => a+b);
    if(sum !=100){
      _errorText='Weightage sum must be equal to 100';
      return false;
    }
    return true;
  }

  void _onModify(){
    _isValid=validateWeightage();
    print("_isValid:${_isValid}");
    if(!_isValid){
      setState(() {
        print("setState");
      });
    } else {
      widget.onModifyWeights(widget.chapterWeights);
    }
  }
}
