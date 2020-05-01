
class GradePageModel{
  GradePageModel({this.selected,this.isSelected});
  List<int> selected;
  bool isSelected;

  GradePageModel copyWith({List<int> selected, bool isSelected}){
    return GradePageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
    );
  }
}
