import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnink/src/models/question_distribution.dart';
import 'package:learnink/src/models/test.dart';
import '../models/question.dart';
import '../models/subscription.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/chapter.dart';
import '../models/cart.dart';
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
  Future<List<Subject>> subjectById(String gradeId,String subjectId);
  Stream<List<Subject>> subjectsStream();
  Stream<List<Subject>> selectedSubjectsRefStream(Query query);
  Future<List<Subject>> selectedSubjectsRefList(Query query);
  Stream<List<Chapter>> chaptersStream();
  Stream<List<Chapter>> selectedChaptersRefStream(Query query);
  Future<List<Chapter>> selectedGradeSubjectChapters(String gradeId,String subjectId);
  Stream<Cart> userCartStream();
  Future<void> setCart(Cart cart);
  Future<List<Question>> questionList();
  Future<List<QuestionDistribution>> questionDistributionList(String gradeId,String subjectId,String chapterId);
  Future<String> createTest(Test test);
  Future<List<Subscription>> activeSubscriptionList();
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

 //subscription related methods
  Future<List<Subscription>> activeSubscriptionList() async {
    DateTime currentDate=DateTime.now();
    CollectionReference subsRef=await getCollectionRef(APIPath.subsciptions());
    Query query=subsRef.where('uid',isEqualTo:uid ).where('endDate',isGreaterThanOrEqualTo: currentDate);
    return _service.collectionRefList(query: query,
                 builder: (data,documentId)=>Subscription.fromMap(data, documentId));
  }

  //test related method
  Future<String> createTest(Test test) async {
    DocumentReference docRef=await _service.addData(path:APIPath.tests(),data:test.toMap());
    return docRef.documentID;
  }

  //question related methods

  Future<List<Question>> questionList() async => await _service.documentList(
      path: APIPath.questions(),
      builder: (data,documentId) {
        if (data['type'] == 'STANDARD') {
          return StandardQuestion.fromMap(data, documentId);
        }
        return null;
      }
      );

  Future<List<QuestionDistribution>> questionDistributionList(String gradeId,String subjectId,String chapterId) async{
    Query query=_service.firestoreInstance
        .collection(APIPath.questionDistribution())
        .where('gradeId',isEqualTo: gradeId)
        .where('subjectId',isEqualTo: subjectId)
        .where('chapterId',isEqualTo: chapterId);

    return _service.collectionRefList(query: query,
        builder:(data,documentId)=>QuestionDistribution.fromMap(data,documentId));


  }


  //subject related methods

  Future<List<Subject>> subjectById(String gradeId,String subjectId){
    Query query=_service.firestoreInstance
        .collection(APIPath.subjects())
        .where('gradeId',isEqualTo:gradeId )
        .where('subjectId',isEqualTo:subjectId);

    return _service.collectionRefList(query: query,
        builder:(data,documentId)=>Subject.fromMap(data, documentId));


  }

  Stream<List<Subject>> subjectsStream() {
    print("Inside subjectStream");
    return _service.collectionStream(
    path: APIPath.subjects(),
    builder: (data,documentId) => Subject.fromMap(data,documentId),
  );}

  Stream<List<Subject>> selectedSubjectsRefStream(Query query) => _service.queryStream(
    query: query,
    builder: (data,documentId) => Subject.fromMap(data,documentId),
  );

  Future<List<Subject>> selectedSubjectsRefList(Query query)  async =>  await _service.collectionRefList(
    query: query,
    builder: (data,documentId) => Subject.fromMap(data,documentId),
  );


  // grades related methods

  Stream<List<Grade>> gradesStream() => _service.collectionStream(
    path: APIPath.grades(),
    builder: (data,documentId) => Grade.fromMap(data,documentId),
  );

  //chapters related methods
  Future<List<Chapter>> selectedGradeSubjectChapters(String gradeId,String subjectId) async{
    Query query=_service.firestoreInstance
                 .collection(APIPath.chapters())
                 .where('gradeId',isEqualTo:gradeId )
                 .where('subjectId',isEqualTo:subjectId);

        return _service.collectionRefList(query: query,
            builder:(data,documentId)=>Chapter.fromMap(data, documentId));
  }

  Stream<List<Chapter>> chaptersStream() => _service.collectionStream(
    path: APIPath.chapters(),
    builder: (data,documentId) => Chapter.fromMap(data,documentId),
  );


  Stream<List<Chapter>> selectedChaptersRefStream(Query query) => _service.queryStream(
    query: query,
    builder: (data,documentId) => Chapter.fromMap(data,documentId),
  );

  //carts related methods
  Stream<Cart> userCartStream() => _service.documentStream(
      path: 'carts/' + uid , docId: uid,
      builder: (data,documentId) => Cart.fromMap(data,documentId),);


  Future<void> setCart(Cart cart) async {
    Cart _cart=Cart (
      total: cart.total,
      uid: uid,
      items: cart.items,
      documentId: uid,
    );
    await _service.setData(
      path: APIPath.cart(uid),
      data: _cart.toMap(),
    );
  }
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
