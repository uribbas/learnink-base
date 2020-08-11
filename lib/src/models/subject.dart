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
    print('Inside fromMap,data $data');
    if (data == null) {
      return null;
    }
    print('Inside fromMap');
    print("Inside fromMap ${data['gradeId']},${data['price']},${data['subjectDescription']}"
        +",${data['subjectId']},${data['subjectImageUrl']},${data['subjectKeyWords']}"
        +"'${data['subjectName']},${data['subjectPopularityRating']},${data['validityPeriod']}");

    final String gradeId = data['gradeId'];
    print('Inside fromMap,gradeId ${gradeId}');
    Map<String,double> price=data['price']!=null?Map<String,double>():null;
    if(data['price']!=null) {
      for (MapEntry entry in data['price'].entries) {
        print("Mapentry:${entry.key}:${entry.value}");
        price[entry.key] = entry.value.toDouble();
      }
    }
    print('Inside fromMa,price ${price}');
    final String subjectDescription=data['subjectDescription'];
    print('Inside fromMa,subjectDescription ${subjectDescription}');
    final String subjectId=data['subjectId'];
    print('Inside fromMa,subjectId ${subjectId}');
    final String subjectImageUrl=data['subjectImageUrl'];
    print('Inside fromMa,subjectImageUrl ${subjectImageUrl}');
    List<String> subjectKeyWords;
    print("List from subjectKeyWords 1:${data['subjectKeyWords']} ${data['subjectKeyWords']!=null} ${data['subjectKeyWords']}");
    if(data['subjectKeyWords']!=null ) {
      print("List from subjectKeyWords 2:${data['subjectKeyWords']}");
      subjectKeyWords = List<String>.from(data['subjectKeyWords']);
    }
    print('Inside fromMa,subjectKeywords ${subjectKeyWords}');
    final String subjectName=data['subjectName'];
    print('Inside fromMa,subjectName ${subjectName}');
    final double subjectPopularityRating=data['subjectPopularityRating']?.toDouble();
    print('Inside fromMa,subjectPopularityRating ${subjectPopularityRating}');
    final int validityPeriod=data['validityPeriod']?.toInt();
    print('Inside fromMa,validityPeriod ${validityPeriod}');
    print('Inside fromMap ${gradeId},$price,$subjectDescription,$subjectId,$subjectImageUrl'
    +'$subjectKeyWords,$subjectName,$subjectPopularityRating,$validityPeriod');

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
      'subjectKeyWords': List.from(subjectKeyWords??[]),
      'subjectName': subjectName,
      'subjectPopularityRating':subjectPopularityRating,
      'validityPeriod':validityPeriod,
    };
  }

}