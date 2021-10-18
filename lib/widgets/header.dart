import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/Inherited_json_form_theme.dart';

class Header extends StatelessWidget {
  final String name;

  const Header({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: InheritedJsonFormTheme.of(context).theme.headerContainerPadding,
      decoration: InheritedJsonFormTheme.of(context).theme.headerContainerDecoration,
      child: Text(
        name,
        style: InheritedJsonFormTheme.of(context).theme.headerTextStyle,
      ),
    );
  }
}
