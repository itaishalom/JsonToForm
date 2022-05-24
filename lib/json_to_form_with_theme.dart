library json_to_form_with_theme;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/header_parser.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/static_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/toggle_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser_factory.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:sizer/sizer.dart';

typedef OnValueChanged = Future<bool> Function(String id, dynamic value);
typedef DateBuilderMethod =  Widget Function(int date, String id);
class JsonFormWithThemeBuilder{
   Map<String, dynamic> jsonWidgets;

   JsonFormTheme _theme = DefaultTheme();
   JsonFormWithThemeBuilder setTheme(JsonFormTheme theme){
     _theme = theme;
     return this;
   }
   DateBuilderMethod? _dateBuilderMethod;
   JsonFormWithThemeBuilder setDateBuilderMethod(DateBuilderMethod dateBuilder){
     _dateBuilderMethod = dateBuilder;
     return this;
   }

   OnValueChanged? _onValueChanged;

   JsonFormWithThemeBuilder setOnValueChanged(OnValueChanged onValueChanged){
     _onValueChanged = onValueChanged;
     return this;
   }

   // WidgetParserFactory? _dynamicFactory;
   // JsonFormWithThemeBuilder setDynamicFactory(WidgetParserFactory dynamicFactory){
   //   _dynamicFactory = dynamicFactory;
   //   return this;
   // }

   Stream<Map<String, dynamic>>? _streamUpdates;
   JsonFormWithThemeBuilder setStreamUpdates(Stream<Map<String, dynamic>>? streamUpdates){
     _streamUpdates = streamUpdates;
     return this;
   }

   JsonFormWithThemeBuilder({required this.jsonWidgets});

   final HashMap<String, ParserCreator> _parsers = HashMap();

   JsonFormWithThemeBuilder registerComponent(ParserCreator parser){
     _parsers[parser.type] =  parser;
     return this;
   }

   _registerComponents(){
     registerComponent(ToggleParserCreator());
     registerComponent(HeaderParserCreator());
     registerComponent(StaticTextParserCreator());
     registerComponent(DropDownParserCreator());
     registerComponent(EditTextParserCreator());
   }

  JsonFormWithTheme build() {
    _registerComponents();
    return JsonFormWithTheme._builder(this);
  }
}
class JsonFormWithTheme extends StatefulWidget {

  JsonFormWithTheme._builder(JsonFormWithThemeBuilder builder):
        jsonWidgets = builder.jsonWidgets,
        onValueChanged=  builder._onValueChanged,
        // dynamicFactory= builder._dynamicFactory,
        theme= builder._theme,
        streamUpdates= builder._streamUpdates,
        dateBuilder= builder._dateBuilderMethod,
        _parsersCreateors = builder._parsers,
        super();

  final DateBuilderMethod? dateBuilder;
  final HashMap<String, ParserCreator> _parsersCreateors;
  final List<Model> items = [];
  final OnValueChanged? onValueChanged;
  // final HashMap<int, WidgetParser> parsers = HashMap();
  // final WidgetParserFactory? dynamicFactory;

  final Map<String, dynamic> jsonWidgets;
  final JsonFormTheme theme;
  final Stream<Map<String, dynamic>>? streamUpdates;

  JsonFormWithTheme._({
    Key? key,
    required this.jsonWidgets,
    this.onValueChanged,
    // this.dynamicFactory,
    this.theme = const DefaultTheme(),
    this.streamUpdates,
    this.dateBuilder,
  }) :_parsersCreateors = HashMap(), super(key: key);

  @override
  _JsonFormWithThemeState createState() => _JsonFormWithThemeState();
}

class _JsonFormWithThemeState extends State<JsonFormWithTheme> {
  // HashMap<String, WidgetParser> parsers = HashMap();
  // List<Widget> widgetsGlobal = [];
  late final StreamSubscription<Map<String, dynamic>>? _valueChange;
  final StreamController<DataClass> _onDataClassReady =
      StreamController<DataClass>();


  buildWidgetsFromJson() {
    // parsers = HashMap();

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

      ParserCreator? parser  = widget._parsersCreateors[type];

      if (parser == null) {
        throw ParsingException("Unknown type $type");
      }
        try{
          Model item = parser.parseModel(widgetJson, isBeforeHeader);
          if(widget.items.any((element) => element.id == item.id)){
            throw ParsingException("Duplicate Id ${item.id}");
          }
          widget.items.add(item);

        } catch (e) {
          throw ParsingException("Bad $type format");
        }

      }
    }

  @override
  void initState() {

    _valueChange = widget.streamUpdates?.listen(_onRemoteValueChanged);
    dataClassStream = _onDataClassReady.stream.asBroadcastStream();
    super.initState();
  }

  late Stream<DataClass> dataClassStream;
  // void _onRemoteValueChanged(Map<String, dynamic> values) {
  //   for (String id in values.keys) {
  //     if (parsers[id] != null) {
  //       parsers[id]?.chosenValue = values[id];
  //       parsers[id]?.time = DateTime.now().millisecondsSinceEpoch;
  //       _onDataClassReady.add(DataClass(id: id, value: values[id]));
  //     }
  //   }
  // }
  void _onRemoteValueChanged(Map<String, dynamic> values) {
    for (String id in values.keys) { //Todo : ask Itai :(
      Model item = widget.items.firstWhere((element) => element.id == id,
          orElse: () => EmptyModel());
      if (item is EmptyModel) {

      } else {

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
                    child: CustomScrollView(key: const ValueKey("scrollView"),slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Model item = widget.items[index];
                            return (widget._parsersCreateors[item.type]?? EmptyCreator()).createWidget(item, widget.onValueChanged,  widget.dateBuilder);
                          },
                          childCount: widget.items.length,
                        ),
                      )
                    ]),
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
