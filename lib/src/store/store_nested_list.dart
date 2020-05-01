import 'package:flutter/material.dart';
import '../models/grade.dart';
import '../models/subject.dart';
import '../services/database.dart';
import 'grade_page.dart';
import 'subject_page.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_divider.dart';
import 'grade_list.dart';
import 'subject_list.dart';

class StoreNestedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        CustomDivider(leadingText: 'Grades', onMore: ()=>_onGradeView(context)),
        GradeList(),
        SizedBox(height: 20),
        CustomDivider(leadingText: 'Subjects',onMore:()=>_onSubjectView(context),),
        SubjectList(),
        SizedBox(height: 20),
        CustomDivider(leadingText: 'Featured'),
        _buildList(),
      ],
    );
  }

  void _onGradeView(BuildContext context) {
    final Database database = Provider.of<Database>(context,listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside _onGradeView');
          return StreamBuilder(
            stream: database.gradesStream(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                final List<Grade> grades = snapshot.data;
                return GradePage(grades: grades,database: database,);
              }
              if(snapshot.hasError){
                return Container(color:Colors.white);
              }
              return Container(color:Colors.green);
            },
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  void _onSubjectView(BuildContext context) {
    final Database database = Provider.of<Database>(context,listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside _onGradeView');
          return StreamBuilder(
            stream: database.subjectsStream(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                final List<Subject> subjects = snapshot.data;
                return SubjectPage(subjects: subjects,database: database,);
              }
              if(snapshot.hasError){
                return Container(color:Colors.white);
              }
              return Container(color:Colors.green);
            },
          );
        },
      ),
    );
  }

  Widget _buildList() {
    var colors = [
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.red,
      Colors.orange
    ];
    double height = 136.0;
    return SizedBox(
      height: height,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext content, int index) {
            return _buildItem(
              index: index + 1,
              color: colors[(index) % colors.length],
              parentSize: height,
            );
          }),
    );
  }

  Widget _buildItem({int index, Color color, double parentSize}) {
    double edgeSize = 8.0;
    double itemSize = parentSize - edgeSize * 2.0;
    return Container(
      padding: EdgeInsets.all(edgeSize),
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: Container(
          alignment: AlignmentDirectional.center,
          color: color,
          child: Text(
            '$index',
            style: TextStyle(fontSize: 72.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
