import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService{
  FirestoreService._();

  static final instance=FirestoreService._();
  final _firestore=Firestore.instance;

  Firestore get firestoreInstance=>_firestore;

  Future<CollectionReference> getCollectionRef({String path}) async {
    return _firestore.collection(path);
  }

  Future<void> setData({String path, Map<String,dynamic> data} ) async {
    final documentReference=_firestore.document(path);
    //print('$uid:$data');
    await documentReference.setData(data);
  }

  Future<DocumentReference> addData({String path, Map<String,dynamic> data} ) async {
    final collectionReference=_firestore.collection(path);
    //print('$uid:$data');
   DocumentReference docRef= await collectionReference.add(data);
   return docRef;
  }

  Stream<List<T>> collectionStream<T>({@required String path,
    @required T builder(Map<String,dynamic> data,String documentId)}){
    print("Inside collectionStream,path:$path");
    final reference=_firestore.collection(path);
    final snapshots=reference.snapshots();
    return snapshots.map((snapshot)=>
        snapshot.documents.map(
                (snapshot){
                  print("Inside collectionStream,documentID:${snapshot.documentID}");
                  return builder(snapshot.data,snapshot.documentID);}
        ).toList());

  }

  Stream<T> documentStream<T>({@required String path,@required String docId,
    @required T builder(Map<String,dynamic> data,String documentId)}) {
    final documentReference=_firestore.document(path);
    final snapshots= documentReference.snapshots();
    return snapshots.map((snapshot)=>
        builder(snapshot.data,docId)
        );

  }

  //  Stream data based on reference provide, this will be for the use cases where .where conditions
  //  are applied on the collection as per the data requirement
  Stream<List<T>> collectionRefStream<T>({@required CollectionReference ref,
    @required T builder(Map<String,dynamic> data,String documentId)}){
    final reference=ref;
    final snapshots=reference.snapshots();
    return snapshots.map((snapshot)=>
        snapshot.documents.map(
                (snapshot)=> builder(snapshot.data,snapshot.documentID)
        ).toList());

  }

  Future<List<T>> collectionRefList<T>({@required Query query,
    @required T builder(Map<String,dynamic> data,String documentId)}) async {
    final reference=query;
    final snapshots= await reference.getDocuments();
    return snapshots.documents.map(
                (snapshot)=> builder(snapshot.data,snapshot.documentID)
                ).toList();

  }
  Future<List<T>> documentList<T>({@required path,
    @required T builder(Map<String,dynamic> data,String documentId)}) async {
    final reference=_firestore.collection(path);;
    final snapshots= await reference.getDocuments();
    return snapshots.documents.map(
            (snapshot)=> builder(snapshot.data,snapshot.documentID)
    ).toList();

  }
  //  Stream for the query based data snapshot
  Stream<List<T>> queryStream<T>({@required Query query,
    @required T builder(Map<String,dynamic> data,String documentId)}){
    final reference=query;
    final snapshots=reference.snapshots();
    return snapshots.map((snapshot)=>
        snapshot.documents.map(
                (snapshot)=> builder(snapshot.data,snapshot.documentID)
        ).toList());

  }

}