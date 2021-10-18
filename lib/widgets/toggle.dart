import 'package:flutter/widgets.dart';
import 'package:json_to_form/json_to_form.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  const Toggle(
      {Key? key,
      required this.name,
      required this.id,
      required this.values,
      required this.onValueChanged,
      this.description,
      this.chosenValue})
      : super(key: key);

  final String? description;
  final String name;
  final int id;
  final List<String> values;
  final int? chosenValue;
  final OnValueChanged onValueChanged;

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      textDirection: TextDirection.rtl,
      children: <Widget>[
        NameWidgetDescription(name: widget.name, description: widget.description),
        ToggleSwitch(
          minWidth: InheritedJsonFormTheme.of(context).theme.toggleMinWidth,
          minHeight: InheritedJsonFormTheme.of(context).theme.toggleMinHeight,
          fontSize: InheritedJsonFormTheme.of(context).theme.toggleFontSize,
          initialLabelIndex: widget.chosenValue!,
          activeBgColor: [
            InheritedJsonFormTheme.of(context).theme.toggleActiveColor
          ],
          activeFgColor:
              InheritedJsonFormTheme.of(context).theme.toggleActiveTextColor,
          inactiveBgColor:
              InheritedJsonFormTheme.of(context).theme.toggleInactiveColor,
          inactiveFgColor:
              InheritedJsonFormTheme.of(context).theme.toggleInactiveTextColor,
          totalSwitches: widget.values.length,
          labels: widget.values,
          onToggle: (index) {
            widget.onValueChanged(widget.id, index);
          },
        )
      ],
    );
  }
}
