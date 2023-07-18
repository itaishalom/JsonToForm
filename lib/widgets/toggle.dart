import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/line_wrapper.dart';
import 'package:stream_live_data/stream_live_data.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../parsers/toggle_parser.dart';
import 'name_description_widget.dart';

class Toggle extends StatefulWidget {
  final ToggleModel _model;

  const Toggle({
    Key? key,
    required ToggleModel model,
    required Future<bool> Function(String, dynamic)? onValueChanged,
    Widget Function(int, String)? dateBuilder,
  }) : _dateBuilder = dateBuilder, _onValueChanged = onValueChanged, _model = model, super(key: key);

  final OnValueChanged? _onValueChanged;
  final Widget Function(int date, String id)? _dateBuilder;

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget._model.dispose();
  }

  @override
  void dispose() {
    widget._model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight),
      child: LineWrapper(
          isBeforeHeader: widget._model.isBeforeHeader,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: <Widget>[
              LiveDataBuilder<int?>(
                key: UniqueKey(),
                  liveData: widget._model.time,
                  builder: (context, snapshot) {
                    return NameWidgetDescription(
                        name: widget._model.name,
                        id: widget._model.id,
                        width: InheritedJsonFormTheme.of(context).theme.toggleWidthOfHeader,
                        description: widget._model.description,
                        dateBuilder: widget._dateBuilder,
                        time: snapshot.data);
                  }),
              LiveDataBuilder<dynamic>(
                  key: UniqueKey(),
                  liveData: widget._model.chosenValue,
                  builder: (context, snapshot) {
                    return ToggleSwitch(
                        activeBorders: InheritedJsonFormTheme.of(context).theme.activeToggleBorder != null
                            ? [InheritedJsonFormTheme.of(context).theme.activeToggleBorder]
                            : null,
                        doubleTapDisable: true,
                        minWidth: InheritedJsonFormTheme.of(context).theme.toggleMinWidth,
                        minHeight: InheritedJsonFormTheme.of(context).theme.toggleMinHeight,
                        fontSize: InheritedJsonFormTheme.of(context).theme.toggleFontSize,
                        initialLabelIndex: _getIndex(snapshot.data),
                        cornerRadius: 4.0,
                        activeBgColor: [InheritedJsonFormTheme.of(context).theme.toggleActiveColor],
                        activeFgColor: InheritedJsonFormTheme.of(context).theme.toggleActiveTextColor,
                        inactiveBgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveColor,
                        inactiveFgColor: InheritedJsonFormTheme.of(context).theme.toggleInactiveTextColor,
                        totalSwitches: widget._model.values.length,
                        labels: widget._model.values,
                        changeOnTap: false,
                        onToggle: (index) async {
                          String? newValue;
                          if (_indexToValue(index) == widget._model.chosenValue.value) {
                            index = null;
                          }
                          newValue = index != null ? widget._model.values[index] : null;

                          if (widget._onValueChanged != null) {
                            bool res = false;
                            widget._model.updateValue(newValue, withTime: false);
                            res = await widget._onValueChanged!(widget._model.id, newValue);
                            if (res) {
                              widget._model.updateTime();
                            }
                          }
                        });
                  }),
            ],
          )),
    );
  }

  String? _indexToValue(int? index) {
    return index != null ? widget._model.values[index] : null;
  }

  int? _getIndex(dynamic value) {
    int? temp = widget._model.values.indexOf(value ?? "");
    if (temp == -1) temp = null;
    return temp;
  }
}
