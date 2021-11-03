import 'package:flutter/widgets.dart';

abstract class WidgetParser{
  Widget getWidget();
  Map<String, dynamic> toJson();
}