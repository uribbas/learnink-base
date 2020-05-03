import '../models/subject.dart';
class SubjectPageModel{
  SubjectPageModel({this.selected,this.isSelected, this.searchText});
  List<Subject> selected;
  bool isSelected;
  List<String> searchText;

  SubjectPageModel copyWith({List<Subject> selected, bool isSelected, List<String> searchText}){
    return SubjectPageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
      searchText:searchText?? this.searchText,
    );
  }
}
