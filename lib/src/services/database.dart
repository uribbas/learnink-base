import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../models/job.dart';
import '../models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<CollectionReference> getCollectionRef(String path);
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> addUser(UserInfo userinfo);
  Future<void> setUser(UserInfo userinfo, String documentId);
  Stream<List<UserInfo>> usersStream();
  Stream<List<UserInfo>> selectedUsersStream(CollectionReference ref);
  Future<List<UserInfo>> selectedUsersRefList(Query query);
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

  //  User management related methods

  Future<void> addUser(UserInfo userinfo) async => await _service.addData(
    path: APIPath.users(),
    data: userinfo.toMap(),
  );

  Future<void> setUser(UserInfo userinfo, String documentId) async => await _service.setData(
    path: APIPath.user(documentId),
    data: userinfo.toMap(),
  );

  Stream<List<UserInfo>> usersStream() => _service.collectionStream(
    path: APIPath.users(),
    builder: (data,documentId) => UserInfo.fromMap(data,documentId),
  );

  Stream<List<UserInfo>> selectedUsersStream(CollectionReference ref) => _service.collectionRefStream(
    ref: ref,
    builder: (data,documentId) => UserInfo.fromMap(data,documentId),
  );

  Future<List<UserInfo>> selectedUsersRefList(Query query) async => await _service.collectionRefList(
    query: query,
    builder: (data,documentId) => UserInfo.fromMap(data,documentId),
  );
}
