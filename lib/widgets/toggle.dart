import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../parsers/toggle_parser.dart';
import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  final ToggleModel model;
  Toggle(
      {Key? key,
        required this.model,
      required this.onValueChanged,
      this.dateBuilder,
      })
      : super(key: key);

  final OnValueChanged? onValueChanged;
  final Widget Function(int date, String id)? dateBuilder;
  
  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  final ValueNotifier<int?> thisTime = ValueNotifier<int?>(null);
  bool forceRefresh = false;

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)!.dataClassStream.listen(_onRemoteValueChanged);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    thisTime.value = widget.model.time;
    stringToIndex();

    super.initState();
  }

  stringToIndex() {
    if (widget.model.chosenValue == null || widget.model.chosenValue!.isEmpty) {
      updatedIndex = null;
    } else {
      updatedIndex = widget.model.values.indexOf(widget.model.chosenValue!);
      if (updatedIndex == -1) {
        updatedIndex = null;
      }
    }
  }

  int? updatedIndex;

  @override
  Widget build(BuildContext context) {
    if (forceRefresh) {
      forceRefresh = false;
      stringToIndex();
      thisTime.value = widget.model.time;
    }
    return LineWrapper(
      isBeforeHeader: widget.model.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          ValueListenableBuilder<int?>(
              valueListenable: thisTime,
              builder: (context, time, _) {
                return NameWidgetDescription(
                  name: widget.model.name,
                  id: widget.model.id,
                  width: InheritedJsonFormTheme.of(context).theme.toggleWidthOfHeader,
                  description: widget.model.description,
                  dateBuilder: widget.dateBuilder,
                  time: time,
                );
              }),
          ToggleSwitch(
            activeBorders: InheritedJsonFormTheme.of(context).theme.activeToggleBorder !=
                null?[InheritedJsonFormTheme.of(context).theme.activeToggleBorder] : null,
            doubleTapDisable: true,
            minWidth: InheritedJsonFormTheme.of(context).theme.toggleMinWidth,
            minHeight: InheritedJsonFormTheme.of(context).theme.toggleMinHeight,
            fontSize: InheritedJsonFormTheme.of(context).theme.toggleFontSize,
            initialLabelIndex: updatedIndex,
            cornerRadius: 4.0,
            activeBgColor: [InheritedJsonFormTheme.of(context).theme.toggleActiveColor],
            activeFgColor: InheritedJsonFormTheme.of(context).theme.toggleActiveTextColor,
            inactiveBgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveColor,
            inactiveFgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveTextColor,
            totalSwitches: widget.model.values.length,
            labels: widget.model.values,
            onToggle: (index) async {
              if (widget.onValueChanged != null) {
                bool res = false;
                updatedIndex = index;
                res = await widget.onValueChanged!(widget.model.id, index != null ? widget.model.values[index] : index);
                if (res) {
                  thisTime.value = DateTime.now().millisecondsSinceEpoch;
                  widget.model.time = thisTime.value!;
                }
              }
            },
          )
        ],
      ),
    );
  }

  void _onRemoteValueChanged(DataClass event) {
    if (event.id != widget.model.id) {
      return;
    }
    if (mounted) {
      setState(() {
        if (event.value == null) {
          updatedIndex = null;
        } else {
          updatedIndex = widget.model.values.indexOf(event.value);
          if (updatedIndex == -1) {
            updatedIndex = null;
          }
        }
        thisTime.value = widget.model.time;
      });
    }
  }
}
