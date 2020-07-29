import 'package:flutter/material.dart';

class DifficultyDisplay extends StatefulWidget {
  DifficultyDisplay({this.difficultyWeightage, this.onWeightageChange});
  Map<String,int> difficultyWeightage;
  final ValueChanged<Map<String,int>> onWeightageChange;

  @override
  _DifficultyDisplayState createState() => _DifficultyDisplayState();
}

class _DifficultyDisplayState extends State<DifficultyDisplay> {
  List<TextEditingController> _difficultyControllers=[];
  bool _isTouched=false;
  bool _isValid=false;
  String _errorText='';

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.difficultyWeightage.keys.length; i++) {
      String key = widget.difficultyWeightage.keys.toList()[i];
      int value = widget.difficultyWeightage[key];
      _difficultyControllers.add(TextEditingController());
      //_difficultyControllers[i].text='$value';
      _difficultyControllers[i].value = TextEditingValue(
        text: '$value',
        selection: TextSelection.fromPosition(
          TextPosition(offset: '$value'.length),
        ),
      );
      _difficultyControllers[i].addListener(() {
        double difficulty = double.tryParse(_difficultyControllers[i].text) ??
            0;
        widget.difficultyWeightage[key] = difficulty.round();
        if (widget.difficultyWeightage[key] > 100) {
          widget.difficultyWeightage[key] = 100;
        }
        _difficultyControllers[i].value=TextEditingValue(
          text:'${widget.difficultyWeightage[key]}',
          selection: TextSelection.collapsed(offset:'${widget.difficultyWeightage[key]}'.length),);

        setState(() {
          _isValid = true;
          _isTouched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children=[];
    children.add(Text(
      'Difficulty Level',
      style: TextStyle(color: Colors.black, fontSize: 16.0),
    ),
    );

    for(int i=0;i<widget.difficultyWeightage.keys.length;i++){
      String key=widget.difficultyWeightage.keys.toList()[i];
      int value=widget.difficultyWeightage[key];
         children.add(
          Row( children: [
            Text('${key[0].toUpperCase()}${key.substring(1)}',style: TextStyle(color:Colors.black,fontSize: 16.0),),
            Spacer(),
            Container(
              width:80,
              child:Padding(
                padding: const EdgeInsets.only(left:20),
                child: TextField(
                  controller: _difficultyControllers[i],
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder:OutlineInputBorder(
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
                  autocorrect: false,
                  //onTap: ()=>setState((){_isTouched=true;}),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
              ),

            ),
            Text('%',style: TextStyle(color: Colors.black,fontSize: 18.0),),

          ],)
      );

    }

    children.add(
        (_isTouched && !_isValid)?Text(_errorText,
          style:TextStyle(color:Colors.red,fontSize: 12.0) ,):Container()
    );

    children.add(
        Row(children: [
          Spacer(),
          FlatButton(child:Text('Modify',
            style:TextStyle(color:Colors.blue,fontSize: 16.0),
          ),
            onPressed:_onModify,
          ),
        ],)
    );



    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      color: Colors.black45,
      child: Container(
        width:MediaQuery.of(context).size.width-100,
        color: Colors.transparent,
        child: Card(
          color: Colors.white,
          elevation: 20.0,
          child: Padding(
            padding: const EdgeInsets.only(left:20.0,right:20,bottom:30,top:20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder:(BuildContext context,int index){
                   return children[index];
                   },
                separatorBuilder: (BuildContext context,int index){
                  return index<children.length-2?Divider(color: Colors.black45,):Container();
                },
                itemCount: children.length
            ),
          ),
        ),
      ),
    );;
  }

  bool validateWeightage(){
    for(int value in widget.difficultyWeightage.values.toList()){
      if (value >100)
        {
          _errorText='Weightage can\'t be greater than 100';
          return false;
        }else if (value <0)
      {
        _errorText='Weightage can\'t be negative';
        return false;
      }

    }
    int sum =widget.difficultyWeightage.values.reduce((a,b) => a+b);
    if(sum !=100){
      _errorText='Weightage sum must be equal to 100';
      return false;
    }
    return true;
   }

   void _onModify(){
    _isValid=validateWeightage();
    if(!_isValid){
      setState(() {});
    } else {
     widget.onWeightageChange(widget.difficultyWeightage);
    }
   }

   @override
   void dispose(){
    super.dispose();
    for(TextEditingController controller in _difficultyControllers){
      controller.dispose();
    }

   }
}
