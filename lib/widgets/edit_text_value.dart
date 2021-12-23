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


  EditTextValue({
    Key? key,
    required this.name,
    required this.id,
    required this.isBeforeHeader,
    this.description,
    required this.onValueChanged,
    required this.chosenValue,
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

  @override
  void initState() {
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      if(!myFocusNode.hasFocus){
        justLostFocus = true;
      }
    });
    super.initState();
  }

  void notifyValue() {
    if (widget.onValueChanged != null &&
        (!firstTime || _controller!.text != widget.chosenValue)) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (debounceTime
          != null && debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: debounceTime!), () {
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
    _controller ??= TextEditingController(text: widget.chosenValue);
    if(justLostFocus){
      justLostFocus = false;
      return;
    }
    if (myFocusNode.hasFocus) {
        _controller = TextEditingController(text: _controller!.text);
      }else{
      _controller = TextEditingController(text: widget.chosenValue);
    }
    _controller?.addListener(notifyValue);
  }


  requestFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    debounceTime = InheritedJsonFormTheme.of(context).theme.debounceTime;
    startController();
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
              time: widget.time),
          SizedBox(
            height: InheritedJsonFormTheme.of(context).theme.editTextHeight,
            width: InheritedJsonFormTheme.of(context).theme.editTextWidth,
            child: TextFormField(
              onTap: () => requestFocus(context),
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
