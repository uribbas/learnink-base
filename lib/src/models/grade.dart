class Grade{
  Grade({this.gradeId, this.gradeImageUrl,this.documentId});
  final String gradeId;
  final String gradeImageUrl;
  final String documentId;

  factory Grade.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String gradeId = data['gradeId'];
    final String gradeImageUrl = data['gradeImageUrl'];

    return Grade(
        gradeId: gradeId,
        gradeImageUrl: gradeImageUrl,
        documentId:documentId,
     );

  }

  Map<String, dynamic> toMap() {
    return {
      'gradeId': gradeId,
      'gradeImageUrl': gradeImageUrl,
      };
  }

}