import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  Toggle(
      {Key? key,
      required this.name,
      required this.id,
      required this.values,
      required this.onValueChanged,
      this.description,
      this.dateBuilder,
      this.time,
      required this.getUpdatedTime,
      required this.onTimeUpdated,
      required this.isBeforeHeader,
      required this.getUpdatedValue,
      this.chosenValue})
      : super(key: key);

  Function(int) onTimeUpdated;

  final Function getUpdatedTime;
  final Function getUpdatedValue;
  final String? description;
  final String name;
  final String id;
  final List<String> values;
  String? chosenValue;
  final OnValueChanged? onValueChanged;
  final bool isBeforeHeader;
  final Widget Function(int date, String id)? dateBuilder;
  int? time;

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
    thisTime.value = widget.getUpdatedTime();
    stringToIndex();

    super.initState();
  }

  stringToIndex() {
    if (widget.getUpdatedValue() == null || widget.getUpdatedValue()!.isEmpty) {
      updatedIndex = null;
    } else {
      updatedIndex = widget.values.indexOf(widget.getUpdatedValue()!);
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
      thisTime.value = widget.getUpdatedTime();
    }
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          ValueListenableBuilder<int?>(
              valueListenable: thisTime,
              builder: (context, time, _) {
                return NameWidgetDescription(
                  name: widget.name,
                  id: widget.id,
                  width: InheritedJsonFormTheme.of(context).theme.toggleWidthOfHeader,
                  description: widget.description,
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
            totalSwitches: widget.values.length,
            labels: widget.values,
            onToggle: (index) async {
              if (widget.onValueChanged != null) {
                bool res = false;
                updatedIndex = index;
                res = await widget.onValueChanged!(widget.id, index != null ? widget.values[index] : index);
                if (res) {
                  thisTime.value = DateTime.now().millisecondsSinceEpoch;
                  widget.onTimeUpdated(thisTime.value!);
                }
              }
            },
          )
        ],
      ),
    );
  }

  void _onRemoteValueChanged(DataClass event) {
    if (event.id != widget.id) {
      return;
    }
    if (mounted) {
      setState(() {
        if (event.value == null) {
          updatedIndex = null;
        } else {
          updatedIndex = widget.values.indexOf(event.value);
          if (updatedIndex == -1) {
            updatedIndex = null;
          }
        }
        thisTime.value = widget.getUpdatedTime();
      });
    }
  }
}
