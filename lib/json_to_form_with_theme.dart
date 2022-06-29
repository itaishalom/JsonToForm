library json_to_form_with_theme;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/header_parser.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/static_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/toggle_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/saveable_edit_text_value.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

typedef OnValueChanged = Future<bool> Function(String id, dynamic value);
typedef DateBuilderMethod =  Widget Function(int date, String id);
typedef SaveBarBuilderMethod =  Widget Function({required Function onSave, required Function onClose});

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

   SaveBarBuilderMethod? _savebarBuilderMethod;
   JsonFormWithThemeBuilder setSaveBarBuilderMethod(SaveBarBuilderMethod saveBarBuilderMethod){
     _savebarBuilderMethod = saveBarBuilderMethod;
     return this;
   }

   OnValueChanged? _onValueChanged;

   JsonFormWithThemeBuilder setOnValueChanged(OnValueChanged onValueChanged){
     _onValueChanged = onValueChanged;
     return this;
   }

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
  final DateBuilderMethod? dateBuilder;
  final SaveBarBuilderMethod? savebarBuilder;
  final HashMap<String, ParserCreator> _creators;
  final List<ItemModel> items = [];
  final OnValueChanged? onValueChanged;
  final Map<String, dynamic> jsonWidgets;
  final JsonFormTheme theme;
  final Stream<Map<String, dynamic>>? streamUpdates;


  JsonFormWithTheme._builder(JsonFormWithThemeBuilder builder):
        jsonWidgets = builder.jsonWidgets,
        onValueChanged=  builder._onValueChanged,
        theme= builder._theme,
        streamUpdates= builder._streamUpdates,
        dateBuilder= builder._dateBuilderMethod,
        savebarBuilder = builder._savebarBuilderMethod,
        _creators = builder._parsers,
        super();

  JsonFormWithTheme._({
    Key? key,
    required this.jsonWidgets,
    this.onValueChanged,
    this.theme = const DefaultTheme(),
    this.streamUpdates,
    this.dateBuilder,
    this.savebarBuilder,
  }) :_creators = HashMap(), super(key: key);

  @override
  _JsonFormWithThemeState createState() => _JsonFormWithThemeState();
}

class _JsonFormWithThemeState extends State<JsonFormWithTheme> {
  late final StreamSubscription<Map<String, dynamic>>? _valueChange;
  late Stream<DataClass> dataClassStream;

  final StreamController<DataClass> _onDataClassReady =
      StreamController<DataClass>();

  buildWidgetsFromJson() {
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

      ParserCreator? parser  = widget._creators[type];

      if (parser == null) {
        throw ParsingException("Unknown type $type");
      }
        try{
          ItemModel item = parser.parseModel(widgetJson, isBeforeHeader);
          if(widget.items.any((element) => element.id == item.id)){
            throw ParsingException("Duplicate Id ${item.id}");
          }
          widget.items.add(item);
        } catch (e) {
          throw ParsingException("Bad $type format");
        }
      }

      for(int i = 0; i< widget.items.length; i++){
        ItemModel currentItem = widget.items[i];
        bool hasNext = false;
        if(currentItem.type == "edit_text")
        {
          if( widget.items.length > (i + 1)){
            hasNext = widget.items[i + 1].type == "edit_text";
          }
          if(!hasNext && widget.items.length > (i + 2)){
            hasNext =  widget.items[i + 1].type == "header" &&  widget.items[i + 2].type == "edit_text";
          }
          (currentItem as EditTextValueModel).hasNext  = hasNext;
        }
      }
    }

  @override
  void initState() {
    _valueChange = widget.streamUpdates?.listen(_onRemoteValueChanged);
    dataClassStream = _onDataClassReady.stream.asBroadcastStream();
    buildWidgetsFromJson();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JsonFormWithTheme oldWidget) {
    buildWidgetsFromJson();
    super.didUpdateWidget(oldWidget);
  }


  void _onRemoteValueChanged(Map<String, dynamic> values) {
    for (String id in values.keys) { //Todo : ask Itai :(
      ItemModel item = widget.items.firstWhere((element) => element.id == id,
          orElse: () => EmptyItemModel());
      if (item is! EmptyItemModel) {
        item.updateValue(values[id]);
        _onDataClassReady.add(DataClass(id: id, value: values[id]));
      }
    }
  }

  @override
  void dispose() {
    _valueChange?.cancel();
    _onDataClassReady.close();
    super.dispose();
  }
  Saveble? selected;
  @override
  Widget build(BuildContext context) {
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
                    child: FooterLayout(
        footer: selected == null? SizedBox.shrink() :widget.savebarBuilder!(onSave: (){
          selected?.save();
        }, onClose: (){
          selected?.reset();
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          setState((){selected = null;});
        }),
    child:FocusScope(
      child: CustomScrollView(key: const ValueKey("scrollView"),slivers: <Widget>[
                        SliverList(
                          key: const ValueKey("theList"),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              ItemModel item = widget.items[index];
                              Widget theItem =  (widget._creators[item.type]?? EmptyCreator()).createWidget(item, widget.onValueChanged,  widget.dateBuilder, null);// widget.savebarBuilder);
                              if(theItem is SaveableEditTextValue){
                                theItem.whenFoucsed= (isFoucsed, item)=> setState(()=>selected = isFoucsed? item: null);

                              }
                              return theItem;
                            },
                            childCount: widget.items.length,
                          ),
                        )
                      ]),
    ),
                  ),
                ))));
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
