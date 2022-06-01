import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import '../json_to_form_with_theme.dart';

abstract class ParserCreator<M extends ItemModel> {
  String get type;

  M parseModel(Map<String, dynamic> json, bool isBeforeHeader);

  Widget createWidget(M model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder);
}

class EmptyCreator extends ParserCreator<EmptyItemModel>{
  @override
  Widget createWidget(EmptyItemModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder) => SizedBox();

  @override
  EmptyItemModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) {
    return EmptyItemModel();
  }

  @override
  String get type => emptyItemModelType;

}