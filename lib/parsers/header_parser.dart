import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/header.dart';
import '../json_to_form_with_theme.dart';
import 'item_model.dart';

class HeaderModel extends ItemModel {
  String name;

  HeaderModel.fromJson(Map<String, dynamic> json, String type,
      bool isBeforeHeader)
      :  name = json['name'], super(
      json['id'], type, isBeforeHeader);
}
class HeaderParserCreator extends ParserCreator<HeaderModel>{
  @override
  String get type => "header";

  @override
  HeaderModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>
      HeaderModel.fromJson(json, type, isBeforeHeader);

  @override
  Widget createWidget(HeaderModel model, OnValueChanged? onValueChanged,
          DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder) =>
      Header(
        name: model.name,
        id: model.id,
      );
}
