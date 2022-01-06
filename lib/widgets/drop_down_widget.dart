import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../stream_cache.dart';
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
      this.dateBuilder,
      this.time,
      required this.isBeforeHeader})
      : super(key: key){
    streamUpdates = StreamCache.getStream(id);
    streamRefresh = StreamCache.getStreamRefresh(id);
  }

  final String name;
  final String? description;
  final String id;
  final List<String> values;
  String? chosenValue;
  final OnValueChanged? onValueChanged;
  final bool isBeforeHeader;
  final Widget Function(int date)? dateBuilder;
  int? time;
   StreamController<String?>? streamUpdates;
  StreamController<bool?>? streamRefresh;

  @override
  State<DropDownWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownWidget> {
  String? dropdownValue;

  late final StreamSubscription<String?>? _valueChange;
  bool forceRefresh = false;

  @override
  void initState() {
    widget.streamUpdates?.stream.asBroadcastStream().listen(_onRemoteValueChanged);
    widget.streamRefresh?.stream.asBroadcastStream().listen((event) {
      setState(() {
        forceRefresh = true;
      });
    });
    dropdownValue = widget.chosenValue;
    thisTime = widget.time;
    super.initState();
  }


  void _onRemoteValueChanged(String? event) {
    setState(() {
      dropdownValue = event;
      thisTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  @override
  dispose(){
    StreamCache.closeStream(widget.id);
    StreamCache.closeRefreshStream(widget.id);
    super.dispose();
  }


  int? thisTime;

  @override
  Widget build(BuildContext context) {
    if(forceRefresh){
      forceRefresh = false;
      dropdownValue = widget.chosenValue;
      thisTime = widget.time;
    }
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            NameWidgetDescription(
                name: widget.name,
                description: widget.description,
                dateBuilder: widget.dateBuilder,
                time: thisTime),
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
                onChanged: (String? newValue) async {
                  if( mounted) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  }
                  bool res = true;
                  if (widget.onValueChanged != null) {
                    res =
                        await widget.onValueChanged!(widget.id, dropdownValue);
                  }
                  if (res && mounted) {
                    setState(() {
                      thisTime = DateTime.now().millisecondsSinceEpoch;
                    });
                  }
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
