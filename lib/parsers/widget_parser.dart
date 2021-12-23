import 'package:flutter/widgets.dart';


abstract class WidgetParser {
  Widget getWidget();
  late String id;
  late int index;
  late dynamic chosenValue;
  Map<String, dynamic> toJson();
  int? time;

  setChosenValue(dynamic value);
}
