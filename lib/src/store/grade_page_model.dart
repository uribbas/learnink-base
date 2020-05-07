
class GradePageModel{
  GradePageModel({this.selected,this.isSelected, this.isBeingAddedToBag});
  List<String> selected;
  bool isSelected;
  bool isBeingAddedToBag;

  GradePageModel copyWith({List<String> selected, bool isSelected, bool isBeingAddedToBag}){
    return GradePageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
      isBeingAddedToBag: isBeingAddedToBag?? this.isBeingAddedToBag,
    );
  }
}
