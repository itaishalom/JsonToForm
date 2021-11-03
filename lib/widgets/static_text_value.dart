import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

class StaticTextValue extends StatelessWidget {

  const StaticTextValue(
      {Key? key,
        required this.name,
        required this.id,
        required this.isBeforeHeader,
        this.description,
        required this.chosenValue}): super(key: key);

  final String? description;
  final String name;
  final int id;
  final String chosenValue;
  final bool isBeforeHeader;

  @override
  Widget build(BuildContext context) {
    return LineWrapper(isBeforeHeader: isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(name: name, description: description),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Color(0xff383839))
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                chosenValue,
                style: InheritedJsonFormTheme.of(context)
                    .theme
                    .staticTextStyle,
              ),
            ),
          )


        ],
      ),
    );
  }
}
