import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberOfQuestionWidget extends StatefulWidget {
NumberOfQuestionWidget({this.noOfQuestions, this.onNumberChange,this.noQKey});

  int noOfQuestions;
  final ValueChanged<int> onNumberChange;
  final GlobalKey<FormFieldState>noQKey;

  @override
  _NumberOfQuestionWidgetState createState() => _NumberOfQuestionWidgetState();
}

class _NumberOfQuestionWidgetState extends State<NumberOfQuestionWidget> {
  TextEditingController _numberController=TextEditingController();
  FocusNode _focus=FocusNode();
  bool _focused=false;
  bool _isValid=true;

  void _touchEventListener() {
    print("Inside touch");
    if (_focus.hasFocus && !_focused) {
      print("_touchEventListener called");
      setState(() {
        _focused = true;
        //print("_isValid:$_isValid,selectedGrade:${widget.selectedSubject}");
        _isValid=widget.noOfQuestions==0?false:true;
        print('$_isValid');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_touchEventListener);
    _numberController.addListener(() {
      double noOfQ=double.tryParse(_numberController.text)??0;
      widget.noOfQuestions=noOfQ.round();
      widget.onNumberChange(noOfQ.round());
    });
    _numberController.value=TextEditingValue(
      text: '${widget.noOfQuestions}',
      selection: TextSelection.fromPosition(
        TextPosition(offset: '${widget.noOfQuestions}'.length),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10),
      child: Card(
          shadowColor: Colors.black87,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Questions',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20),
                      width:150,
                      child: TextFormField(
                        controller: _numberController,
                        autovalidate: _focused,
                        focusNode: _focus,
                        key: widget.noQKey,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                           disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                             borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),

                            focusedErrorBorder:OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                             ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                        autocorrect: false,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                          //onTap: (){widget.noQKey.currentState.validate();},
                          onSaved: (value) =>{},
                          onChanged:(value){
                            widget.noOfQuestions=double.tryParse(value)?.round()??0;
                            widget.onNumberChange(widget.noOfQuestions);
                            _focus.unfocus();
                            FocusScope.of(context).requestFocus(_focus);
                          } ,
                          validator: (String value){
                             int noOfQ=double.tryParse(value)?.round()??0;
                            if(noOfQ!=0){
                              print("Inside validator:value!=null");
                              _isValid=true;
                              return null;
                            }
//                            setState(() {
//                              _isValid=false;
//                            });
                            _isValid=false;
                            return 'Value can\'t be zero';
                          }
                      ),
                    )
                  ],
                ),
                ],
            ),
          )),
    );
  }
}
