import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

class NameWidgetDescription extends StatelessWidget {

  const NameWidgetDescription({Key? key, required this.name, this.description})
      :super(key: key);

  final String name;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
        InheritedJsonFormTheme
            .of(context)
            .theme
            .nameContainerPadding,
        decoration: InheritedJsonFormTheme
            .of(context)
            .theme
            .nameContainerDecoration,
        child: Row(
          children: [
          Text(
          name,
          style:
          InheritedJsonFormTheme
              .of(context)
              .theme
              .titleTextStyle,
        ),
        description != null
            ? const SizedBox(
            width: 4) : const SizedBox.shrink(),
        description != null
            ? Text(
          description!,
          style: InheritedJsonFormTheme
              .of(context)
              .theme
              .headerTextStyle,
        ) : const SizedBox.shrink(),
    ],
    ));
  }
}
