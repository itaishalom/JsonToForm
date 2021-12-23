import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

class NameWidgetDescription extends StatelessWidget {
   NameWidgetDescription({Key? key, required this.name, this.description, this.dateBuilder, this.time})
      : super(key: key);

  final String name;
  final String? description;
  final Widget Function(int date)? dateBuilder;
  int? time;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: InheritedJsonFormTheme.of(context).theme.nameContainerPadding,
        decoration:
            InheritedJsonFormTheme.of(context).theme.nameContainerDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Row(
            children: [
              Text(
                name,
                style: InheritedJsonFormTheme.of(context).theme.titleTextStyle,
              ),
              description != null
                  ? const SizedBox(width: 4)
                  : const SizedBox.shrink(),
              description != null
                  ? Text(
                      description!,
                      style: InheritedJsonFormTheme.of(context)
                          .theme
                          .headerTextStyle,
                    )
                  : const SizedBox.shrink(),
            ],
          ), (dateBuilder !=null && time != null)? StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1)),
            builder: (context, snapshot) {
              return dateBuilder!(time!);
            },
          )
              : const SizedBox.shrink()],
        ));
  }
}
