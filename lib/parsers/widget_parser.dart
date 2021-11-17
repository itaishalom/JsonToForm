import 'package:flutter/widgets.dart';

import '../json_to_form_with_theme.dart';

abstract class WidgetParser {
  Widget getWidget();
  late String id;
  late int index;
  late dynamic chosenValue;
  Map<String, dynamic> toJson();
}
