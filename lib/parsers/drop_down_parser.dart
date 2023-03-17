import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';
import 'package:stream_live_data/live_data.dart';

import '../json_to_form_with_theme.dart';

class DropDownModel extends ItemModel{
  final String? description;
  final String name;
  final List<String> values;
  StreamController<dynamic> chosenValue;
  late Stream<dynamic> chosenValueStream ;

  MutableLiveData<int?> time;


  @override
  void updateValue(value, {bool withTime = true})async {
    chosenValue.add(value);
    if(withTime) {
      time.add(DateTime
          .now()
          .millisecondsSinceEpoch);
    }
  }

  void updateTime(){
    time.add(DateTime.now().millisecondsSinceEpoch);
  }

  DropDownModel.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        time =  MutableLiveData(initValue:json['time'], notifyOnChangeOnly: true),
        values = json['values'].cast<String>(),
        chosenValue = StreamController(), super(json['id'], type, isBeforeHeader){
    chosenValue.add(json['chosen_value']);
    chosenValueStream = chosenValue.stream;
  }

  @override
  void dispose() {
    time.dispose();
    chosenValue.close();
  }
}

class DropDownParserCreator extends ParserCreator<DropDownModel> {
  @override
  String get type => "drop_down";

  @override
  DropDownModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) {
    return DropDownModel.fromJson(json, type, isBeforeHeader);
  }

  @override
  Widget createWidget(DropDownModel model, OnValueChanged? onValueChanged,
      DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder) {

    return DropDownWidget(
        key: ValueKey(model.id),
        model: model,
        dateBuilder: dateBuilder,
        onValueChanged: onValueChanged);
  }

}
