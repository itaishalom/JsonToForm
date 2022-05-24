import 'package:example/drop_down_parser2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:json_to_form_with_theme/widgets/name_description_widget.dart';


/// This is the stateful widget that the main application instantiates.
class DropDownWidget2 extends StatefulWidget {
  final DropDownParser2Model model;
  final OnValueChanged? onValueChanged;
  final Widget Function(int date, String id)? dateBuilder;

  DropDownWidget2(
      {Key? key,
        required this.model,
      required this.onValueChanged,
        this.dateBuilder,
      })
      : super(key: key);

  @override
  State<DropDownWidget2> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget2> {
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue ??= widget.model.chosenValue;
    return LineWrapper(
      isBeforeHeader: widget.model.isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            NameWidgetDescription(width: InheritedJsonFormTheme.of(context).theme.dropDownWidthOfHeader, id: widget.model.id,
                name: widget.model.name, description: widget.model.description,    dateBuilder: widget.dateBuilder,
                time: widget.model.time),
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
                    if(widget.onValueChanged!= null) {
                      widget.onValueChanged!(widget.model.id, dropdownValue);
                    }
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return widget.model.values.map((String value) {
                    return Center(
                      child: Text(
                        dropdownValue!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList();
                },
                items:
                    widget.model.values.map<DropdownMenuItem<String>>((String value) {
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
