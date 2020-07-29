import 'package:cloud_firestore/cloud_firestore.dart';
class Subscription{
  String uid;
  String gradeId;
  String subjectId;
  Timestamp startDate;
  Timestamp endDate;
  String paymentId;
  Timestamp paymentDateTime;
  String documentId;

  Subscription({
    this.uid,
    this.gradeId,
    this.subjectId,
    this.startDate,
    this.endDate,
    this.paymentId,
    this.paymentDateTime,
    this.documentId,
  });

  factory Subscription.fromMap(Map<String, dynamic> data, String documentId){
    if (data == null) {
      return null;
    }

    final String uid=data['uid'];
    final String gradeId=data['gradeId'];
    final String subjectId=data['subjectId'];
    final Timestamp startDate=data['startDate'];
    final Timestamp endDate=data['endDate'];
    final String paymentId=data['paymentId'];
    final Timestamp paymentDateTime=data['paymentDateTime'];

    return Subscription(
      uid: uid,
      gradeId: gradeId,
      subjectId: subjectId,
      startDate: startDate,
      endDate: endDate,
      paymentId: paymentId,
      paymentDateTime: paymentDateTime,
      documentId: documentId
    );
  }
}