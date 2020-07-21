class Chapter{

  Chapter({
    this.gradeId,
    this.subjectId,
    this.chapterId,
    this.chapterTitle,
    this.chapterImageUrl,
    this.chapterKeyWords,
    this.chapterPopularityRating,
    this.documentId,
  });

  final String gradeId;
  final String subjectId;
  final String chapterId;
  final String chapterTitle;
  final String chapterImageUrl;
  final List<String> chapterKeyWords;
  final double chapterPopularityRating;
  final String documentId;

  factory Chapter.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String gradeId = data['gradeId'];
    print("Inside chapter fromMap,gradeId:${gradeId}");
    final String subjectId=data['subjectId'];
    print("Inside chapter fromMap,gradeId:${subjectId}");
    final String chapterId=data['chapterId'];
    print("Inside chapter fromMap,gradeId:${chapterId}");
    final String chapterTitle=data['chapterTitle'];
    print("Inside chapter fromMap,gradeId:${chapterTitle}");
    final String chapterImageUrl=data['chapterImageUrl'];
    print("Inside chapter fromMap,gradeId:${chapterImageUrl}");
    final List<String> chapterKeyWords= List.from(data['chapterKeyWords']??[]);
    print("Inside chapter fromMap,gradeId:${chapterKeyWords}");
    final double chapterPopularityRating=data['chapterPopularityRating']?.toDouble();

    print('Inside fromMap ${subjectId},${data['subjectId']}');

    return Chapter(
      gradeId:gradeId,
      subjectId:subjectId,
      chapterId:chapterId,
      chapterTitle:chapterTitle,
      chapterImageUrl:chapterImageUrl,
      chapterKeyWords:chapterKeyWords,
      chapterPopularityRating:chapterPopularityRating,
      documentId:documentId,
    );

  }

  Map<String, dynamic> toMap() {
    return {
      'gradeId': gradeId,
      'subjectId': subjectId,
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'chapterImageUrl': chapterImageUrl,
      'chapterKeyWords': List.from(chapterKeyWords),
      'chapterPopularityRating':chapterPopularityRating,
    };
  }

}