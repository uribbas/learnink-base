
import 'package:flutter/material.dart';

class DurationWidget extends StatefulWidget {

  DurationWidget({this.duration,this.onDurationChange, this.durationKey}) ;

  final int duration;
  final ValueChanged<int> onDurationChange;
  final GlobalKey<FormFieldState> durationKey;

  @override
  _DurationWidgetState createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<DurationWidget> {
  int _duration;
  TextEditingController _durationController=TextEditingController();
  @override
  initState(){
    super.initState();
    _duration=widget.duration;
    _durationController.value=TextEditingValue(
      text:'$_duration',
      selection: TextSelection.collapsed(offset: '$_duration'.length),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _durationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10),
      child: Container(
        alignment: Alignment.center,
        color:Colors.black45,
        child: Container(
         width:MediaQuery.of(context).size.width -50,
          child: Card(
              shadowColor: Colors.black87,
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modify Duration',style: TextStyle(color:Colors.black, fontSize:18.0 ),),
                    //Divider(color: Colors.black45,),
                    Padding(
                      padding: const EdgeInsets.only(top:20),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration(minutes)',
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(left:20),
                            width:150,
                            child: TextFormField(
                                controller: _durationController,
                                key: widget.durationKey,
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
                                  double duration=double.tryParse(value)??0;
                                  _duration=duration.round();
                                 } ,
                                validator: (value){
                                 }
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(children: [
                      Spacer(),
                      FlatButton(
                          child:Text('Modify',style:TextStyle(color:Colors.blue,fontSize: 16.0),),
                        onPressed:()=>widget.onDurationChange(_duration),
                      ),
                    ],)
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
