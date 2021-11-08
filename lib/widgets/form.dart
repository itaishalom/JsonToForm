import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';

class JsonForm extends StatefulWidget {
  final JsonFormTheme theme;
  final List<Widget> widgets;

  const JsonForm({Key? key, required this.theme, required this.widgets})
      : super(key: key);

  @override
  JsonFormState createState() => JsonFormState();
}

class JsonFormState extends State<JsonForm> {
  @override
  Widget build(BuildContext context) {
    return InheritedJsonFormTheme(
        theme: widget.theme,
        child: Scaffold(
            backgroundColor: widget.theme.backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
              },
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return widget.widgets[index];
                    },
                    childCount: widget.widgets.length,
                  ),
                )
              ]),
            )));
  }
}
