class Subject{

  Subject({
    this.gradeId,
    this.price,
    this.subjectDescription,
    this.subjectId,
    this.subjectImageUrl,
    this.subjectKeyWords,
    this.subjectName,
    this.subjectPopularityRating,
    this.validityPeriod,
    this.documentId,
  });

  final String gradeId;
  final Map<String,double> price;
  final String subjectDescription;
  final String subjectId;
  final String subjectImageUrl;
  final List<String> subjectKeyWords;
  final String subjectName;
  final double subjectPopularityRating;
  final int validityPeriod;
  final String documentId;

  factory Subject.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String gradeId = data['gradeId'];
    final Map<String,double> price=Map.from(data['price']);
    final String subjectDescription=data['subjectDescription'];
    final String subjectId=data['subjectId'];
    final String subjectImageUrl=data['subjectImageUrl'];
    final List<String> subjectKeyWords=List.from(data['subjectKeyWords']);
    final String subjectName=data['subjectName'];
    final double subjectPopularityRating=data['subjectPopularityRating'] as double;
    final int validityPeriod=data['validityPeriod'] as int;

    print('Inside fromMap ${subjectDescription},${data['subjectDescription']}');

    return Subject(
      gradeId:gradeId,
      price:price,
      subjectDescription:subjectDescription,
      subjectId:subjectId,
      subjectImageUrl:subjectImageUrl,
      subjectKeyWords:subjectKeyWords,
      subjectName:subjectName,
      subjectPopularityRating:subjectPopularityRating,
      validityPeriod:validityPeriod,
      documentId:documentId,
    );

  }

  Map<String, dynamic> toMap() {
    return {
      'gradeId': gradeId,
      'price': Map.from(price),
      'subjectDescription': subjectDescription,
      'subjectId': subjectId,
      'subjectImageUrl': subjectImageUrl,
      'subjectKeyWords': List.from(subjectKeyWords),
      'subjectName': subjectName,
      'subjectPopularityRating':subjectPopularityRating,
      'validityPeriod':validityPeriod,
    };
  }

}