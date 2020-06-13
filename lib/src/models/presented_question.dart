import 'question.dart';

abstract class PresentedQuestion{
  String type;
}

class PresentedStandardQuestion extends PresentedQuestion {
  @override
  String type;
  String subjectId;
  String chapterId;
  String difficulty;
  String gradeId;
  int timeToSolve;
  Map<String, dynamic> stats;
  Map<String, String> question;
  int allotedMarks;
  Map<String, String> answer;
  Map<String,Map<String, String>> assistance;
  String documentId;
  List<String> presentedOptions;
  List<String> givenAnswers;

  PresentedStandardQuestion({
    this.subjectId,
    this.chapterId,
    this.difficulty,
    this.gradeId,
    this.type,
    this.timeToSolve,
    this.stats,
    this.question,
    this.allotedMarks,
    this.answer,
    this.assistance,
    this.documentId,
    this.presentedOptions,
    this.givenAnswers
  });

  factory PresentedStandardQuestion.fromQuestion({Question question,String type}){
    if (question.type == 'STANDARD') {
      return PresentedStandardQuestion(
        subjectId: (question as StandardQuestion).subjectId,
        chapterId: (question as StandardQuestion).chapterId,
        difficulty: (question as StandardQuestion).difficulty,
        gradeId: (question as StandardQuestion).gradeId,
        type: type,
        timeToSolve: (question as StandardQuestion).timeToSolve,
        stats: (question as StandardQuestion).stats,
        question: (question as StandardQuestion).question,
        allotedMarks: (question as StandardQuestion).allotedMarks,
        answer: (question as StandardQuestion).answer,
        assistance: (question as StandardQuestion).assistance,
        documentId: (question as StandardQuestion).documentId,
        presentedOptions: [],
        givenAnswers: []
      );
    }
    return null;
  }
}