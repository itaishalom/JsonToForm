import 'package:json_to_form_with_theme/parsers/widget_parser.dart';

import '../json_to_form_with_theme.dart';

abstract class WidgetParserFactory {
  WidgetParser? getWidgetParser(
      String type,
      int index,
      Map<String, dynamic> widgetJson,
      bool isBeforeHeader,
      OnValueChanged? onValueChanged);
}