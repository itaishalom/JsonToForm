import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form/json_to_form.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

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
      this.chosenValue})
      : super(key: key);

  final String name;
  final String? description;
  final int id;
  final List<String> values;
  final int? chosenValue;
  final OnValueChanged onValueChanged;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          NameWidgetDescription(
              name: widget.name, description: widget.description),
          DropdownButton<String>(
            value: dropdownValue,
            icon: InheritedJsonFormTheme.of(context).theme.dropDownIcon != null
                ? InheritedJsonFormTheme.of(context).theme.dropDownIcon!
                : const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline:
                InheritedJsonFormTheme.of(context).theme.underLineWidget != null
                    ? InheritedJsonFormTheme.of(context).theme.underLineWidget!
                    : Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
              widget.onValueChanged(widget.id, dropdownValue);
            },
            items: widget.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ]);
  }
}
