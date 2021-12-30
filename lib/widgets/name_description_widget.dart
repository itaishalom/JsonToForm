import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

class NameWidgetDescription extends StatelessWidget {
  const NameWidgetDescription(
      {Key? key,
      required this.name,
      this.description,
      this.dateBuilder,
      this.time,
      this.componentSameLine = true})
      : super(key: key);

  final String name;
  final String? description;
  final Widget Function(int date)? dateBuilder;
  final int? time;
  final bool componentSameLine;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        name,
        style: InheritedJsonFormTheme.of(context).theme.titleTextStyle,
      ),
      description != null
          ? Text(
              description!,
              style: InheritedJsonFormTheme.of(context).theme.headerTextStyle,
            )
          : const SizedBox.shrink(),
    ];

    return Container(
        constraints: componentSameLine
            ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65)
            : null,
        padding: InheritedJsonFormTheme.of(context).theme.nameContainerPadding,
        decoration:
            InheritedJsonFormTheme.of(context).theme.nameContainerDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4,
              children: children,
            ),
            (dateBuilder != null && time != null)
                ? StreamBuilder(
                    stream: Stream.periodic(const Duration(minutes: 1)),
                    builder: (context, snapshot) {
                      return dateBuilder!(time!);
                    },
                  )
                : const SizedBox.shrink()
          ],
        ));
  }
}
