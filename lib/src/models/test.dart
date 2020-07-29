import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionPresented{
  String questionId;
  String subtype;
  List<String> presentedOptions;
  List<String> registeredAnswers;

  QuestionPresented({
    this.questionId,
    this.subtype,
    this.presentedOptions,
    this.registeredAnswers
  });

  factory QuestionPresented.fromMap(Map<String,dynamic>data){

    if(data==null){
      return null;
    }

    final String questionId=data['questionId'];
    final String subtype=data['subtype'];
    final List<String> presentedOptions=List.from(data['presentedOptions']??[]);
    final List<String> registeredAnswers=List.from(data['registeredAnswers']??[]);

    return QuestionPresented(
      questionId: questionId,
      subtype: subtype,
      presentedOptions: presentedOptions,
      registeredAnswers: registeredAnswers
    );
  }
}


class Test{
  String uid;
  String subjectId;
  String gradeId;
  String testTitle;
  bool isAdaptive;
  bool isTimed;
  String status;
  Map<String,int> chaptersCovered;
  String testImageUrl;
  DateTime testDate;
  Map<String,int> categoryWeights;
  int totalQuestions;
  double totalMarks;
  int allottedTime;
  int elapsedTime;
  Map<String,List<String>> questionSelected;
  List<QuestionPresented> questionPresented;
  String documentId;

  Test({
    this.uid,
    this.subjectId,
    this.gradeId,
    this.testTitle,
    this.isAdaptive,
    this.isTimed,
    this.status,
    this.chaptersCovered,
    this.testImageUrl,
    this.testDate,
    this.categoryWeights,
    this.totalQuestions,
    this.totalMarks,
    this.allottedTime,
    this.elapsedTime,
    this.questionSelected,
    this.questionPresented,
    this.documentId

});

  factory Test.fromMap(Map<String,dynamic> data,String documentId){
    if(data==null){
      return null;
    }
    final String uid=data['uid'];
    final String subjectId=data['subjectId'];
    final String gradeId=data['gradeId'];
    final String testTitle=data['testTitle'];
    final bool isAdaptive=data['isAdaptive'];
    final bool isTimed=data['isTimed'];
    final String status=data['status'];
    final Map<String,int> chaptersCovered=Map.from(data['chaptersCovered']);
    final String testImageUrl=data['testImageUrl'];
    final DateTime testDate=(data['testDate'] as Timestamp).toDate();
    final Map<String,int> categoryWeights=Map.from(data['categoryWeights']);
    final int totalQuestions=data['totalQuestions'];
    final double totalMarks=data['totalMarks']?.toDouble();
    final int allottedTime=data['allottedTime'];
    final int elapsedTime=data['elapsedTime'];
    final Map<String,List<String>> questionSelected=Map.from(data['questionSelected']);
    List<QuestionPresented> questionPresented=[];
    for(Map<String,dynamic>q in data['questionPresented']){
      questionPresented.add(QuestionPresented.fromMap(q));
    }

    return Test(
      uid: uid,
      subjectId: subjectId,
      gradeId: gradeId,
      testTitle: testTitle,
      isAdaptive: isAdaptive,
      isTimed: isTimed,
      status: status,
      chaptersCovered: chaptersCovered,
      testImageUrl: testImageUrl,
      testDate: testDate,
      categoryWeights: categoryWeights,
      totalQuestions: totalQuestions,
      totalMarks: totalMarks,
      allottedTime: allottedTime,
      elapsedTime: elapsedTime,
      questionSelected: questionSelected,
      questionPresented: questionPresented,
      documentId:documentId

    );
  }

  toMap(){
    return{
      'uid':uid,
      'subjectId':subjectId,
      'gradeId':gradeId,
      'testTitle':testTitle,
      'isAdaptive':isAdaptive,
      'isTimed':isTimed,
      'status':status,
      'chaptersCovered':chaptersCovered,
      'testImageUrl':testImageUrl,
      'testDate':testDate,
      'categoryWeights':categoryWeights,
      'totalQuestions':totalQuestions,
      'totalMarks':totalMarks,
      'allottedTime':allottedTime,
      'elapsedTime':elapsedTime,
      'questionSelected':questionSelected,
      'questionPresented':questionPresented
    };
  }

}