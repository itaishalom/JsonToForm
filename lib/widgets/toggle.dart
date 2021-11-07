import 'package:flutter/widgets.dart';
import 'package:json_to_form/json_to_form.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';
import 'package:json_to_form/widgets/line_wrapper.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  Toggle({Key? key,
    required this.name,
    required this.id,
    required this.values,
    required this.onValueChanged,
    this.description,
    required this.isBeforeHeader,
    this.chosenValue})
      : super(key: key);

  final String? description;
  final String name;
  final int id;
  final List<String> values;
  int? chosenValue;
  final OnValueChanged onValueChanged;
  final bool isBeforeHeader;

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle>  {

  @override
  Widget build(BuildContext context) {
    return LineWrapper(isBeforeHeader: widget.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(
              name: widget.name, description: widget.description),
          ToggleSwitch(
            doubleTapDisable: true,
            minWidth: InheritedJsonFormTheme.of(context).theme.toggleMinWidth,
            minHeight: InheritedJsonFormTheme.of(context).theme.toggleMinHeight,
            fontSize: InheritedJsonFormTheme.of(context).theme.toggleFontSize,
            initialLabelIndex: widget.chosenValue,
            activeBgColor: [
              InheritedJsonFormTheme.of(context).theme.toggleActiveColor
            ],
            activeFgColor:
                InheritedJsonFormTheme.of(context).theme.toggleActiveTextColor,
            inactiveBgColor:
                InheritedJsonFormTheme.of(context).theme.toggleInactiveColor,
            inactiveFgColor: InheritedJsonFormTheme.of(context)
                .theme
                .toggleInactiveTextColor,
            totalSwitches: widget.values.length,
            labels: widget.values,
            onToggle: (index) {
              widget.onValueChanged(widget.id, index);
            },
          )
        ],
      ),
    );
  }

  @override
  void onNewValue(value) {
    setState(() {

    });
  }
}
