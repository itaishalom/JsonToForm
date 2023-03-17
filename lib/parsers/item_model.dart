const String emptyItemModelType = "empty";

abstract class ItemModel{
  final String id;
  final String type;
  final bool isBeforeHeader;

  ItemModel(this.id, this.type, this.isBeforeHeader);
  void updateValue(dynamic value) {}

  void dispose() {}
}
class EmptyItemModel extends ItemModel{
  EmptyItemModel() : super(emptyItemModelType, "empty", false);

  @override
  void updateValue(value) {
  }
}
