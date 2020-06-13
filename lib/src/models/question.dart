abstract class Question{
String type;
}

class StandardQuestion extends Question{
  @override
  final String type;
  final String subjectId;
  final String chapterId;
  final String difficulty;
  final String gradeId;
  final int timeToSolve;
  final Map<String,dynamic> stats;
  final Map<String,String> question;
  final int allotedMarks;
  final Map<String,String> answer;
  final Map<String,Map<String,String>> assistance;
  final String documentId;

  StandardQuestion({
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
});

  factory StandardQuestion.fromMap(Map<String, dynamic> data, String documentId){

    if(data==null){
      return null;
    }

    final String subjectId=data['subjectId'];
    final String chapterId=data['chapterId'];
    final String difficulty=data['difficulty'];
    final String gradeId=data['gradeId'];
    final String type=data['type'];
    final int timeToSolve=data['timeToSolve'];
    final Map<String,dynamic> stats=Map.from(data['stats']);
    final Map<String,String> question=Map.from(data['question']);
    final int allotedMarks=data['allotedMarks'];
    final Map<String,String> answer=Map.from(data['answer']);
    Map<String,Map<String,String>> assistance={};

    for(var assist in data['assistance'].keys){
      final Map<String,String> hint=Map.from(data['assistance'][assist]);
      assistance[assist]=hint;
    }

    return StandardQuestion(
      subjectId:subjectId,
      chapterId:chapterId,
      difficulty:difficulty,
      gradeId:gradeId,
      type:type,
      timeToSolve:timeToSolve,
      stats:stats,
      question:question,
      allotedMarks:allotedMarks,
      answer:answer,
      assistance:assistance,
      documentId:documentId,
    );
  }
}