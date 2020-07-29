import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class GradeWidget extends StatefulWidget {
  GradeWidget({this.gradeList,this.selectedGrade,this.onGradeChange,this.gradeKey});
  final ValueChanged<String> onGradeChange;
  String selectedGrade;
  List<String> gradeList;
  final GlobalKey<FormFieldState> gradeKey;

  @override
  _GradeWidgetState createState() => _GradeWidgetState();
}

class _GradeWidgetState extends State<GradeWidget> {
  FocusNode _focus=FocusNode();
  bool _focused=false;
  bool _isValid=true;

  void _touchEventListener() {
    print("Inside touch");
    if (_focus.hasFocus && !_focused) {
      print("_touchEventListener called");
      setState(() {
        _focused = true;
        print("_isValid:$_isValid,selectedGrade:${widget.selectedGrade}");
        _isValid=widget.selectedGrade==null?false:true;
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
          padding: EdgeInsets.only(left:20.0,right:20.0,top:20.0,bottom:20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Grade',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 200.0,
                //height: _isValid?60:75,
                child: DropdownButtonFormField(
                  key: widget.gradeKey,
                  value: widget.selectedGrade,
                  autovalidate: _focused,
                  focusNode: _focus,
                  icon: Icon(MyFlutterIcons.angle_down,size:30,color: _isValid?Colors.blue:Colors.red,),
                  iconEnabledColor: Colors.blue,
                  iconDisabledColor: Colors.grey,
                  //itemHeight: kMinInteractiveDimension,
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
                  items: widget.gradeList!=null? widget.gradeList.map((String item) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: item,
                    );
                  }).toList():[],
                  selectedItemBuilder: (BuildContext context) {
                    return widget.gradeList!=null?widget.gradeList.map<Widget>((String item) {
                      return Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList():[];
                  },
                  onTap: (){widget.gradeKey.currentState.validate();},
                  onSaved: (value){},
                  onChanged:(value){
                    widget.selectedGrade=value;
                    widget.onGradeChange(value);
                    _focus.unfocus();
                    FocusScope.of(context).requestFocus(_focus);
                  },
                    validator: (value){
                    if(value!=null&& value.isNotEmpty){
                      print("Inside validator:value!=null");
                      _isValid=true;
                      return null;
                    }
                    setState(() {
                      _isValid=false;
                    });
                    return 'Grade can\'t be empty';
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
