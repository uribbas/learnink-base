import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  TitleWidget({this.title, this.onTitleChange,this.titleKey});
  String title;
  final ValueChanged<String> onTitleChange;
  final GlobalKey<FormFieldState> titleKey;

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  TextEditingController _titleController=TextEditingController();
  FocusNode _focus=FocusNode();
  bool _focused=false;

  void _touchEventListener() {
    print("Inside touch");
    if (_focus.hasFocus && !_focused) {
      print("_touchEventListener called");
      setState(() {
        _focused = true;
        //print("_isValid:$_isValid,selectedGrade:${widget.selectedSubject}");
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
//    _titleController.addListener(() {
//      widget.titleKey.currentState?.validate();
//    });

    _titleController.value=TextEditingValue(
      text: '${widget.title??''}',
      selection: TextSelection.fromPosition(
        TextPosition(offset: '${widget.title}'.length),
      ),
    );

    return Card(
        shadowColor: Colors.black87,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Title',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              TextFormField(
                autovalidate: _focused,
                focusNode: _focus,
                key:widget.titleKey,
                controller: _titleController,
                //autovalidate: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Test',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    hintText: 'Integers ',
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    errorBorder:UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                autocorrect: false,

                 onTap: (){widget.titleKey.currentState.validate();},
                  onSaved: (value) =>{},
                  onChanged:(value){
                    widget.title=value;
                    widget.onTitleChange(value);
                    _focus.unfocus();
                    FocusScope.of(context).requestFocus(_focus);
                  },
                  validator: (value){
                    if(value!=null && value.isNotEmpty){
                      print("Inside validator:value!=null");
                      return null;
                    }

                    return 'Title can\'t be empty';
                  },
              ),
           ],
          ),
        ),
    );
  }
}
