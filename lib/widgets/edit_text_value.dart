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
  final OnValueChanged onValueChanged;

  EditTextValue(
      {Key? key,
      required this.name,
      required this.id,
      required this.isBeforeHeader,
      this.description,
      required this.onValueChanged,
      required this.chosenValue})
      : super(key: key);

  @override
  _EditTextValueState createState() => _EditTextValueState();
}

class _EditTextValueState extends State<EditTextValue> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.chosenValue);
    _controller?.addListener(notifyValue);
    super.initState();
  }

  void notifyValue() {
    widget.onValueChanged(widget.id, _controller!.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IntrinsicWidth(
                child: Center(
                  child: TextField(
                    key: widget.key,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    obscureText: false,
                    controller: _controller,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(12),

                      /// here char limit is 5
                    ],
                    style:
                        InheritedJsonFormTheme.of(context).theme.editTextStyle,
                    cursorColor: InheritedJsonFormTheme.of(context)
                        .theme
                        .editTextCursorColor,
                    //
                    decoration: InheritedJsonFormTheme.of(context)
                        .theme
                        .inputDecoration,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
