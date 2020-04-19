import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:learnink/src/dashboard/dashboard_landing.dart';
import 'package:meta/meta.dart';

class LearninkUserInfo {
  LearninkUserInfo({
    @required this.uid,
    this.name,
    this.gender,
    this.email,
    this.phoneNumber,
    this.subscriberId,
    this.userCreationTimeStamp,
    this.documentId,
  });

  final String uid;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String subscriberId;
  final Timestamp userCreationTimeStamp;
  final String documentId;

  factory LearninkUserInfo.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String gender = data['gender'];
    final String uid = data['uid'];
    final String email = data['email'];
    final String phoneNumber = data['phoneNumber'];
    final String subscriberId = data['subscriberId'];
    final Timestamp userCreationTimeStamp =
        data['userCreationTimeStamp'] == null
            ? DateTime.now()
            : data['userCreationTimeStamp'];

    return LearninkUserInfo(
        uid: uid,
        name: name,
        gender: gender,
        email: email,
        phoneNumber: phoneNumber,
        userCreationTimeStamp: userCreationTimeStamp,
        subscriberId: subscriberId,
        documentId: documentId);
  }

  LearninkUserInfo copyWith({String uid,
  String name,  String gender,
  String email,
  String phoneNumber,
  String subscriberId,
  Timestamp userCreationTimeStamp,
  String documentId}){
    return LearninkUserInfo(
        uid:uid??this.uid,
        name:name??this.name,
        gender: gender??this.gender,
        email:email??this.email,
        phoneNumber: phoneNumber??this.phoneNumber,
        subscriberId: subscriberId??this.subscriberId,
        userCreationTimeStamp: userCreationTimeStamp??this.userCreationTimeStamp,
        documentId: documentId??this.documentId
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'subscriberId': subscriberId,
      'userCreationTimeStamp': userCreationTimeStamp == null
          ? DateTime.now()
          : userCreationTimeStamp,
    };
  }
}
