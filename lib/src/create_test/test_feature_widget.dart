import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'package:learnink/src/widgets/platform_alert_dialog.dart';
class TestFeatureWidget extends StatelessWidget {
  const TestFeatureWidget({
    this.isTimed,
    this.isAdaptive,
    this.onSelectTimed,
    this.onSelectAdaptive,
    this.onEditDifficulty ,
    this.onEditTime});

  final bool isTimed;
  final bool isAdaptive;
  final VoidCallback onSelectTimed;
  final VoidCallback onSelectAdaptive;
  final VoidCallback onEditDifficulty;
  final VoidCallback onEditTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Test Feature',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Spacer(),
                  IconButton(icon:Icon(Icons.watch_later,color:!isTimed?Colors.grey:Colors.blue),
                  onPressed: onEditTime,),
                  IconButton(
                    icon: Icon(MyFlutterIcons.settings,color:isAdaptive?Colors.grey:Colors.blue),
                  onPressed: onEditDifficulty,)
                ],
              ),
              Divider(color:Colors.black45),
              Row( children: [
                Text('Adaptive',style:TextStyle(color:Colors.black,fontSize: 16.0),),
                IconButton(
                  icon:Icon(Icons.help_outline,color: Colors.red,),
                  onPressed:()=> _showAdaptiveHelpDialog(context),
                ),
                 Spacer(),
                IconButton(
                  icon:Icon(MyFlutterIcons.tick,color: isAdaptive?Colors.green:Colors.grey,),
                  onPressed: onSelectAdaptive,
                ),
              ],),
          Divider(color:Colors.black45),
          Row( children: [
            Text('Timed',style:TextStyle(color:Colors.black,fontSize: 16.0),),
            Spacer(),
            IconButton(
              icon:Icon(MyFlutterIcons.tick,color: isTimed?Colors.green:Colors.grey,),
              onPressed: onSelectTimed,
            ),
          ],
          ),
    ],
        ),
      ),
    ),
    );
  }

  void _showAdaptiveHelpDialog(BuildContext context) async{
    PlatformAlertDialog(
        title:'What does adaptive mean?',
        content: "Adaptive means the difficulty level of questions will change depending on response."
          +" If the response is right, next question will be more difficult."
          +" If response is wrong,next question will be easier."
          +" You can customize difficulty level of test for non-adaptive test.",
        cancelActionText: 'OK',
    ).show(context);

    }

}
