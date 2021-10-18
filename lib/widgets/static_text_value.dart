import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

import 'name_description_widget.dart';

class StaticTextValue extends StatelessWidget {

  const StaticTextValue(
      {Key? key,
        required this.name,
        required this.id,
        this.description,
        required this.chosenValue}): super(key: key);

  final String? description;
  final String name;
  final int id;
  final String chosenValue;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      textDirection: TextDirection.rtl,
      children: <Widget>[
        NameWidgetDescription(name: name, description: description),
        Text(
          chosenValue,
          style: InheritedJsonFormTheme.of(context)
              .theme
              .staticTextStyle,
        )
      ],
    );
  }
}
