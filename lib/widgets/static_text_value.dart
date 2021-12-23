import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

class StaticTextValue extends StatelessWidget {
  StaticTextValue(
      {Key? key,
      required this.name,
      required this.id,
      required this.isBeforeHeader,
      this.description,
        this.dateBuilder,
        this.time,
      required this.chosenValue})
      : super(key: key);

  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final Widget Function(int date)? dateBuilder;
  int? time;

  @override
  Widget build(BuildContext context) {
    return LineWrapper(
      isBeforeHeader: isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(name: name, description: description,    dateBuilder: dateBuilder,
              time: time),
          Container(
            decoration: InheritedJsonFormTheme.of(context)
                .theme
                .staticContainerDecoration,
            child: Padding(
              //
              padding:
                  InheritedJsonFormTheme.of(context).theme.staticTextPadding,
              child: Text(
                chosenValue,
                style: InheritedJsonFormTheme.of(context).theme.staticTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
