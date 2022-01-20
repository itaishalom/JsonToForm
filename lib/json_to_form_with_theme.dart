library json_to_form_with_theme;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/header_parser.dart';
import 'package:json_to_form_with_theme/parsers/static_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/toggle_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser_factory.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:sizer/sizer.dart';

typedef OnValueChanged = Future<bool> Function(String id, dynamic value);

class JsonFormWithTheme extends StatefulWidget {
  final Widget Function(int date)? dateBuilder;

  final OnValueChanged? onValueChanged;
  final HashMap<int, WidgetParser> parsers = HashMap();
  final WidgetParserFactory? dynamicFactory;

  final Map<String, dynamic> jsonWidgets;
  final JsonFormTheme theme;
  final Stream<Map<String, dynamic>>? streamUpdates;

  JsonFormWithTheme({
    Key? key,
    required this.jsonWidgets,
    this.onValueChanged,
    this.dynamicFactory,
    this.theme = const DefaultTheme(),
    this.streamUpdates,
    this.dateBuilder,
  }) : super(key: key);

  @override
  _JsonFormWithThemeState createState() => _JsonFormWithThemeState();
}

class _JsonFormWithThemeState extends State<JsonFormWithTheme> {
  HashMap<String, WidgetParser> parsers = HashMap();
  List<Widget> widgetsGlobal = [];
  late final StreamSubscription<Map<String, dynamic>>? _valueChange;
  final StreamController<DataClass> _onDataClassReady =
      StreamController<DataClass>();

  buildWidgetsFromJson() {
    parsers = HashMap();
    widgetsGlobal = [];
    List<dynamic>? widgets = widget.jsonWidgets['widgets'];
    if (widgets == null) {
      throw const ParsingException("No widgets found");
    }
    for (int i = 0; i < widgets.length; i++) {
      var widgetJson = widgets[i];
      String? type = widgetJson["type"];
      if (type == null) {
        throw const ParsingException("No type found on widget");
      }
      bool isBeforeHeader = false;
      if (i < widgets.length - 1) {
        var widgetTemp = widgets[i + 1];
        String? typeTemp = widgetTemp["type"];
        if (typeTemp == null) {
          throw const ParsingException("No type found on widget");
        }
        isBeforeHeader = typeTemp == "header";
      }
      WidgetParser? tempParser;

      switch (type) {
        case "toggle":
          try {
            tempParser = ToggleParser.fromJson(widgetJson,
                widget.onValueChanged, isBeforeHeader, i, widget.dateBuilder);
          } catch (e) {
            throw const ParsingException("Bad toggle format");
          }
          break;
        case "header":
          try {
            tempParser = (HeaderParser.fromJson(widgetJson, i));
          } catch (e) {
            throw const ParsingException("Bad header format");
          }
          break;
        case "static_text":
          try {
            tempParser = (StaticTextParser.fromJson(widgetJson,
                widget.onValueChanged, isBeforeHeader, i, widget.dateBuilder));
          } catch (e) {
            throw const ParsingException("Bad static_text format");
          }
          break;
        case "drop_down":
          try {
            tempParser = (DropDownParser.fromJson(widgetJson,
                widget.onValueChanged, isBeforeHeader, i, widget.dateBuilder));
          } catch (e) {
            throw const ParsingException("Bad drop_down format");
          }
          break;
        case "edit_text":
          try {
            tempParser = (EditTextParser.fromJson(widgetJson,
                widget.onValueChanged, isBeforeHeader, i, widget.dateBuilder));
          } catch (e) {
            throw const ParsingException("Bad edit_text format");
          }
          break;
        default:
          if (widget.dynamicFactory != null) {
            try {
              tempParser = widget.dynamicFactory!.getWidgetParser(
                  type,
                  i,
                  widgetJson,
                  isBeforeHeader,
                  widget.onValueChanged,
                  widget.dateBuilder);
              if (tempParser == null) {
                throw ParsingException("Unknown type $type");
              }
            } catch (e) {
              throw ParsingException("Unknown type $type");
            }
          } else {
            throw ParsingException("Unknown type $type");
          }
          break;
      }

      if (parsers.containsKey(tempParser.id)) {
        throw ParsingException("Duplicate Id ${tempParser.id}");
      }
      parsers[tempParser.id] = tempParser;
      widgetsGlobal.add(tempParser.getWidget(true));
    }
  }

  @override
  void initState() {
    _valueChange = widget.streamUpdates?.listen(_onRemoteValueChanged);
    dataClassStream = _onDataClassReady.stream.asBroadcastStream();
    super.initState();
  }

  late Stream<DataClass> dataClassStream;

  void _onRemoteValueChanged(Map<String, dynamic> values) {
    for (String id in values.keys) {
      if (parsers[id] != null) {
        _onDataClassReady.add(DataClass(id: id, value: values[id]));
      }
    }
  }

  bool ignoreRebuild = false;

  @override
  void dispose() {
    _valueChange?.cancel();
    _onDataClassReady.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ignoreRebuild) {
      buildWidgetsFromJson();
    } else {}
    ignoreRebuild = false;
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return InheritedJsonFormTheme(
            theme: widget.theme,
            child: Scaffold(
                backgroundColor: widget.theme.backgroundColor,
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    TextEditingController().clear();
                  },
                  child: UpdateStreamWidget(
                    dataClassStream: dataClassStream,
                    child: SingleChildScrollView(
                      child: Column(
                        children: widgetsGlobal,
                      ),
                    ),
                  ),
                )));
      },
    );
  }
}

class DataClass {
  String id;
  dynamic value;

  DataClass({required this.id, required this.value});
}

class UpdateStreamWidget extends InheritedWidget {
  const UpdateStreamWidget({
    Key? key,
    required this.dataClassStream,
    required Widget child,
  }) : super(key: key, child: child);

  final Stream<DataClass> dataClassStream;

  static UpdateStreamWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UpdateStreamWidget>();
  }

  @override
  bool updateShouldNotify(covariant UpdateStreamWidget oldWidget) {
    return oldWidget.dataClassStream != dataClassStream;
  }
}
