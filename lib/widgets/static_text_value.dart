import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../stream_cache.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class StaticTextValue extends StatefulWidget {
  StaticTextValue(
      {Key? key,
      required this.name,
      required this.id,
      required this.isBeforeHeader,
      this.description,
      this.dateBuilder,
      this.time,
      required this.chosenValue})
      : super(key: key) {
    streamUpdates = StreamCache.getStream(id);
    streamRefresh = StreamCache.getStreamRefresh(id);
  }

  StreamController<bool?>? streamRefresh;
  StreamController<String?>? streamUpdates;
  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final Widget Function(int date)? dateBuilder;
  int? time;

  @override
  _StaticTextValueState createState() => _StaticTextValueState();
}

class _StaticTextValueState extends State<StaticTextValue> {
  int? thisTime;
  String value = "";
  bool forceRefresh = false;
  @override
  void initState() {
    value = widget.chosenValue;
    thisTime = widget.time;
    widget.streamUpdates?.stream
        .asBroadcastStream()
        .listen(_onRemoteValueChanged);
    widget.streamRefresh?.stream.asBroadcastStream().listen((event) {
      setState(() {
        forceRefresh = true;
      });
    });

    super.initState();
  }

  void _onRemoteValueChanged(String? event) {
    setState(() {
      value = event ?? "";
      thisTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  @override
  void dispose() {
    StreamCache.closeRefreshStream(widget.id);
    StreamCache.closeStream(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(forceRefresh){
      forceRefresh = false;
      value = widget.chosenValue;
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
            decoration: InheritedJsonFormTheme.of(context)
                .theme
                .staticContainerDecoration,
            child: Padding(
              //
              padding:
                  InheritedJsonFormTheme.of(context).theme.staticTextPadding,
              child: Text(
                value,
                style: InheritedJsonFormTheme.of(context).theme.staticTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
