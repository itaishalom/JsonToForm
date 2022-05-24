import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:sizer/sizer.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';

/// This is the stateful widget that the main application instantiates.
class DropDownWidget extends StatefulWidget {
  
  // DropDownWidget(
  //     {Key? key,
  //     required this.name,
  //     required this.id,
  //     required this.values,
  //     required this.description,
  //     required this.onValueChanged,
  //     required this.getUpdatedTime,
  //     this.chosenValue,
  //       required this.onTimeUpdated,
  //     required this.getUpdatedValue,
  //     this.dateBuilder,
  //     this.time,
  //     required this.isBeforeHeader})
  //     : super(key: key);

  // Function(int) onTimeUpdated;
  // final Function getUpdatedTime;
  // final Function getUpdatedValue;
  // final String name;
  // final String? description;
  // final String id;
  // final List<String> values;
  // String? chosenValue;
  // final bool isBeforeHeader;
  final Widget Function(int date, String id)? dateBuilder;
  // int? time;
  final DropDownModel model;
  final OnValueChanged? onValueChanged;
  
  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();
  
  DropDownWidget({Key? key, required this.model, this.onValueChanged, this.dateBuilder});
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {
  String? dropdownValue;
  final ValueNotifier<int?> thisTime = ValueNotifier<int?>(null);

  late final StreamSubscription<String?>? _valueChange;
  bool forceRefresh = false;

  @override
  void didUpdateWidget(covariant DropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)!
        .dataClassStream
        .listen(_onRemoteValueChanged);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    dropdownValue = widget.model.chosenValue;
    thisTime.value = widget.model.time;
    super.initState();
  }

  void _onRemoteValueChanged(DataClass dataClass) {
    if (dataClass.id == widget.model.id && mounted) {
      setState(() {
        dropdownValue = dataClass.value;
      });
      thisTime.value = widget.model.time;
    }
  }


  @override
  Widget build(BuildContext context) {
    if (forceRefresh) {
      forceRefresh = false;
      dropdownValue = widget.model.chosenValue;
      thisTime.value = widget.model.time;
    }
    return LineWrapper(
      isBeforeHeader: widget.model.isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            ValueListenableBuilder<int?>(
                valueListenable: thisTime,
                builder: (context, time, _) {
                  return   NameWidgetDescription(
                    id: widget.model.id,
                    name: widget.model.name,
                    width: InheritedJsonFormTheme.of(context).theme.dropDownWidthOfHeader,
                    description: widget.model.description,
                    dateBuilder: widget.dateBuilder,
                    time: time,
                  );
                }),
            Container(
              constraints: BoxConstraints(
                  maxWidth:
                      InheritedJsonFormTheme.of(context).theme.dropDownWith.w),
              child: DropdownButton<String>(
                key: ValueKey(widget.model.id +"inner"),
                dropdownColor: const Color(0xff222222),
                value: dropdownValue,
                isExpanded: true,
                alignment: Alignment.centerRight,
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
                  overflow: TextOverflow.clip,
                  color: Color(0xff8A8B8F),
                  fontSize: 16,
                ),
                onChanged: (String? newValue) async {
                  await onChanged(newValue);
                },
                selectedItemBuilder: (BuildContext context) {
                  return widget.model.values.map((String value) {
                    return Container(
                      alignment: Alignment.centerRight,
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
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            )
          ]),
    );
  }

  onChanged(String? newValue) async {
    if (mounted) {
      setState(() {
        dropdownValue = newValue!;
      });
    }

    bool res = await changeValue(widget.model.id, dropdownValue);

    if (res) {
      thisTime.value = DateTime.now().millisecondsSinceEpoch;
      widget.model.time = thisTime.value!;
    }
  }

  Future<bool> changeValue(String id, dynamic value) async {
    if (widget.model.chosenValue != value) {
      widget.model.chosenValue = value;
      if (widget.model.chosenValue != null) {
        return await widget.onValueChanged!(id, value);
      }
    }
    return false;
  }
}
