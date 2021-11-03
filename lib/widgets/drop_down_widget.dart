import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form/json_to_form.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

/// This is the stateful widget that the main application instantiates.
class DropDownWidget extends StatefulWidget {
  const DropDownWidget(
      {Key? key,
      required this.name,
      required this.id,
      required this.values,
      required this.description,
      required this.onValueChanged,
      this.chosenValue, required this.isBeforeHeader})
      : super(key: key);

  final String name;
  final String? description;
  final int id;
  final List<String> values;
  final String? chosenValue;
  final OnValueChanged onValueChanged;
  final bool isBeforeHeader;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {


  @override
  Widget build(BuildContext context) {
    String? value = widget.chosenValue;
    return LineWrapper(isBeforeHeader: widget.isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            NameWidgetDescription(
                name: widget.name, description: widget.description),
            DropdownButton<String>(
              value: value ?? widget.values[0],
              icon: InheritedJsonFormTheme.of(context).theme.dropDownIcon != null
                  ? InheritedJsonFormTheme.of(context).theme.dropDownIcon!
                  : const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Color(0xff8A8B8F)),
              underline:
                  InheritedJsonFormTheme.of(context).theme.underLineWidget != null
                      ? InheritedJsonFormTheme.of(context).theme.underLineWidget!
                      : Container(
                          height: 2,
                        ),
              onChanged: (String? newValue) {
                setState(() {
                  value = newValue!;
                });
                widget.onValueChanged(widget.id, value);
              },
              items: widget.values.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ]),
    );
  }
}
