import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:sizer/sizer.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

class StaticTextValue extends StatefulWidget {
  StaticTextValue(
      {Key? key,
      required this.name,
      required this.id,
      required this.isBeforeHeader,
      this.description,
      this.dateBuilder,
      this.time,
      required this.chosenValue})
      : super(key: key) {
  }

  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final Widget Function(int date, String id)? dateBuilder;
  int? time;

  @override
  _StaticTextValueState createState() => _StaticTextValueState();
}

class _StaticTextValueState extends State<StaticTextValue> {
  int? thisTime;
  String value = "";
  bool forceRefresh = false;
  @override
  void initState() {
    value = widget.chosenValue;
    thisTime = widget.time;
    super.initState();
  }
  @override
  void didUpdateWidget(covariant StaticTextValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)?.dataClassStream.listen(_onRemoteValueChanged);
    super.didChangeDependencies();
  }

  void _onRemoteValueChanged(DataClass event) {
    if (event.id == widget.id && mounted) {
      setState(() {
        value = event.value ?? "";
        thisTime = DateTime
            .now()
            .millisecondsSinceEpoch;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if(forceRefresh){
      forceRefresh = false;
      value = widget.chosenValue;
      thisTime = widget.time;
    }
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(
            width: InheritedJsonFormTheme.of(context).theme.staticTextWidthOfHeader,
              name: widget.name,
              id: widget.id,
              description: widget.description,
              dateBuilder: widget.dateBuilder,
              time: thisTime),
          Container(
            width: InheritedJsonFormTheme.of(context)
                .theme
                .staticValueWidth.w,
            decoration: InheritedJsonFormTheme.of(context)
                .theme
                .staticContainerDecoration,
            child: Padding(
              //
              padding:
                  InheritedJsonFormTheme.of(context).theme.staticTextPadding,
              child: Text(
                value,
                style: InheritedJsonFormTheme.of(context).theme.staticTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
