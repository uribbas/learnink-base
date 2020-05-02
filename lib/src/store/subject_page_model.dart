class SubjectPageModel{
  SubjectPageModel({this.selected,this.isSelected});
  List<String> selected;
  bool isSelected;

  SubjectPageModel copyWith({List<String> selected, bool isSelected}){
    return SubjectPageModel(
      selected: selected?? this.selected,
      isSelected:isSelected?? this.isSelected,
    );
  }
}
