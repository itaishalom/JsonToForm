import 'dart:async';

import 'package:example/drop_down_parser2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:json_to_form_with_theme/widgets/name_description_widget.dart';
import 'package:stream_live_data/stream_live_data.dart';


/// This is the stateful widget that the main application instantiates.
class DropDownWidget extends StatefulWidget {
  final Widget Function(int date, String id)? dateBuilder;
  final DropDownModel model;
  final OnValueChanged? onValueChanged;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();

  DropDownWidget({Key? key, required this.model, this.onValueChanged, this.dateBuilder});
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {

  bool forceRefresh = false;

  @override
  void didUpdateWidget(covariant DropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.model.dispose();
    forceRefresh = true;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (forceRefresh) {
      forceRefresh = false;
      //  dropdownValue = widget.model.chosenValue.value;
    }
    return Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight),
      child: LineWrapper(
        isBeforeHeader: widget.model.isBeforeHeader,
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, textDirection: TextDirection.ltr, children: <Widget>[
          LiveDataBuilder<int?>(
              key: UniqueKey(),
              liveData: widget.model.time,
              builder: (context, time) {
                return NameWidgetDescription(
                  id: widget.model.id,
                  name: widget.model.name,
                  width: InheritedJsonFormTheme.of(context).theme.dropDownWidthOfHeader,
                  description: widget.model.description,
                  dateBuilder: widget.dateBuilder,
                  time: time.data,
                );
              }),
          Container(
            constraints: BoxConstraints(maxWidth: InheritedJsonFormTheme.of(context).theme.dropDownWith),
            child: StreamBuilder<dynamic>(
                initialData: "",
                stream: widget.model.chosenValueStream,
                builder: (context, snapshot) {
                  return DropdownButton<String>(
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
                      await onChanged(newValue);
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return widget.model.values.map((String value) {
                        return Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            snapshot.data!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
                    },
                    items: widget.model.values.map<DropdownMenuItem<String>>((String value) {
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

  onChanged(String? newValue) async {
    if (await changeValue(widget.model.id, newValue)) {
      widget.model.updateTime();
    }
  }

  Future<bool> changeValue(String id, dynamic value) async {
    // if (widget.model.chosenValue.value != value) {
    widget.model.updateValue(value, withTime: false);
    if (value != null) {
      return await widget.onValueChanged!(id, value);
    }
    //   }
    return false;
  }
}
