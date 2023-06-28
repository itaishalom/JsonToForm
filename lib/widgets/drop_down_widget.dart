import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_lib.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:stream_live_data/live_data_builder.dart';

/// This is the stateful widget that the main application instantiates.
class DropDownWidget extends StatefulWidget {
  final Widget Function(int date, String id)? _dateBuilder;
  final DropDownParserModel _model;
  final OnValueChanged? _onValueChanged;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();

  const DropDownWidget({Key? key, required DropDownParserModel model, Future<bool> Function(String, dynamic)? onValueChanged, Widget Function(int, String)? dateBuilder})
      : _dateBuilder = dateBuilder, _onValueChanged = onValueChanged, _model = model, super(key: key);
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {

  @override
  void didUpdateWidget(covariant DropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget._model.dispose();
  }

  @override
  void dispose() {
    widget._model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight),
      child: LineWrapper(
        isBeforeHeader: widget._model.isBeforeHeader,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, textDirection: TextDirection.ltr, children: <Widget>[
          LiveDataBuilder<int?>(
              key: UniqueKey(),
              liveData: widget._model.time,
              builder: (context, time) {
                return NameWidgetDescription(
                  id: widget._model.id,
                  name: widget._model.name.toString(),
                  width: InheritedJsonFormTheme.of(context).theme.dropDownWidthOfHeader,
                  description: widget._model.description,
                  dateBuilder: widget._dateBuilder,
                  time: time.data,
                );
              }),
          Container(
            constraints: BoxConstraints(maxWidth: InheritedJsonFormTheme.of(context).theme.dropDownWith),
            child: LiveDataBuilder<dynamic>(
                key: UniqueKey(),
                liveData: widget._model.chosenValue,
                initialData: widget._model.chosenValue.value,
                builder: (context, snapshot) {
                  return DropdownButton<String>(
                    key: ValueKey(widget._model.id +"inner"),

                    dropdownColor: const Color(0xff222222),
                    value: snapshot.data,
                    isExpanded: true,
                    alignment: Alignment.centerRight,
                    icon: InheritedJsonFormTheme.of(context).theme.dropDownIcon != null
                        ? InheritedJsonFormTheme.of(context).theme.dropDownIcon!
                        : const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,
                          ),
                    iconSize: 24,
                    underline: InheritedJsonFormTheme.of(context).theme.underLineWidget != null
                        ? InheritedJsonFormTheme.of(context).theme.underLineWidget!
                        : Container(
                            height: 2,
                          ),
                    style: const TextStyle(
                      overflow: TextOverflow.clip,
                      color: Color(0xff8A8B8F),
                      fontSize: 16,
                    ),
                    onChanged: (String? newValue) async {
                      await _onChanged(newValue);
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return widget._model.values.map((String value) {
                        return Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            snapshot.data!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
                    },
                    items: widget._model.values.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  );
                }),
          )
        ]),
      ),
    );
  }

  _onChanged(String? newValue) async {
    if (await _changeValue(widget._model.id, newValue)) {
      widget._model.updateTime();
    }
  }

  Future<bool> _changeValue(String id, dynamic value) async {
    if (widget._model.chosenValue.value != value) {
      widget._model.updateValue(value, withTime: false);
      if (value != null) {
        return await widget._onValueChanged!(id, value);
      }
    }
    return false;
  }
}
