class QuestionDistribution{
  String chapterId;
  String gradeId;
  String subjectId;
  int difficult;
  int easy;
  int moderate;
  int standard;
  int match;
  String documentId;

  QuestionDistribution({
    this.gradeId,
    this.subjectId,
    this.chapterId,
    this.easy,
    this.moderate,
    this.difficult,
    this.standard,
    this.match,
    this.documentId
  });

  factory QuestionDistribution.fromMap(Map<String,dynamic> data,String documentId){
    if(data==null){
      return null;
    }
    final gradeId=data['gradeId'];
    final subjectId=data['subjectId'];
    final chapterId=data['chapterId'];
    final int easy=data['easy'];
    final int moderate=data['moderate'];
    final int difficult=data['difficult'];
    final int standard=data['standard'];
    final int match=data['match'];

    return QuestionDistribution(
      gradeId: gradeId,
      subjectId: subjectId,
      chapterId: chapterId,
      easy: easy,
      moderate: moderate,
      difficult: difficult,
      standard: standard,
      match: match,
      documentId: documentId
    );
  }

}