
class GradePageModel{
  GradePageModel({this.selected,this.isSelected});
  List<String> selected;
  bool isSelected;

  GradePageModel copyWith({List<String> selected, bool isSelected}){
    return GradePageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
    );
  }
}
