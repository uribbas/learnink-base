import 'subject.dart';

class Cart{
  Cart({this.total, this.uid, this.items,this.documentId});
  final int total;
  final String uid;
  final List<Subject> items;
  final String documentId;

  factory Cart.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int total = data['total'];
    final String uid = data['uid'];
    List<Subject> _items = [];
    List.from(data['items']).forEach((s)=>_items.add(Subject.fromMap(s,s['documentId'])));
    final List<Subject> items = List.from(_items);

    return Cart(
        total: total,
        uid: uid,
        items: items,
        documentId:documentId,
     );

  }

  Cart copyWith({
    int total,
    String uid,
    List<Subject> items,
    String documentId}){
    return Cart(
        total:total??this.total,
        uid:uid??this.uid,
        items: items??this.items,
        documentId: documentId??this.documentId
    );
  }

  Map<String, dynamic> toMap() {
    // First convert the List<Subject> to List<Map> of subjects
    List<Map> _items = [];
    items.forEach((s) {
      Map _newSubject = s.toMap();
      _newSubject["documentId"] = s.documentId;
      _items.add(_newSubject);
    });
    return {
      'total': total,
      'uid': uid,
      'items': List.from(_items),
      };
  }

}