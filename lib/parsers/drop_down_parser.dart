import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';
import 'package:stream_live_data/stream_live_data.dart';


class DropDownParserModel extends ItemModel{
  MutableLiveData<dynamic> chosenValue;
  final String? description;
  final String name;
  final List<String> values;
  MutableLiveData<int?> time;

  @override
  void updateValue(value, {bool withTime = true}) {
    chosenValue.add(value);
    if(withTime){
      updateTime();
    }
  }

  @override
  void dispose(){
    chosenValue.dispose();
    time.dispose();
  }
  void updateTime(){
    time.add(DateTime.now().millisecondsSinceEpoch);
  }

  DropDownParserModel.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        time = MutableLiveData(initValue: json['time']),
        values = json['values'].cast<String>(),
        chosenValue = MutableLiveData(initValue: json['chosen_value']), super(json['id'], type, isBeforeHeader);

}

class DropDownParserCreator extends ParserCreator<DropDownParserModel>{
  @override
  String get type => "drop_down";

  @override
  Widget createWidget(DropDownParserModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? saveBarBuilderMethod) => DropDownWidget(
      key: ValueKey(model.id),
      model: model,
      dateBuilder: dateBuilder,
      onValueChanged: onValueChanged);

  @override
  DropDownParserModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>DropDownParserModel.fromJson(json, type, isBeforeHeader);
}
