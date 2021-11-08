import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

/// This is the stateful widget that the main application instantiates.
class DropDownWidget extends StatefulWidget {
  DropDownWidget(
      {Key? key,
      required this.name,
      required this.id,
      required this.values,
      required this.description,
      required this.onValueChanged,
      this.chosenValue,
      required this.isBeforeHeader})
      : super(key: key);

  final String name;
  final String? description;
  final String id;
  final List<String> values;
  String? chosenValue;
  final OnValueChanged onValueChanged;
  final bool isBeforeHeader;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue ??= widget.chosenValue;
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            NameWidgetDescription(
                name: widget.name, description: widget.description),
            Container(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                dropdownColor: const Color(0xff222222),
                value: dropdownValue,
                icon: InheritedJsonFormTheme.of(context).theme.dropDownIcon !=
                        null
                    ? InheritedJsonFormTheme.of(context).theme.dropDownIcon!
                    : const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.white,
                      ),
                iconSize: 24,
                underline: InheritedJsonFormTheme.of(context)
                            .theme
                            .underLineWidget !=
                        null
                    ? InheritedJsonFormTheme.of(context).theme.underLineWidget!
                    : Container(
                        height: 2,
                      ),
                style: const TextStyle(
                  color: Color(0xff8A8B8F),
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    widget.onValueChanged(widget.id, dropdownValue);
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return widget.values.map((String value) {
                    return Center(
                      child: Text(
                        dropdownValue!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList();
                },
                items:
                    widget.values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ]),
    );
  }
}
