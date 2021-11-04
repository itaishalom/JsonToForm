import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

import 'line_wrapper.dart';
import 'name_description_widget.dart';
class EditTextValue extends StatefulWidget {
  final String? description;
  final String name;
  final int id;
  final String chosenValue;
  final bool isBeforeHeader;

  const EditTextValue(
      {Key? key,
        required this.name,
        required this.id,
        required this.isBeforeHeader,
        this.description,
        required this.chosenValue}): super(key: key);

  @override
  _EditTextValueState createState() => _EditTextValueState();
}

class _EditTextValueState extends State<EditTextValue> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.chosenValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LineWrapper(isBeforeHeader: widget.isBeforeHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          NameWidgetDescription(name: widget.name, description: widget.description),
             Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IntrinsicWidth(
                  child: TextFormField(
                    obscureText: false,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(12), /// here char limit is 5
                    ],
                    style: TextStyle(color: Color(0xffFE753C)),
                    initialValue: widget.chosenValue,
                    cursorColor: Color(0xffFE753C),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff383839), width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffFE753C), width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
              ),
            ),


        ],
      ),
    );
  }
}