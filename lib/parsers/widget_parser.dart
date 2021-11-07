import 'package:flutter/widgets.dart';

abstract class WidgetParser{
  Widget getWidget();
  late int id;
  late dynamic chosenValue;
  Map<String, dynamic> toJson();
}