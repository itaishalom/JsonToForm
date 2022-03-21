import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:sizer/sizer.dart';

class NameWidgetDescription extends StatelessWidget {
  const NameWidgetDescription(
      {Key? key,
      required this.name,
      this.description,
      this.dateBuilder,
        required this.width,
      this.time,
        required this.id,
      this.componentSameLine = true})
      : super(key: key);

  final String name;
  final String? description;
  final Widget Function(int date, String id)? dateBuilder;
  final int? time;
  final double width;
  final bool componentSameLine;
  final String id;

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
        constraints: componentSameLine ? BoxConstraints(maxWidth: width.w) : null,
        padding: InheritedJsonFormTheme.of(context).theme.nameContainerPadding,
        decoration: InheritedJsonFormTheme.of(context).theme.nameContainerDecoration,
        child: Column(
          mainAxisAlignment: InheritedJsonFormTheme.of(context).theme.mainAxisAlignmentOfName,
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
                      return dateBuilder!(time!, id);
                    },
                  )
                : const SizedBox.shrink()
          ],
        ));
  }
}
