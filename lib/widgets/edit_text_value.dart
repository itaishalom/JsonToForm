import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../json_to_form_with_theme.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class EditTextValue extends StatefulWidget {
  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final OnValueChanged? onValueChanged;
  final Widget Function(int date)? dateBuilder;
  int? time;
  final bool isReadOnly;
  final bool long;

  EditTextValue({
    Key? key,
    required this.name,
    required this.id,
    required this.isBeforeHeader,
    this.description,
    required this.onValueChanged,
    required this.chosenValue,
    this.isReadOnly = false,
    this.long = false,
    this.dateBuilder,
    this.time,
  }) : super(key: key);

  @override
  _EditTextValueState createState() => _EditTextValueState();
}

class _EditTextValueState extends State<EditTextValue> {
  TextEditingController? _controller;
  Timer? _debounce;
  bool firstTime = true;
  late FocusNode myFocusNode;
  int? debounceTime;
  bool justLostFocus = false;
  int? thisTime;
  String? initialText = "";

  @override
  void initState() {
    _controller ??= TextEditingController(text: widget.chosenValue);
    _controller?.addListener(notifyValue);

    thisTime = widget.time;
    initialText = widget.chosenValue;
    if (!widget.isReadOnly) {
      myFocusNode = FocusNode();
      myFocusNode.addListener(() {
        if (!myFocusNode.hasFocus) {
          justLostFocus = true;
          setState(() {

          });
        }
      });
    }
    super.initState();
  }

  Future<void> notifyValue() async {
    if (initialText == _controller?.text) {
      return;
    }
    initialText = _controller?.text;
    if (widget.onValueChanged != null &&
        (!firstTime || _controller!.text != widget.chosenValue)) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (debounceTime != null && debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: debounceTime!), () async {
          if (widget.onValueChanged != null) {
            bool res = await widget.onValueChanged!(widget.id, _controller!.text);
            if (res && thisTime != null) {
              setState(() {
                thisTime = DateTime.now().millisecondsSinceEpoch;
              });
            }
          }
        });
      } else {
        bool res = await widget.onValueChanged!(widget.id, _controller!.text);
        if (res && thisTime != null) {
          setState(() {
            thisTime = DateTime.now().millisecondsSinceEpoch;
          });
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller?.dispose();
    if(!widget.isReadOnly) {
      myFocusNode.dispose();
    }
    super.dispose();
  }

  void startController() {
    if (!widget.isReadOnly) {
      if (justLostFocus) {
        justLostFocus = false;
        return;
      }

      if (myFocusNode.hasFocus) {
        _controller?.text = (_controller!.text);
      } else {
        _controller?.text = (widget.chosenValue);
        thisTime = widget.time;
      }
      _controller?.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller!.text.length));
    }
    //  _controller?.addListener(notifyValue);
  }

  requestFocus(BuildContext context) {
    //WidgetsBinding.instance?.addPostFrameCallback((_) => _controller?.text = (_controller!.text));
    if (!widget.isReadOnly) {
      FocusScope.of(context).requestFocus(myFocusNode);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debounceTime = InheritedJsonFormTheme.of(context).theme.debounceTime;
    startController();
    Widget text = Container(
        margin: widget.long
            ? InheritedJsonFormTheme.of(context).theme.editTextLongMargins
            : InheritedJsonFormTheme.of(context).theme.editTextMargins,
        child: TextFormField(
          onTap: () => requestFocus(context),
          focusNode: widget.isReadOnly ? null : myFocusNode,
          autofocus: false,
          readOnly: widget.isReadOnly,
          maxLines: widget.long ? 10 : 1,
          minLines: 1,
          inputFormatters: widget.long
              ? []
              : [
                  LengthLimitingTextInputFormatter(12),
                ],
          textAlign: widget.long ? TextAlign.start : TextAlign.center,
          obscureText: false,
          controller: _controller,
          style: !widget.isReadOnly
              ? (myFocusNode.hasFocus
                  ? InheritedJsonFormTheme.of(context).theme.editTextStyleFocus
                  : InheritedJsonFormTheme.of(context).theme.editTextStyle)
              : InheritedJsonFormTheme.of(context).theme.editTextStyle,
          cursorColor:
              InheritedJsonFormTheme.of(context).theme.editTextCursorColor,
          //
          decoration: widget.isReadOnly
              ? InheritedJsonFormTheme.of(context).theme.inputDecorationReadOnly
              : InheritedJsonFormTheme.of(context).theme.inputDecoration,
        ));

    List<Widget> innerWidgets = [
      NameWidgetDescription(
          name: widget.name,
          description: widget.description,
          dateBuilder: widget.dateBuilder,
          time: thisTime,
      componentSameLine: !widget.long,),
    ];
    if (widget.long) {
      innerWidgets.add(text);
    } else {
      innerWidgets.add(SizedBox(
          height: InheritedJsonFormTheme.of(context).theme.editTextHeight,
          width: InheritedJsonFormTheme.of(context).theme.editTextWidth,
          child: text));
    }
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: widget.long
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: <Widget>[...innerWidgets],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: <Widget>[...innerWidgets],
            ),
    );
  }
}
