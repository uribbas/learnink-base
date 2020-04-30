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
    final String subjectId=data['subjectId'];
    final String chapterId=data['chapterId'];
    final String chapterTitle=data['chapterTitle'];
    final String chapterImageUrl=data['chapterImageUrl'];
    final List<String> chapterKeyWords=List.from(data['chapterKeyWords']);
    final double chapterPopularityRating=data['chapterPopularityRating'] as double;

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