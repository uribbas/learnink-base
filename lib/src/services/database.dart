import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/chapter.dart';
import '../models/job.dart';
import '../models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<CollectionReference> getCollectionRef(String path);
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> addUser(LearninkUserInfo userinfo);
  Future<void> setUser(LearninkUserInfo userinfo, String documentId);
  Stream<List<LearninkUserInfo>> usersStream();
  Stream<List<LearninkUserInfo>> selectedUsersStream(CollectionReference ref);
  Future<List<LearninkUserInfo>> selectedUsersRefList(Query query);
  Stream<List<Grade>> gradesStream();
  Stream<List<Subject>> subjectsStream();
  Stream<List<Subject>> selectedSubjectsRefStream(Query query);
  Stream<List<Chapter>> chaptersStream();
  Stream<List<Chapter>> selectedChaptersRefStream(Query query);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<CollectionReference> getCollectionRef(String path) async => await _service.getCollectionRef(path: path);

  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data,documentId) => Job.fromMap(data,documentId),
      );

  //subject related methods
  Stream<List<Subject>> subjectsStream() => _service.collectionStream(
    path: APIPath.subjects(),
    builder: (data,documentId) => Subject.fromMap(data,documentId),
  );

  Stream<List<Subject>> selectedSubjectsRefStream(Query query) => _service.queryStream(
    query: query,
    builder: (data,documentId) => Subject.fromMap(data,documentId),
  );


  // grades related methods

  Stream<List<Grade>> gradesStream() => _service.collectionStream(
    path: APIPath.grades(),
    builder: (data,documentId) => Grade.fromMap(data,documentId),
  );

  //chapters related methods
  Stream<List<Chapter>> chaptersStream() => _service.collectionStream(
    path: APIPath.chapters(),
    builder: (data,documentId) => Chapter.fromMap(data,documentId),
  );


  Stream<List<Chapter>> selectedChaptersRefStream(Query query) => _service.queryStream(
    query: query,
    builder: (data,documentId) => Chapter.fromMap(data,documentId),
  );

  //  User management related methods

  Future<void> addUser(LearninkUserInfo userinfo) async => await _service.addData(
    path: APIPath.users(),
    data: userinfo.toMap(),
  );

  Future<void> setUser(LearninkUserInfo userinfo, String documentId) async => await _service.setData(
    path: APIPath.user(documentId),
    data: userinfo.toMap(),
  );

  Stream<List<LearninkUserInfo>> usersStream() => _service.collectionStream(
    path: APIPath.users(),
    builder: (data,documentId) => LearninkUserInfo.fromMap(data,documentId),
  );

  Stream<List<LearninkUserInfo>> selectedUsersStream(CollectionReference ref) => _service.collectionRefStream(
    ref: ref,
    builder: (data,documentId) => LearninkUserInfo.fromMap(data,documentId),
  );

  Future<List<LearninkUserInfo>> selectedUsersRefList(Query query) async => await _service.collectionRefList(
    query: query,
    builder: (data,documentId) => LearninkUserInfo.fromMap(data,documentId),
  );
}
