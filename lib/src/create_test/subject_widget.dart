import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class SubjectWidget extends StatefulWidget {
  SubjectWidget({this.subjectList,this.selectedSubject, this.subjectKey, this.onSubjectChange});
  String selectedSubject;
  List<String> subjectList;
  final GlobalKey<FormFieldState> subjectKey;
  final ValueChanged<String> onSubjectChange;

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  FocusNode _focus=FocusNode();
  bool _focused=false;
  bool _isValid=true;

  void _touchEventListener() {
    print("Inside touch");
    if (_focus.hasFocus && !_focused) {
      print("_touchEventListener called");
      setState(() {
        _focused = true;
        print("_isValid:$_isValid,selectedGrade:${widget.selectedSubject}");
        _isValid=widget.selectedSubject==null?false:true;
        print('$_isValid');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_touchEventListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Subject',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 200.0,
                //height: _isValid?60:75,
                child: DropdownButtonFormField<String>(
                    autovalidate: _focused,
                    focusNode: _focus,
                  key: widget.subjectKey,
                  value: widget.selectedSubject,
                    icon: Icon(MyFlutterIcons.angle_down,size:30,color: _isValid?Colors.blue:Colors.red,),
                    iconEnabledColor: Colors.blue,
                    iconDisabledColor: Colors.grey,
                  //iconDisabledColor: Colors.black,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  items:
                  widget.subjectList!=null? widget.subjectList.map((String item) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: item,
                    );
                  }).toList():[],
                  selectedItemBuilder: (BuildContext context) {
                    return widget.subjectList!=null? widget.subjectList
                        .map<Widget>((String item) {
                      return Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList():[];
                  },
                    onTap: (){widget.subjectKey.currentState.validate();},
                  onSaved: (value) =>{},
                  onChanged:(value){
                    widget.selectedSubject=value;
                    widget.onSubjectChange(value);
                    _focus.unfocus();
                    FocusScope.of(context).requestFocus(_focus);
                  } ,
                  validator: (String value){
                    if(value!=null && value.isNotEmpty){
                      print("Inside validator:value!=null");
                      _isValid=true;
                      return null;
                    }
                    _isValid=false;
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });

                    return 'Subject can\'t be empty';
                  }
                 ),
              ),
              Spacer(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
