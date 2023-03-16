import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:stream_live_data/live_data.dart';
import 'package:stream_live_data/live_data_builder.dart';
import 'package:stream_live_data/live_data_token.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../parsers/toggle_parser.dart';
import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  final ToggleModel model;

  const Toggle({
    Key? key,
    required this.model,
    required this.onValueChanged,
    this.dateBuilder,
  }) : super(key: key);

  final OnValueChanged? onValueChanged;
  final Widget Function(int date, String id)? dateBuilder;

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool forceRefresh = false;

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (forceRefresh) {
      forceRefresh = false;
      //stringToIndex();
      // thisTime.value = widget.model.time;
    }
    return Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight),
      child: LineWrapper(
          isBeforeHeader: widget.model.isBeforeHeader,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: <Widget>[
              LiveDataBuilder<int?>(
                  liveData: widget.model.time,
                  builder: (context, snapshot) {
                    return NameWidgetDescription(
                        name: widget.model.name,
                        id: widget.model.id,
                        width: InheritedJsonFormTheme.of(context).theme.toggleWidthOfHeader,
                        description: widget.model.description,
                        dateBuilder: widget.dateBuilder,
                        time: snapshot.data);
                  }),
              LiveDataBuilder<dynamic?>(
                  liveData: widget.model.chosenValue,
                  builder: (context, snapshot) {
                    return ToggleSwitch(
                        activeBorders: InheritedJsonFormTheme.of(context).theme.activeToggleBorder != null
                            ? [InheritedJsonFormTheme.of(context).theme.activeToggleBorder]
                            : null,
                        doubleTapDisable: true,
                        minWidth: InheritedJsonFormTheme.of(context).theme.toggleMinWidth,
                        minHeight: InheritedJsonFormTheme.of(context).theme.toggleMinHeight,
                        fontSize: InheritedJsonFormTheme.of(context).theme.toggleFontSize,
                        initialLabelIndex: getIndex(snapshot.data),
                        cornerRadius: 4.0,
                        activeBgColor: [InheritedJsonFormTheme.of(context).theme.toggleActiveColor],
                        activeFgColor: InheritedJsonFormTheme.of(context).theme.toggleActiveTextColor,
                        inactiveBgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveColor,
                        inactiveFgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveTextColor,
                        totalSwitches: widget.model.values.length,
                        labels: widget.model.values,
                        changeOnTap: false,
                        onToggle: (index) async {
                          dynamic newValue = index != null ? widget.model.values[index] : index;
                          if (widget.onValueChanged != null) {
                            bool res = false;
                            widget.model.updateValue(newValue, withTime: false);
                            res = await widget.onValueChanged!(widget.model.id, newValue);
                            if (res) {
                              widget.model.updateTime();
                            }
                          }
                        });
                  }),
            ],
          )),
    );
  }

/*  void _onRemoteValueChanged(DataClass event) {
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
        thisTime.add(widget.model.time);
      });
    }
  }*/

  int? getIndex(dynamic value) {
    int? temp = widget.model.values.indexOf(value ?? "");
    if (temp == -1) temp = null;
    return temp;
  }
}
