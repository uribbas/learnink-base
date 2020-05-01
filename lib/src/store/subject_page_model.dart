class SubjectPageModel{
  SubjectPageModel({this.selected,this.isSelected});
  List<int> selected;
  bool isSelected;

  SubjectPageModel copyWith({List<int> selected, bool isSelected}){
    return SubjectPageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
    );
  }
}
