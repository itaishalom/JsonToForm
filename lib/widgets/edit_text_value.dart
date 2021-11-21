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
  final int? debounceTime;
  final OnValueChanged? onValueChanged;

  EditTextValue(
      {Key? key,
      required this.name,
      required this.id,
      required this.isBeforeHeader,
      this.description,
      required this.onValueChanged,
      required this.chosenValue,
      this.debounceTime})
      : super(key: key);

  @override
  _EditTextValueState createState() => _EditTextValueState();
}

class _EditTextValueState extends State<EditTextValue> {
  TextEditingController? _controller;
  Timer? _debounce;
  bool firstTime = true;
  late FocusNode myFocusNode;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  void notifyValue() {
    if (widget.onValueChanged != null &&
        (!firstTime || _controller!.text != widget.chosenValue)) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (widget.debounceTime != null && widget.debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: widget.debounceTime!), () {
          if (widget.onValueChanged != null) {
            widget.onValueChanged!(widget.id, _controller!.text);
          }
        });
      } else {
        widget.onValueChanged!(widget.id, _controller!.text);
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller?.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  void startController() {
    if(!ignoreRebuild) {
      ignoreRebuild = false;
      if (_controller != null) {
        _controller = TextEditingController(text: _controller!.text);
      } else {
        _controller = TextEditingController(text: widget.chosenValue);
      }
      _controller?.addListener(notifyValue);
    }
  }

  bool ignoreRebuild = false;

  requestFocus(BuildContext context){
    FocusScope.of(context).requestFocus(myFocusNode); ignoreRebuild = true;
  }

  @override
  Widget build(BuildContext context) {
    startController();
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(
              name: widget.name, description: widget.description),
          SizedBox(
            height: InheritedJsonFormTheme.of(context).theme.editTextHeight,
            width: InheritedJsonFormTheme.of(context).theme.editTextWidth,
            child: TextFormField(
              onTap:() => requestFocus(context),
              focusNode: myFocusNode,
              autofocus: false,
              maxLines: 1,
              textAlign: TextAlign.center,
              obscureText: false,
              controller: _controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
              ],
              style: myFocusNode.hasFocus
                  ? InheritedJsonFormTheme.of(context).theme.editTextStyleFocus
                  : InheritedJsonFormTheme.of(context).theme.editTextStyle,
              cursorColor:
                  InheritedJsonFormTheme.of(context).theme.editTextCursorColor,
              //
              decoration:
                  InheritedJsonFormTheme.of(context).theme.inputDecoration,
            ),
          ),
        ],
      ),
    );
  }
}
