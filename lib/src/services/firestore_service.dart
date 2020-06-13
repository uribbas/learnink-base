import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService{
  FirestoreService._();

  static final instance=FirestoreService._();

  Future<CollectionReference> getCollectionRef({String path}) async {
    return Firestore.instance.collection(path);
  }

  Future<void> setData({String path, Map<String,dynamic> data} ) async {
    final documentReference=Firestore.instance.document(path);
    //print('$uid:$data');
    await documentReference.setData(data);
  }

  Future<void> addData({String path, Map<String,dynamic> data} ) async {
    final collectionReference=Firestore.instance.collection(path);
    //print('$uid:$data');
    await collectionReference.add(data);
  }

  Stream<List<T>> collectionStream<T>({@required String path,
    @required T builder(Map<String,dynamic> data,String documentId)}){
    final reference=Firestore.instance.collection(path);
    final snapshots=reference.snapshots();
    return snapshots.map((snapshot)=>
        snapshot.documents.map(
                (snapshot)=> builder(snapshot.data,snapshot.documentID)
        ).toList());

  }

  Stream<T> documentStream<T>({@required String path,@required String docId,
    @required T builder(Map<String,dynamic> data,String documentId)}) {
    final documentReference=Firestore.instance.document(path);
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
    final reference=Firestore.instance.collection(path);;
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