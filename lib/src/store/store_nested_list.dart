import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnink/src/services/toast_message.dart';
import '../services/learnink_connection_status_real.dart';
import '../widgets/learnink_empty_content.dart';
import '../widgets/white_page_template.dart';
import '../models/grade.dart';
import '../models/subject.dart';
import '../services/database.dart';
import 'grade_page.dart';
import 'subject_page.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_divider.dart';
import 'grade_list.dart';
import 'subject_list.dart';

class StoreNestedList extends StatefulWidget {
  @override
  _StoreNestedListState createState() => _StoreNestedListState();
}

class _StoreNestedListState extends State<StoreNestedList> {
  StreamSubscription _connection;
  bool _connectionStatus = false;
  bool _previousStatus = false;

  @override
  Widget build(BuildContext context) {
    final learninkConnection = Provider.of<LearninkConnectionStatus>(context);

    _connection = learninkConnection.connectionStatus.listen((status) {
      _previousStatus = _connectionStatus;
      _connectionStatus = status;
      if (_previousStatus != _connectionStatus) {
        setState(() {});
      }
    });

    return _connectionStatus
        ? Column(
            children: <Widget>[
              SizedBox(height: 20),
              CustomDivider(
                leadingText: 'Grades',
                onMore: () => _connectionStatus
                    ? _onGradeView(context)
                    : ToastMessage.showToast(
                        'You are not connected to internet',
                        context,
                        backgroundColor: Colors.red,
                      ),
              ),
              GradeList(),
              SizedBox(height: 20),
              CustomDivider(
                  leadingText: 'Subjects',
                  onMore: () => _connectionStatus
                      ? _onSubjectView(context)
                      : ToastMessage.showToast(
                          'You are not connected to internet',
                          context,
                          backgroundColor: Colors.red,
                        )),
              SubjectList(),
              SizedBox(height: 20),
              CustomDivider(leadingText: 'Featured'),
              _buildList(),
            ],
          )
        : WhitePageTemplate(
            title: '',
            child: LearninkEmptyContent(
              imageUrl: 'assets/icons/evs.png',
              primaryText: 'You are not connected to internet',
              primaryTextColor: Colors.red,
            ));
    ;
  }

  void _onGradeView(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside _onGradeView');
          return StreamBuilder(
            stream: database.gradesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Grade> grades = snapshot.data;
                return GradePage(
                  grades: grades,
                  database: database,
                );
              }
              if (snapshot.hasError) {
                return Container(color: Colors.white);
              }
              return Container(color: Colors.green);
            },
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  void _onSubjectView(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside _onSubjectView');
          return StreamBuilder(
            stream: database.subjectsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Subject> subjects = snapshot.data;
                return SubjectPage(
                  subjects: subjects,
                  database: database,
                );
              }
              if (snapshot.hasError) {
                return Container(color: Colors.white);
              }
              return Container(color: Colors.green);
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
