import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Account extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Account'),
        actions: <Widget>[
          FlatButton(child:Text('SignOut'),
          onPressed:() =>_signOut(context))
        ],),

      body: Center(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  'Account',
                    style:TextStyle(fontSize: 30.0,color:Colors.blue,),
                ),
              ),
            ),
            FlatButton(
                child:Text(
                  'Create Data',
                  style:TextStyle(fontSize: 15.0,color:Colors.redAccent,),
                ),
                onPressed:() =>_createGrades(context)
            ),
          ],
        ),
      )
    );
  }
  Future<void> _signOut(BuildContext context) async{
    final AuthBase auth_p=Provider.of<AuthBase>(context,listen:false);
    await auth_p.signOut();
  }

  // Dummy entries populated for grade
  Future<void> _createGrades(BuildContext context) async{
    for(var g=3; g<=6; g++){
      print('Begining of grades ${g}');
      final documentReference=Firestore.instance.document('grades/${g}');
      var grade = {
        'gradeId': '${g}',
        'name': 'Class ${g}',
        'gradeImageUrl': 'https://picsum.photos/id/${1037+g}/400/400',
        'subjects': [
          {'subjectId': 'Maths', 'subjectImageUrl': 'https://picsum.photos/400/400'},
          {'subjectId': 'Science', 'subjectImageUrl': 'https://picsum.photos/400/400'},
          {'subjectId': 'EVS', 'subjectImageUrl': 'https://picsum.photos/400/400'},
          {'subjectId': 'EngLang', 'subjectImageUrl': 'https://picsum.photos/400/400'},
        ]
      };
      await documentReference.setData(grade);
      await _createChapters(context, g);
      print('End of grades ${g}');
    }
  }

  Future<void> _createChapters(BuildContext context, int gradeId) async{
    print('Processing chapters of grade ${gradeId} ');
    List<String> _subjects = ['Maths','Science','EVS','EngLang'];
    _subjects.forEach((String _s) {
      print('Processing grade ${gradeId} subject ${_s}');
      final subjectReference=Firestore.instance.document('subjects/${gradeId}_${_s}');
      var subject = {
        'gradeId': '${gradeId}',
        'subjectId': '${_s}',
        'subjectName': 'Subject ${_s}',
        'subjectDescription': 'This is the decription of the subjec to have some descriptive text',
        'subjectImageUrl': 'https://picsum.photos/400/400',
        'subjectKeyWords': ['Class${gradeId} ${_s}','${_s}'],
        'subjectPopularityRating': 3.0,
        'price': {'inr': 500.00, 'usd': 10.0},
        'validityPeriod': 365,
      };
      subjectReference.setData(subject);
      for(var c=1; c<=6; c++){
        final chapterReference=Firestore.instance.document('chapters/${gradeId}_${_s}_${c}');
        var chapter = {
          'gradeId': '${gradeId}',
          'subjectId': '${_s}',
          'chapterId': '${c}',
          'chapterTitle': '${_s} Chapter ${c}',
          'chapterImageUrl': 'https://picsum.photos/400/400',
          'chapterKeyWords': ['Class${gradeId}','${_s}','Chapter${c}'],
          'chapterPopularityRating': 4.0,
        };
        chapterReference.setData(chapter);
      }
    });
  }


}
